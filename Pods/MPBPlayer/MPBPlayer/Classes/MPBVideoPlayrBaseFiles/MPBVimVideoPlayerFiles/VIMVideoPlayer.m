//
//  VideoPlayer.m
//  Vimeo
//
//  Created by Alfred Hanssen on 2/9/14.
//  Copyright (c) 2014-2015 Vimeo (https://vimeo.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "VIMVideoPlayer.h"

static const float DefaultPlayableBufferLength = 2.0f;
static const float DefaultVolumeFadeDuration = 1.0f;
static const float TimeObserverInterval = 0.01f;

NSString * const kVideoPlayerErrorDomain = @"kVideoPlayerErrorDomain";

static void *VideoPlayer_PlayerItemStatusContext = &VideoPlayer_PlayerItemStatusContext;
static void *VideoPlayer_PlayerExternalPlaybackActiveContext = &VideoPlayer_PlayerExternalPlaybackActiveContext;
static void *VideoPlayer_PlayerRateChangedContext = &VideoPlayer_PlayerRateChangedContext;
static void *VideoPlayer_PlayerItemPlaybackLikelyToKeepUp = &VideoPlayer_PlayerItemPlaybackLikelyToKeepUp;
static void *VideoPlayer_PlayerItemPlaybackBufferEmpty = &VideoPlayer_PlayerItemPlaybackBufferEmpty;

static void *VideoPlayer_PlayerItemLoadedTimeRangesContext = &VideoPlayer_PlayerItemLoadedTimeRangesContext;

@interface VIMVideoPlayer ()

@property (nonatomic, strong, readwrite) AVPlayer *player;

//@property (nonatomic, assign, getter=isPlaying, readwrite) BOOL playing;
@property (nonatomic, assign, getter=isScrubbing) BOOL scrubbing;
@property (nonatomic, assign, getter=isSeeking) BOOL seeking;
@property (nonatomic, assign) BOOL isAtEndTime;
@property (nonatomic, assign) BOOL shouldPlayAfterScrubbing;

@property (nonatomic, assign) float volumeFadeDuration;
@property (nonatomic, assign) float playableBufferLength;

@property (nonatomic, assign) BOOL isTimingUpdateEnabled;
@property (nonatomic, strong) id timeObserverToken;

@property (nonatomic, strong) AVPlayerItem *item;

@end

@implementation VIMVideoPlayer

- (void)dealloc
{
    NSLog(@"VIMVideoPlayer========================");
    [self resetPlayerItemIfNecessary];
    
    [self removePlayerObservers];
    
    [self removeTimeObserver];
    
    [self cancelFadeVolume];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _volumeFadeDuration = DefaultVolumeFadeDuration;
        _playableBufferLength = DefaultPlayableBufferLength;
        
        [self setupPlayer];
        
        [self addPlayerObservers];

        [self setupAudioSession];
    }
    
    return self;
}

#pragma mark - Setup

/**
创建播放器
 */
- (void)setupPlayer
{
    self.player = [[AVPlayer alloc] init];
    self.muted = NO;
    self.looping = NO;
    self.loading = NO;
    [self setVolume:1.0f];
    [self enableTimeUpdates];
    [self enableAirplay];
}

- (void)setupAudioSession
{
    NSError *categoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&categoryError];
    if (!success)
    {
        NSLog(@"Error setting audio session category: %@", categoryError);
    }
    
    NSError *activeError = nil;
    success = [[AVAudioSession sharedInstance] setActive:YES error:&activeError];
    if (!success)
    {
        NSLog(@"Error setting audio session active: %@", activeError);
    }
}

#pragma mark - Public API

- (void)setURL:(NSURL *)URL
{
    if (URL == nil)
    {
        return;
    }

    [self resetPlayerItemIfNecessary];

    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:URL];
    if (!playerItem)
    {
        [self reportUnableToCreatePlayerItem];
        
        return;
    }

    [self preparePlayerItem:playerItem];
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    if (playerItem == nil)
    {
        return;
    }
    
    [self resetPlayerItemIfNecessary];

    [self preparePlayerItem:playerItem];
}

- (void)setAsset:(AVAsset *)asset
{
    if (asset == nil)
    {
        return;
    }

    [self resetPlayerItemIfNecessary];
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:asset automaticallyLoadedAssetKeys:@[NSStringFromSelector(@selector(tracks))]];
    if (!playerItem)
    {
        [self reportUnableToCreatePlayerItem];
        
        return;
    }
    
    [self preparePlayerItem:playerItem];
}

#pragma mark - Accessor Overrides
//设置静音
- (void)setMuted:(BOOL)muted
{
    if (self.player)
    {
        self.player.muted = muted;
    }
}

-(void)setLooping:(BOOL)looping
{
    _looping = looping;
}

- (BOOL)isMuted
{
    return self.player.isMuted;
}

#pragma mark - Playback

/**
 播放
 */
- (void)play
{
    if (self.player.currentItem == nil)
    {
        return;
    }
    
    self.playing = YES;
   
    if ([self.player.currentItem status] == AVPlayerItemStatusReadyToPlay)
    {
        if ([self isAtEndTime])
        {
            [self restart];
        }
        else
        {
            [self.player play];
        }
    }
}

/**
 暂停
 */
- (void)pause
{
    self.playing = NO;
    
    [self.player pause];
}


/**
 快进
 */
- (void)seekToTime:(float)time
{
    if (_seeking)
    {
        return;
    }
    
    if (self.player)
    {
        CMTime cmTime = CMTimeMakeWithSeconds(time, self.player.currentTime.timescale);
        
        if (CMTIME_IS_INVALID(cmTime) || self.player.currentItem.status != AVPlayerStatusReadyToPlay)
        {
            return;
        }
        
        _seeking = YES;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self.player seekToTime:cmTime completionHandler:^(BOOL finished) {
                
                _isAtEndTime = NO;
                _seeking = NO;

                if (finished)
                {
                    _scrubbing = NO;
                }
                
            }];
        });
    }
}

/**
 重置播放器
 */
- (void)reset
{
    [self pause];
    [self resetPlayerItemIfNecessary];
}

#pragma mark - Airplay

- (void)enableAirplay
{
    if (self.player)
    {
        self.player.allowsExternalPlayback = YES;
    }
}

- (void)disableAirplay
{
    if (self.player)
    {
        self.player.allowsExternalPlayback = NO;
    }
}

- (BOOL)isAirplayEnabled
{
    return (self.player && self.player.allowsExternalPlayback);
}

#pragma mark - Scrubbing

/**
 开始滑动进度条的时候进行处理
 */
- (void)startScrubbing
{
    self.scrubbing = YES;
    
    if (self.isPlaying)
    {
        self.shouldPlayAfterScrubbing = YES;

        [self pause];
    }
}


/**
 滑动过程中

 @param time 快进快退的时间
 */
- (void)scrub:(float)time
{
    if (self.isScrubbing == NO)
    {
        [self startScrubbing];
    }
    
    [self.player.currentItem cancelPendingSeeks];
    
    [self seekToTime:time];
}

- (void)stopScrubbing
{
    if (self.shouldPlayAfterScrubbing)
    {
        [self play];

        self.shouldPlayAfterScrubbing = NO;
    }

    self.scrubbing = NO;
}

#pragma mark - Time Updates

- (void)enableTimeUpdates
{
    self.isTimingUpdateEnabled = YES;
    
    [self addTimeObserver];
}

- (void)disableTimeUpdates
{
    self.isTimingUpdateEnabled = NO;
    
    [self removeTimeObserver];
}

#pragma mark - Volume

/**
 volume *表示播放器的当前音量;0.0表示“静默所有音频”，1.0表示“播放当前项的全部音量”。iOS注意:不要使用此属性来实现媒体播放的音量滑块。为此，使用MPVolumeView，它在外观上是可定制的，并提供用户期望的标准媒体播放行为。该属性在iOS中最有用，用于控制AVPlayer相对于其他音频输出的音量，而不是用于终端用户的音量控制。
 */
- (void)setVolume:(float)volume
{
    [self cancelFadeVolume];
    
    self.player.volume = volume;
}

- (void)cancelFadeVolume
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeInVolume) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutVolume) object:nil];
}

- (void)fadeInVolume
{
    if (self.player == nil)
    {
        return;
    }
    
    [self cancelFadeVolume];
    
    if (self.player.volume >= 1.0f - 0.01f)
    {
        self.player.volume = 1.0f;
    }
    else
    {
        self.player.volume += 1.0f/10.0f;
        
        [self performSelector:@selector(fadeInVolume) withObject:nil afterDelay:self.volumeFadeDuration/10.0f];
    }
}

- (void)fadeOutVolume
{
    if (self.player == nil)
    {
        return;
    }
    
    [self cancelFadeVolume];
    
    if (self.player.volume <= 0.01f)
    {
        self.player.volume = 0.0f;
    }
    else
    {
        self.player.volume -= 1.0f/10.0f;
        
        [self performSelector:@selector(fadeOutVolume) withObject:nil afterDelay:self.volumeFadeDuration/10.0f];
    }
}

#pragma mark - Private API

/**
 无法创建播放资源
 */
- (void)reportUnableToCreatePlayerItem
{
    if ([self.delegate respondsToSelector:@selector(videoPlayer:didFailWithError:)])
    {
        NSError *error = [NSError errorWithDomain:kVideoPlayerErrorDomain
                                             code:0
                                         userInfo:@{NSLocalizedDescriptionKey : @"Unable to create AVPlayerItem."}];
        
        [self.delegate videoPlayer:self didFailWithError:error];
    }
}

/**
 重置播资源
 */
- (void)resetPlayerItemIfNecessary
{
    if (self.item)
    {
        //移除手机资源的观察者
        [self removePlayerItemObservers:self.item];
        
        //把当前的播放资源置空
        //[self.player replaceCurrentItemWithPlayerItem:nil];
        
        self.item = nil;
    }
    _volumeFadeDuration = DefaultVolumeFadeDuration;
    _playableBufferLength = DefaultPlayableBufferLength;
    _playing = NO;
    _isAtEndTime = NO;
    _scrubbing = NO;
}

/**
 重新设置播资源

 @param playerItem 播放资源
 */
- (void)preparePlayerItem:(AVPlayerItem *)playerItem
{
    NSParameterAssert(playerItem);
    
    self.item = playerItem;
    
    [self addPlayerItemObservers:playerItem];
    
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
}

- (void)restart
{
    [self.player seekToTime:kCMTimeZero toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        
        if (finished)
        {
            _isAtEndTime = NO;
         
            if (self.isPlaying)
            {
                [self play];
            }
        }
        
    }];
}


/**
 判断当前视频是否播放结束
 @return YES:播放结束 NO:没有播放完毕
 */
- (BOOL)isAtEndTime // TODO: this is a fucked up override, seems like something could be wrong [AH]
{
    if (self.player && self.player.currentItem)
    {
        if (_isAtEndTime)
        {
            return _isAtEndTime;
        }
        
        float currentTime = 0.0f;
        //如果获取的CMTime是有效的
        if (CMTIME_IS_INVALID(self.player.currentTime) == NO)
        {
            //获取当前播放视时间
            currentTime = CMTimeGetSeconds(self.player.currentTime);
        }
        
        float videoDuration = 0.0f;
        //如果获取当前视频总的时间是有效的
        if (CMTIME_IS_INVALID(self.player.currentItem.duration) == NO)
        {
        //获取当前播放视频的总的播放时长
            videoDuration = CMTimeGetSeconds(self.player.currentItem.duration);
        }
        //当前播放时长大于零并且总的播放时长大于零
        if (currentTime > 0.0f && videoDuration > 0.0f)
        {
            //当前播放时长减去总时长误差绝对值 < 0.01 表示播放结束
            if (fabs(currentTime - videoDuration) <= 0.01f)
            {
                return YES;
            }
        }
    }
    
    return NO;
}

/**
 获取视频的缓冲进度

 @return 返回视频的缓冲进度
 */
- (float)calcLoadedDuration
{
    float loadedDuration = 0.0f;
    
    if (self.player && self.player.currentItem)
    {
        NSArray *loadedTimeRanges = self.player.currentItem.loadedTimeRanges;
        
        if (loadedTimeRanges && [loadedTimeRanges count])
        {
            CMTimeRange timeRange = [[loadedTimeRanges firstObject] CMTimeRangeValue];
            float startSeconds = CMTimeGetSeconds(timeRange.start);
            float durationSeconds = CMTimeGetSeconds(timeRange.duration);
            
            loadedDuration = startSeconds + durationSeconds;
        }
    }
    
    return loadedDuration;
}

#pragma mark - Player Observers

- (void)addPlayerObservers
{
    [self.player addObserver:self
                  forKeyPath:NSStringFromSelector(@selector(isExternalPlaybackActive))
                     options:NSKeyValueObservingOptionNew
                     context:VideoPlayer_PlayerExternalPlaybackActiveContext];
    
    [self.player addObserver:self
                  forKeyPath:NSStringFromSelector(@selector(rate))
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:VideoPlayer_PlayerRateChangedContext];
}

- (void)removePlayerObservers
{
    @try
    {
        [self.player removeObserver:self
                         forKeyPath:NSStringFromSelector(@selector(isExternalPlaybackActive))
                            context:VideoPlayer_PlayerExternalPlaybackActiveContext];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception removing observer: %@", exception);
    }
    
    @try
    {
        [self.player removeObserver:self
                         forKeyPath:NSStringFromSelector(@selector(rate))
                            context:VideoPlayer_PlayerRateChangedContext];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception removing observer: %@", exception);
    }
}

#pragma mark - PlayerItem Observers

/**
 监测播放资源的各种状态

 @param playerItem 播放资源
 */
- (void)addPlayerItemObservers:(AVPlayerItem *)playerItem
{
    [playerItem addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(status))
                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                    context:VideoPlayer_PlayerItemStatusContext];
    
    [playerItem addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(isPlaybackLikelyToKeepUp))
                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                    context:VideoPlayer_PlayerItemPlaybackLikelyToKeepUp];
    
    [playerItem addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(isPlaybackBufferEmpty))
                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                    context:VideoPlayer_PlayerItemPlaybackBufferEmpty];
    
    [playerItem addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(loadedTimeRanges))
                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                    context:VideoPlayer_PlayerItemLoadedTimeRangesContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidPlayToEndTime:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:playerItem];
}

- (void)removePlayerItemObservers:(AVPlayerItem *)playerItem
{
    [playerItem cancelPendingSeeks];
    
    @try
    {
        [playerItem removeObserver:self
                        forKeyPath:NSStringFromSelector(@selector(status))
                           context:VideoPlayer_PlayerItemStatusContext];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception removing observer: %@", exception);
    }

    @try
    {
        [playerItem removeObserver:self
                        forKeyPath:NSStringFromSelector(@selector(isPlaybackLikelyToKeepUp))
                           context:VideoPlayer_PlayerItemPlaybackLikelyToKeepUp];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception removing observer: %@", exception);
    }

    @try
    {
        [playerItem removeObserver:self
                        forKeyPath:NSStringFromSelector(@selector(isPlaybackBufferEmpty))
                           context:VideoPlayer_PlayerItemPlaybackBufferEmpty];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception removing observer: %@", exception);
    }

    @try
    {
        [playerItem removeObserver:self
                        forKeyPath:NSStringFromSelector(@selector(loadedTimeRanges))
                           context:VideoPlayer_PlayerItemLoadedTimeRangesContext];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception removing observer: %@", exception);
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
}

#pragma mark - Time Observer


/**
 (1）方法传入一个CMTime结构体，每到一定时间都会回调一次，包括开始和结束播放
 (2）如果block里面的操作耗时太长，下次不一定会收到回调，所以尽量减少block的操作耗时
 (3）方法会返回一个观察者对象，当播放完毕时需要移除这个观察者
 */
- (void)addTimeObserver
{
    if (self.timeObserverToken || self.player == nil)
    {
        return;
    }
    __weak typeof (self) weakSelf = self;
    self.timeObserverToken = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(TimeObserverInterval, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        __strong typeof (self) strongSelf = weakSelf;
        if (!strongSelf)
        {
            return;
        }
        
        if ([strongSelf.delegate respondsToSelector:@selector(videoPlayer:timeDidChange:)])
        {
            [strongSelf.delegate videoPlayer:strongSelf timeDidChange:time];
        }
        
    }];
}

- (void)removeTimeObserver
{
    if (self.timeObserverToken == nil)
    {
        return;
    }
 
    if (self.player)
    {
        [self.player removeTimeObserver:self.timeObserverToken];
    }
    
    self.timeObserverToken = nil;
}

#pragma mark - Observer Response

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == VideoPlayer_PlayerRateChangedContext)
    {
        if (self.isScrubbing == NO && self.isPlaying && self.player.rate == 0.0f)
        {
          
            if (self.isLoading == NO)
            {
                self.loading =  YES;
                if (self.delegate && [self.delegate respondsToSelector:@selector(videoplayer:isVideoLoading:)])
                {
                    [self.delegate videoplayer:self isVideoLoading:YES];
                }
            }
            
        }
    }
    else if (context == VideoPlayer_PlayerItemStatusContext)//获取播放的状态
    {
        AVPlayerStatus newStatus = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        AVPlayerStatus oldStatus = [[change objectForKey:NSKeyValueChangeOldKey] integerValue];
        
        if (newStatus != oldStatus)
        {//第一次加载新视频
            switch (newStatus)
            {   //表示目前播放器的状态还不知道，因为它没有尝试加载新的媒体资源来回放
                case AVPlayerItemStatusUnknown:
                {
                    NSLog(@"Video player Status Unknown");
                    break;
                }
                //开始播放视频
                case AVPlayerItemStatusReadyToPlay:
                {
                    if (self.isLoading ==YES) 
                    {
                        self.loading = NO;
                        if (self.delegate && [self.delegate respondsToSelector:@selector(videoplayer:isVideoLoading:)])
                        {
                            dispatch_async(dispatch_get_main_queue(), ^
                                           {
                                               [self.delegate videoplayer:self isVideoLoading:NO];
                                           });
                        }
                    }
                    
                    if ([self.delegate respondsToSelector:@selector(videoPlayerIsReadyToPlayVideo:)])
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.delegate videoPlayerIsReadyToPlayVideo:self];
                        });
                    }
                    
                    if (self.isPlaying)
                    {
                        [self play];
                    }
                    
                    break;
                }
                //播放失败
                case AVPlayerItemStatusFailed:
                {
                    NSLog(@"Video player Status Failed: player item error = %@", self.player.currentItem.error);
                    NSLog(@"Video player Status Failed: player error = %@", self.player.error);
                    
                    NSError *error = self.player.error;
                    if (!error)
                    {
                        error = self.player.currentItem.error;
                    }
                    else
                    {
                        error = [NSError errorWithDomain:kVideoPlayerErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"unknown player error, status == AVPlayerItemStatusFailed"}];
                    }
                    
                    [self reset];//播放失败重置播放器

                    if ([self.delegate respondsToSelector:@selector(videoPlayer:didFailWithError:)])
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.delegate videoPlayer:self didFailWithError:error];
                        });
                    }
                    
                    break;
                }
            }
        }
        //开始播放视频
        else if (newStatus == AVPlayerItemStatusReadyToPlay)
        {
            // When playback resumes after a buffering event, a new ReadyToPlay status is set [RH]
            
            if ([self.delegate respondsToSelector:@selector(videoPlayerPlaybackLikelyToKeepUp:)])
            {
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    
                    [self.delegate videoPlayerPlaybackLikelyToKeepUp:self];
                });
            }
            
            if (self.isLoading ==YES)
            {
                self.loading = NO;
                if (self.delegate && [self.delegate respondsToSelector:@selector(videoplayer:isVideoLoading:)])
                {
                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
                                       
                                       [self.delegate videoplayer:self isVideoLoading:NO];
                                   });
                }
            }
            
        }
    }
     // 当缓冲是空的时候
    else if (context == VideoPlayer_PlayerItemPlaybackBufferEmpty)
    {
        if (self.player.currentItem.playbackBufferEmpty)
        {
            if (self.isPlaying)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    if ([self.delegate respondsToSelector:@selector(videoPlayerPlaybackBufferEmpty:)])
                    {
                        [self.delegate videoPlayerPlaybackBufferEmpty:self];
                    }
                    
                    if (self.isLoading ==NO)
                    {
                        self.loading = YES;
                        if (self.delegate && [self.delegate respondsToSelector:@selector(videoplayer:isVideoLoading:)])
                        {
                            [self.delegate videoplayer:self isVideoLoading:YES];
                        }
                    }
                });
            }
        }
    }
    else if (context == VideoPlayer_PlayerItemPlaybackLikelyToKeepUp)
    {
         // 当缓冲好的时候
        if (self.player.currentItem.playbackLikelyToKeepUp )
        {
            // TODO: Hide loading indicator
            if (self.isLoading ==YES)
            {
                self.loading = NO;
                if (self.delegate && [self.delegate respondsToSelector:@selector(videoplayer:isVideoLoading:)])
                {
                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
                                       [self.delegate videoplayer:self isVideoLoading:NO];
                                   });
                }
            }
            if (self.isScrubbing == NO && self.isPlaying && self.player.rate == 0.0f)
            {
                [self play];
            }
        }
    }
    //计算缓冲进度
    else if (context == VideoPlayer_PlayerItemLoadedTimeRangesContext)
    {
        //获取缓冲进度
        float loadedDuration = [self calcLoadedDuration];
        //停止滑动-视频在播放中的状态-视频没有播放-
        if (self.isScrubbing == NO && self.isPlaying && self.player.rate == 0.0f)
        {
            //缓冲的总时长超过2秒-播放视频
            if (loadedDuration >= CMTimeGetSeconds(self.player.currentTime) + self.playableBufferLength)
            {
                if (self.isLoading ==YES)
                {
                    self.loading = NO;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(videoplayer:isVideoLoading:)])
                    {
                        dispatch_async(dispatch_get_main_queue(), ^
                                       {
                        [self.delegate videoplayer:self isVideoLoading:NO];
                                       });
                    }
                }
                
                [self play];
            }
            else
            {
                if (self.isLoading ==NO)
                {
                    self.loading = YES;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(videoplayer:isVideoLoading:)])
                    {  dispatch_async(dispatch_get_main_queue(), ^
                        {
                    [self.delegate videoplayer:self isVideoLoading:YES];});
                    }
                }
            }
        }
        //更新缓冲
        if ([self.delegate respondsToSelector:@selector(videoPlayer:loadedTimeRangeDidChange:)])
        {
            [self.delegate videoPlayer:self loadedTimeRangeDidChange:loadedDuration];
        }
    }
    //在线播放视频，目前不知道有啥作用
    else if (context == VideoPlayer_PlayerExternalPlaybackActiveContext)
    {
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}

/**
 视频播完毕

 */
- (void)playerItemDidPlayToEndTime:(NSNotification *)notification
{
    if (notification.object != self.player.currentItem)
    {
        return;
    }
    if (self.isLoading ==YES)
    {
        self.loading = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoplayer:isVideoLoading:)])
        {  dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate videoplayer:self isVideoLoading:NO];
            });
        }
    }
    
    if (self.isLooping)
    {
        [self restart];
    }
    else
    {
        _isAtEndTime = YES;
        self.playing = NO;
    }
        
    if ([self.delegate respondsToSelector:@selector(videoPlayerDidReachEnd:)])
    {
        [self.delegate videoPlayerDidReachEnd:self];
    }
}

/**
 获取当前视频的总时长
 */
-(CGFloat )getCurrentItemTotalPlayDuration
{
    return CMTimeGetSeconds(self.player.currentItem.duration);
}

/**
 获取当前播放时长
 */
-(CGFloat )getCurrentPlayTime
{
    return   CMTimeGetSeconds(self.player.currentTime);
}



@end
