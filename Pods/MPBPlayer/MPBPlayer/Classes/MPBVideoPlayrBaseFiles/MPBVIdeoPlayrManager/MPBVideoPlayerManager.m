//
//  MPBVideoPlayerManager.m
//  Expecta
//
//  Created by 范浩云 on 2017/12/14.
//

#import "MPBVideoPlayerManager.h"
#import "VIMVideoPlayerView.h"
#import "VIMVideoPlayer.h"
#import "Masonry.h"
#import "MPBPlayerReachability.h"

@interface MPBVideoPlayerManager ()<VIMVideoPlayerViewDelegate>

//播放器view
@property (nonatomic, strong) VIMVideoPlayerView *vimPlayerView;

//
@property (nonatomic, strong) MPBPlayerReachability *reachability;


@end


@implementation MPBVideoPlayerManager

static MPBVideoPlayerManager *sharedInstance = nil;


/**
 单例函数
 
 @return 返回单例对象
 */
+ (MPBVideoPlayerManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once (&onceToken, ^ {
        sharedInstance = [[MPBVideoPlayerManager alloc] init];
    });
    
    return  sharedInstance;
}

-(id)init
{
    self = [super init];
    
    if(self)
    {
        
//        self.reachability = [MPBPlayerReachability reachabilityWithHostName_MPBPlayer:@"www.hcios.com"];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(reachabilityChanged:)name:kMPBPlayerReachabilityChangedNotification
//                                                   object:nil];
//        [self.reachability startNotifier_MPBPlayer];
    }
    
    return self;
}



/**
 创建播放器
 */
- (VIMVideoPlayerView *)configVIMVideoPlayerView
{
    self.vimPlayerView = [[VIMVideoPlayerView alloc] init];
    self.vimPlayerView.delegate = self;
    [self.vimPlayerView.player setMuted:NO];
    self.vimPlayerView.clipsToBounds = YES;
    [self.vimPlayerView.player enableTimeUpdates];
    return _vimPlayerView;
}



#pragma mark - ************************************ 对外函数 **************************************

/**
 将avplayer添加到目标view中去
 
 @param aView 目标view
 */
- (void)addPlayerViewToTargetView:(UIView *)aView
{
    if (aView) {
        [self.vimPlayerView removeFromSuperview];
        [aView addSubview:[self configVIMVideoPlayerView]];
        [self.vimPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(aView);
        }];
    }
}

/**
 播放
 */
- (void)play
{
    [self.vimPlayerView.player play];
}

/**
 暂停
 */
- (void)pause
{
    [self.vimPlayerView.player pause];
}

/**
 设置视频填充模式
 
 @param aStrFill 填充模式
 */
- (void)setVideoFillMode:(NSString *)aStrFill
{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStrFill stringByTrimmingCharactersInSet:set];
    if ((!aStrFill) || [aStrFill isKindOfClass:[NSNull class]] ||(!trimmedStr.length))
    {
        return;
    }
    [self.vimPlayerView setVideoFillMode:aStrFill];
}

/**
 重置播放器
 */
- (void)resetVideoPlayer
{
    self.vimPlayerView.hidden = YES;
    [self.vimPlayerView removeFromSuperview];
    [self.vimPlayerView.player disableTimeUpdates];//移除进度的观察者
    [self.vimPlayerView.player reset];
}

/**
 设置视频的播放地址
 
 @param aStrVideoURL 视频可播放的url
 */
- (void)setVideoURL:(NSString *)aStrVideoURL
{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStrVideoURL stringByTrimmingCharactersInSet:set];
    if ((!aStrVideoURL) || [aStrVideoURL isKindOfClass:[NSNull class]] ||(!trimmedStr.length))
    {
        return;
    }
    NSString *tempStr = [aStrVideoURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:tempStr];
    AVPlayerItem *playItem = [AVPlayerItem playerItemWithURL:url];
    [self.vimPlayerView.player setPlayerItem:playItem];
}

/**
 设置视频播放器的item
 
 @param aPlayerItem 视频播放需要的item
 */
- (void)setPlayerItem:(AVPlayerItem *)aPlayerItem
{
    if(aPlayerItem)
    {
        [self.vimPlayerView.player setPlayerItem:aPlayerItem];
    }
}

/**
 设置视频播放器的AVAsset
 
 @param aAsset 视频播放器需要的AVAsset
 */
- (void)setAsset:(AVAsset *)aAsset
{
    if(aAsset)
    {
        [self.vimPlayerView.player setAsset:aAsset];
    }
}

/**
 设置播放器是否静音
 
 @param aIsMute YES:静音  NO:不静音
 */
- (void)setVideoPlayerMute:(BOOL)aIsMute
{
    self.vimPlayerView.player.muted = aIsMute;
}

/**
 设置循环播放
 
 @param aIsLooping YES:循环播放 NO:播放一遍
 */
-(void)setVideoPlayerLooping:(BOOL)aIsLooping
{
    [self.vimPlayerView.player setLooping:aIsLooping];
}

/**
 seek操作播放器
 
 @param time 需要seek的时间
 */
- (void)seekToTime:(float)time
{
    if(time >= 0.0f)
    {
        [self.vimPlayerView.player seekToTime:time];
    }
    else
    {
        [self.vimPlayerView.player seekToTime:0.0f];
    }
}

/**
 获取当前播放器的当前播放时长
 
 @return 播放视频时长
 */
- (CGFloat )getVideoPlayerCurrentTime
{
    return [self.vimPlayerView.player getCurrentPlayTime];
}

/**
 当前播放器是否正在播放
 
 @return 是否正在播放
 */
- (BOOL)videoIsPlaying
{
    return self.vimPlayerView.player.isPlaying;
}



/**
 当前播放器是否正在加载
 
 @return 是否正在加载
 */
- (BOOL)videoIsLoading
{
    return self.vimPlayerView.player.isLoading;
}

/**
 当前播放器是不是循环播放
 
 @return 是否为循环播放
 */
- (BOOL)videoIsLooping
{
    return self.vimPlayerView.player.isLooping;
}

/**
 当前播放器是不是静音
 
 @return 是否为静音
 */
- (BOOL)videoIsMuted
{
    return self.vimPlayerView.player.isMuted;
}

/**
 当前播放的总时长
 
 @return 播放总时长
 */
- (CGFloat)getVideoTotalDuration
{
    return [self.vimPlayerView.player getCurrentItemTotalPlayDuration];
}



/**
 进度条拖动的过程中
 
 */
- (void)scrub:(float)time
{
    [self.vimPlayerView.player scrub:time];
}


-(void)reachabilityChanged:(NSNotification*)notification
{
    MPBPlayerReachability *reach = (MPBPlayerReachability *)notification.object;
    //判断网络状态
    
    if([MPBPlayerReachability isNotReachable_MPBPlayer])
    {
//        NSLog(@"网络连接不可用");
    }
    else
    {
        if([reach currentReachabilityStatus] == MPBPlayerReachableViaWiFi)
        {
//            NSLog(@"正在使用WiFi");
        }
        else if([reach currentReachabilityStatus] == MPBPlayerReachableViaWWAN)
        {
//            NSLog(@"正在使用移动数据");
        }
    }
}


#pragma mark - *************************** VIMVideoPlayerViewDelegate *****************************

- (void)videoPlayerViewIsReadyToPlayVideo:(VIMVideoPlayerView *)videoPlayerView
{
    if ([self.delegate respondsToSelector:@selector(mpdOptionalVideoPlayerViewIsReadyToPlayVideo)])
    {
        [self.delegate mpdOptionalVideoPlayerViewIsReadyToPlayVideo];
    }
}

- (void)videoPlayerViewDidReachEnd:(VIMVideoPlayerView *)videoPlayerView
{
    if ([self.delegate respondsToSelector:@selector(mpdOptionalVideoPlayerViewDidReachEnd)])
    {
        [self.delegate mpdOptionalVideoPlayerViewDidReachEnd];
    }
}

- (void)videoPlayerView:(VIMVideoPlayerView *)videoPlayerView timeDidChange:(CMTime)cmTime
{
    if ([self.delegate respondsToSelector:@selector(mpdVideoPlayerTimeChange:)])
    {
        [self.delegate mpdVideoPlayerTimeChange:cmTime];
    }
}

- (void)videoPlayerView:(VIMVideoPlayerView *)videoPlayerView loadedTimeRangeDidChange:(float)duration
{
    if ([self.delegate respondsToSelector:@selector(mpdOptionalVideoPlayerViewLoadedTimeRangeDidChange:)])
    {
        [self.delegate mpdOptionalVideoPlayerViewLoadedTimeRangeDidChange:duration];
    }
}

- (void)videoPlayerViewPlaybackBufferEmpty:(VIMVideoPlayerView *)videoPlayerView
{
    if ([self.delegate respondsToSelector:@selector(mpdOptionalVideoPlayerViewPlaybackBufferEmpty)])
    {
        [self.delegate mpdOptionalVideoPlayerViewPlaybackBufferEmpty];
    }
}

- (void)videoPlayerViewPlaybackLikelyToKeepUp:(VIMVideoPlayerView *)videoPlayerView
{
    if ([self.delegate respondsToSelector:@selector(mpdOptionalVideoPlayerViewPlaybackLikelyToKeepUp)])
    {
        [self.delegate mpdOptionalVideoPlayerViewPlaybackLikelyToKeepUp];
    }
}

- (void)videoPlayerView:(VIMVideoPlayerView *)videoPlayerView didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(mpdOptionalVideoPlayerViewDidFailWithError:)])
    {
        [self.delegate mpdOptionalVideoPlayerViewDidFailWithError:error];
    }
}

- (void)videoPlayerIsResetPlayerItemIfNecessary:(VIMVideoPlayerView*)videoPlayerView
{
    if ([self.delegate respondsToSelector:@selector(mpdOptionalVideoPlayerIsResetPlayerItemIfNecessary)])
    {
        [self.delegate mpdOptionalVideoPlayerIsResetPlayerItemIfNecessary];
    }
}

- (void)videoPlayerView:(VIMVideoPlayerView *)videoPlayerView isVideoLoading:(BOOL)isLoading
{
    if ([self.delegate respondsToSelector:@selector(mpdOptionaVideoPlayerVisVideoLoading:)])
    {
        [self.delegate mpdOptionaVideoPlayerVisVideoLoading:isLoading];
    }
}

@end

