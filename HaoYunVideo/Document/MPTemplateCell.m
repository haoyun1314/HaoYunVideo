 //
//  MPTemplateCell.m
//  MiaoPai
//
//  Created by 蔡勋 on 2017/5/25.
//  Copyright © 2017年 Jeakin. All rights reserved.
//


#import "MPTemplateCell.h"


@interface MPTemplateCell ()


@end


@implementation MPTemplateCell


#pragma mark - ********************** View Lifecycle **********************

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        // 创建cell的subview
        [self initCellContent];
        
        // 注册消息
        [self regNotification];
    }
    
    return self;
}


#pragma mark - ********************** init and config **********************

/**
 创建cell所包含的subviews
 */
- (void)initCellContent
{
    
}


#pragma mark - ******************************************* 对外方法 *********************************

/**
 设置cell内subview的内容和frame
 */
- (void)setCellContent
{
    
}

/**
 获取cell的高度
 
 @return 返回cell的高度
 */
+ (CGFloat)getCellH
{
    return 0;
}


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

/**
 TODO: 注册消息
 */
- (void)regNotification
{
    
}


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
