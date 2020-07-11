//
//  RootViewController.h
//  HaoYunVideo
//
//  Created by 范浩云 on 2018/2/26.
//Copyright © 2018年 范浩云. All rights reserved.
//

#define MPRootViewControllerInstance [RootViewController sharedInstance]

#import "MPBViewController.h"
@interface RootViewController : MPBViewController

#pragma mark=======================单例函数==============================

/*!
 *  @brief  单利 工厂函数
 *
 *  @return 返回RootViewController单利对象
 *
 *  @since v1.0
 */
+ (RootViewController *)sharedInstance;


@end
