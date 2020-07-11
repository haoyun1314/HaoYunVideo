 //
//  MPTemplateView.m
//  MiaoPai
//
//  Created by 蔡勋 on 2017/5/25.
//  Copyright © 2017年 Jeakin. All rights reserved.
//


#import "MPTemplateView.h"


@interface MPTemplateView ()


@end


@implementation MPTemplateView


#pragma mark - ********************** View Lifecycle **********************

- (void)dealloc
{
    // 一定要关注这个函数是否被执行了！！！
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super init];
    
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

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if(newSuperview == nil)
    {
        // 这块需要注意一下，当前view如果在其他地方被移除了的话，要小心下面这行代码！
        [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        return ;
    }
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


#pragma mark - ******************************************* 基类方法(一般发生在重写函数) ****************


#pragma mark - ******************************************* Touch Event ***********************

/**
 TODO: 返回按钮点击事件的响应函数
 
 @param sender 被点击的按钮
 */
- (void)btnClickBack:(UIButton *)aSender
{
    
}


#pragma mark - ******************************************* 私有方法 **********************************


#pragma mark - ******************************************* Net Connection Event ********************

#pragma mark - 请求 demo

- (void)req_url_demo
{
    
}


#pragma mark - ******************************************* Delegate Event **************************

#pragma mark - 代理 demo

- (void)delegate_demo
{
    
}


#pragma mark - ******************************************* Notification Event **********************

#pragma mark - 通知 demo

- (void)notification_demo:(NSNotification *)aNotification
{
    
}


#pragma mark - ******************************************* 属性变量的 Set 和 Get 方法 *****************


@end
