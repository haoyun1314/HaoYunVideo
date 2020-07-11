 //
//  CommonVideoPlayerView.m
//  Pods
//
//  Created by 范浩云 on 2017/12/14.
//
//


#import "CommonVideoPlayerView.h"
#import "Masonry.h"
#import "MPBVideoPlayerManager.h"

@interface CommonVideoPlayerView ()<MPDVideoPlayerManagerDelegate>

//播放器的父视图
@property (nonatomic, strong) UIView * commmonPlaySuperView;
//视频的URL
@property (nonatomic, strong) NSURL                  *videoURL;

@end


@implementation CommonVideoPlayerView


#pragma mark - ********************** View Lifecycle **********************

- (void)dealloc
{
    // 一定要关注这个函数是否被执行了！！！
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // 注册消息
        [self regNotification];
        
        // 初始化变量
        [self initVariable];
        
        // 创建相关子view
        [self initMainViews];
    }
    
    return self;
}



#pragma mark - ********************** init and config **********************

/**
 TODO: 初始化变量，例如：分页的page可以在该函数中赋初值
 */
- (void)initVariable
{
    
}

/**
 TODO: 创建相关子view
 */
- (void)initMainViews
{
    
}

/**
 TODO: 注册通知
 */
- (void)regNotification
{
    
}


#pragma mark - ******************************************* 对外方法 **********************************

- (void)setPlayReloadWithStyle:(MPE_GetPlayUrlMethod)style
                     playModel:(MPVPVideoPlayerModel *)playModel
{
    self.videoPlayModel = playModel;
    switch (style)
    {
        case MPE_DirectGetUrl:
        {
            [self addPlayWithUrl:self.videoPlayModel.videoUrlString];
            break;
        }
        case MPE_MergeGetUrl://保留扩展
        {
           
            
            break;
        }
        case MPE_RequesetUrl://保留扩展
        {
            break;
        }
        default:
        {
            break;
        }
    }
}


/**
 将播放器添加到目标view上
 
 @param aView 播放器的父view
 */
- (void)addFeedPlayerViewToTargetView:(UIView *)aView
{
    self.commmonPlaySuperView = aView;
    [aView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(aView);
    }];
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
}




/**
 播放
 */
- (void)play
{
    [[MPBVideoPlayerManager sharedInstance] play];
}

/**
 暂停
 */
- (void)pause
{
    [[MPBVideoPlayerManager sharedInstance] pause];
}

/**
 销毁播放器
 */
- (void)destroyPlayer
{
    [[MPBVideoPlayerManager sharedInstance] resetVideoPlayer];
}

#pragma mark - ******************************************* 基类方法(一般发生在重写函数) ****************


#pragma mark - ******************************************* Touch Event ***********************

/**
 TODO: 返回按钮点击事件的响应函数
 */
- (void)btnClickBack:(UIButton *)aSender{}


#pragma mark - ******************************************* 私有方法 **********************************

/**
 添加播放器
 */
-(void)addPlayer
{
    [[MPBVideoPlayerManager sharedInstance] addPlayerViewToTargetView:self];
    self.backgroundColor = [UIColor blackColor];
    [MPBVideoPlayerManager sharedInstance].delegate = self;
}

/**
 更新播放器资源
 @param urlString 更新播放器资源
 */
-(void)addPlayWithUrl:(NSString *)urlString
{
    [[MPBVideoPlayerManager sharedInstance] setVideoURL:urlString];
    [[MPBVideoPlayerManager sharedInstance] play];
}
#pragma mark - ******************************************* Net Connection Event ********************

#pragma mark - 请求 demo

- (void)req_url_demo
{
    
}


#pragma mark - ******************************************* Delegate Event **************************

/**
 加载完成开始播放
 */
- (void)mpdOptionalVideoPlayerViewIsReadyToPlayVideo{}

/**
播放结束
 */
- (void)mpdOptionalVideoPlayerViewDidReachEnd{}

/**
 视频加载进度
 */
- (void)mpdVideoPlayerTimeChange:(CMTime)cmTime{}

/**
视频缓冲进度
 */
- (void)mpdOptionalVideoPlayerViewLoadedTimeRangeDidChange:(float)duration{}

/**
 播放资源为空开始加载视频
 */
- (void)mpdOptionalVideoPlayerViewPlaybackBufferEmpty{}

/**
 缓冲完成开始播放视频
 */
- (void)mpdOptionalVideoPlayerViewPlaybackLikelyToKeepUp{}

/**
播放失败
 */
- (void)mpdOptionalVideoPlayerViewDidFailWithError:(NSError *)error{}

/**
视频是否在加载
 */
- (void)mpdOptionaVideoPlayerVisVideoLoading:(BOOL *)isLoading
{
    if (isLoading)
    {
        //开始加载动画
    }
    else
    {
      //停止加载动画
    }
}

#pragma mark - ******************************************* Notification Event **********************

#pragma mark - 通知 demo

- (void)notification_demo:(NSNotification *)aNotification
{
    
}


#pragma mark - ******************************************* 属性变量的 Set 和 Get 方法 *****************


/**
设置model

 @param videoPlayModel 播放器model
 */
-(void)setVideoPlayModel:(MPVPVideoPlayerModel *)videoPlayModel
{
    //配置播放器和播放信息
    _videoPlayModel = videoPlayModel;
    self.videoURL = [NSURL URLWithString:videoPlayModel.videoUrlString];
    [self addPlayer];//添加播放器
}

/**
 *  videoURL的setter方法
 *
 *  @param videoURL videoURL
 */
- (void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL;
}


@end
