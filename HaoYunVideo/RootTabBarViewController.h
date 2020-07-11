//
//  RootTabBarViewController.h
//  HaoYunVideo
//
//  Created by 范浩云 on 2018/2/26.
//Copyright © 2018年 范浩云. All rights reserved.
//

#import "MPBViewController.h"
#import "TPCTabBarController.h"

// ⚠️ 注意这里的 index 一定要对应root_scrollView_index, 不然别的地方获取可能会出问题
typedef NS_ENUM(NSInteger, MPRootScrollIndexStatus)
{
    /*! 附近 */
    MPRootScrollIndexStatusNear = 0,
    /*! 首页 */
    MPRootScrollIndexStatusHome,
    /*! im */
    MPRootScrollIndexStatusIM
};


@interface RootTabBarViewController : MPBViewController

@property (nonatomic, strong, readonly) TPCTabBarController *tcpTabBarVC;

/**
 当前tabbar是否隐藏
 */
@property (nonatomic, assign,readonly) BOOL tabbarHidden;

/**
 当前底部TabBar点击的index 拍摄也算进去
 */
@property (nonatomic, assign, readonly) NSInteger tabbarCurrentIndex;


@end
