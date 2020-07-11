//
//  MPTemplateCell.h
//  MiaoPai
//
//  Created by 蔡勋 on 2017/5/25.
//  Copyright © 2017年 Jeakin. All rights reserved.
//




#import <UIKit/UIKit.h>



/**
 秒拍app中cell的模版。不要直接粘贴，要通过模版的方式自行创建
 setCellContent:该函数日后可以根据需求自定义添加函数的形参
 getCellH:该函数日后可以根据需求自定义添加函数的形参
 */
@interface MPTemplateCell : UITableViewCell


/**
 设置cell中subview的frame和value
 */
- (void)setCellContent;

/**
 获取cell的高度

 @return 返回cell的高度
 */
+ (CGFloat)getCellH;


@end
