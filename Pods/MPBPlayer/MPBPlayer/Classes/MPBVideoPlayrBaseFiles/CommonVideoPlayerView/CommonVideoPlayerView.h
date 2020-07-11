//
//  CommonVideoPlayerView.h
//  Pods
//
//  Created by 范浩云 on 2017/12/14.
//
//：
/*
 使用说明:
播放器父视图===================================================================
 第一步：创建播放器的父视图
 self.playViewSuperView = [[UIView alloc]init];
 [self.view addSubview:self.playViewSuperView];
 
 //设置播放器父视图的frame
 [self.playViewSuperView mas_makeConstraints:^(MASConstraintMaker *make)
 {
 make.top.equalTo(self.view.mas_top).mas_offset(64);
 make.left.equalTo(self.view.mas_left);
 make.height.mas_equalTo(211);
 make.width.mas_equalTo(self.view.frame.size.width);
 }];

 
播放器======================================================================
 
1：初始化播放器
 CommonVideoPlayerView * playView = [[CommonVideoPlayerView alloc] init];
 
2：将播放器添加到的父视图上
 [playView addFeedPlayerViewToTargetView:self.playViewSuperView];
 
3：设置播放器的model信息
 MPVPVideoPlayerModel * videoPlayerModel = [[MPVPVideoPlayerModel alloc]init];
 videoPlayerModel.videoUrlString = @"http://kscdn.miaopai.com/stream/XeY5snYMjUdtX0YAf3aAiyOgozFtVjlx_16.mp4?ssig=6c3fb08eb780b60fccdc48bf8287d9d7&time_stamp=1513310403301&f=/XeY5snYMjUdtX0YAf3aAiyOgozFtVjlx_16.mp4";
4：开始播放视频
 [playView setPlayReloadWithStyle:MPE_DirectGetUrl playModel:videoPlayerModel];
 */


//***********************这个播放器仅供参考可以自定义播放器*****************************

#import "MPVPVideoPlayerModel.h"

typedef NS_ENUM(NSInteger,MPE_GetPlayUrlMethod)
{
    MPE_DirectGetUrl,  //直接传的url
    MPE_MergeGetUrl,  //通过videoId拼接url
    MPE_RequesetUrl  //通过接口请求到url
};


@interface CommonVideoPlayerView : UIView

//播放器model
@property (nonatomic, strong) MPVPVideoPlayerModel *videoPlayModel;

/**
 加载播放
 
 @param style 播放地址获取方式
 @param playModel 播放器model
 */
- (void)setPlayReloadWithStyle:(MPE_GetPlayUrlMethod)style
                     playModel:(MPVPVideoPlayerModel *)playModel;

/**
 将播放器添加到目标view上
 
 @param aView 播放器的父view
 */
- (void)addFeedPlayerViewToTargetView:(UIView *)aView;


/**
 播放
 */
- (void)play;

/**
 暂停
  */
- (void)pause;

/**
 销毁播放器
 */
- (void)destroyPlayer;


@end
