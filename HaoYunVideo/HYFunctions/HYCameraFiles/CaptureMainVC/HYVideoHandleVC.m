//
//  HYVideoHandleVC.m
//  HaoYunVideo
//
//  Created by fanhaoyun on 2020/6/20.
//  Copyright © 2020 范浩云. All rights reserved.
//

#import "HYVideoHandleVC.h"
#import "CommonVideoPlayerView.h"

@interface HYVideoHandleVC ()

@end

@implementation HYVideoHandleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
//  1：初始化播放器
     CommonVideoPlayerView * playView = [[CommonVideoPlayerView alloc] init];
     
//    2：将播放器添加到的父视图上
     [playView addFeedPlayerViewToTargetView:self.view];
     
//    3：设置播放器的model信息
     MPVPVideoPlayerModel * videoPlayerModel = [[MPVPVideoPlayerModel alloc]init];
//    videoPlayerModel.videoFilePath = [NSString stringWithFormat:@"%@",self.videoUrl];
        videoPlayerModel.videoFilePath = self.videoUrl;
     [playView setPlayReloadWithStyle:MPE_LocalVideoFilePath playModel:videoPlayerModel];
}



@end
