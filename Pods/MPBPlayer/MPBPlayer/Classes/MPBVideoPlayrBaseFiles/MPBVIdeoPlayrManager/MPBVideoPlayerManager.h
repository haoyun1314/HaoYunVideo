//
//  MPBVideoPlayerManager.h
//  Expecta
//
//  Created by 范浩云 on 2017/12/14.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class VIMVideoPlayerView;
@class VIMVideoPlayer;

@protocol MPDVideoPlayerManagerDelegate <NSObject>

@optional
/**
 视频即将播放
 */
- (void)mpdOptionalVideoPlayerViewIsReadyToPlayVideo;

/**
 视频播放结束
 */
- (void)mpdOptionalVideoPlayerViewDidReachEnd;

/**
 视频播放进度
  */
- (void)mpdVideoPlayerTimeChange:(CMTime)cmTime;

/**
视频缓冲进度
 */
- (void)mpdOptionalVideoPlayerViewLoadedTimeRangeDidChange:(float)duration;

/**
视频资源为空开始加载视频
 */
- (void)mpdOptionalVideoPlayerViewPlaybackBufferEmpty;

/**
视频加载完成开始播放视频
 */
- (void)mpdOptionalVideoPlayerViewPlaybackLikelyToKeepUp;

/**
视频播放失败
 */
- (void)mpdOptionalVideoPlayerViewDidFailWithError:(NSError *)error;

/**
重置
 */
- (void)mpdOptionalVideoPlayerIsResetPlayerItemIfNecessary;


/**
视频是否在加载
 */
- (void)mpdOptionaVideoPlayerVisVideoLoading:(BOOL)isLoading;


@end


@interface MPBVideoPlayerManager : NSObject

// 封装之后的播放器delegate
@property (nonatomic, weak) id<MPDVideoPlayerManagerDelegate> delegate;

/**
 单例函数
 
 @return 返回单例对象
 */
+ (MPBVideoPlayerManager *)sharedInstance;

/**
 将avplayer添加到目标view中去
 
 @param aView 目标view
 */
- (void)addPlayerViewToTargetView:(UIView *)aView;



/**
 播放
 */
- (void)play;

/**
 暂停
 */
- (void)pause;

/**
 设置视频填充模式
 
 @param aStrFill 填充模式   AVLayerVideoGravityResizeAspectFill
 */
- (void)setVideoFillMode:(NSString *)aStrFill;

/**
 销毁当前播放器资源
 */
- (void)resetVideoPlayer;

/**
 设置视频的播放地址
 
 @param aStrVideoURL 视频可播放的url
 */
- (void)setVideoURL:(NSString *)aStrVideoURL;

/**
 替换和设置当前播放器资源item
 
 @param aPlayerItem  替换和设置当前播放器资源item
 
 */
- (void)setPlayerItem:(AVPlayerItem *)aPlayerItem;

/**
 设置视频播放器的AVAsset
 
 @param aAsset 视频播放器需要的AVAsset
 */
- (void)setAsset:(AVAsset *)aAsset;

/**
 设置播放器是否静音
 
 @param aIsMute YES:静音  NO:不静音
 */
- (void)setVideoPlayerMute:(BOOL)aIsMute;

/**
 设置循环播放
 
 @param aIsLooping YES:循环播放 NO:播放一遍
 */
-(void)setVideoPlayerLooping:(BOOL)aIsLooping;

/**
 seek操作播放器
 
 @param time 需要seek的时间
 */
- (void)seekToTime:(float)time;



/**
 获取当前播放器的当前播放时长
 */
- (CGFloat )getVideoPlayerCurrentTime;

/**
 当前播放器是否正在播放
 
 @return 是否正在播放
 */
- (BOOL)videoIsPlaying;



/**
 当前播放器是否正在加载
 
 @return 是否正在加载
 */
- (BOOL)videoIsLoading;

/**
 当前播放器是不是循环播放
 
 @return 是否为循环播放
 */
- (BOOL)videoIsLooping;

/**
 当前播放器是不是静音
 
 @return 是否为静音  YES:静音  NO:非静音
 */
- (BOOL)videoIsMuted;

/**
 当前播放的总时长
 
 @return 播放总时长
 */
- (CGFloat)getVideoTotalDuration;

/**
 进度条拖动的过程中
 
 */
- (void)scrub:(float)time;


@end
