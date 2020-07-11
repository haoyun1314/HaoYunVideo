//
//  UIView+Toolss.m
//  MiaoPai
//
//  Created by jiaxuzhou on 2017/6/21.
//  Copyright © 2017年 Jeakin. All rights reserved.
//
//


#import <UIKit/UIKit.h>


@interface UIView (Tools)


/**
 设置圆角

 @param corners 注释
 @param cornerRadius 注释
 */
- (void)setCornerRadiusForRectCorner:(UIRectCorner)corners withCornerRadius:(CGSize)cornerRadius;

/**
 设置圆角边框

 @param cornerRadius 注释
 @param borderColor 注释
 @param borderWidth 注释
 */
- (void)setCornerRadius:(CGFloat)cornerRadius
            borderColor:(UIColor *)borderColor
            borderWidth:(CGFloat)borderWidth;

/**
 设置圆形
 */
- (void)setCircle;

/**
 设置圆形

 @param borderColor 注释
 @param borderWidth 注释
 */
- (void)setCircleWithBorderColor:(UIColor *)borderColor
                     borderWidth:(CGFloat)borderWidth;


// 快捷获取, 设置属性
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

// 快捷计算布局
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;


/**
 left, right, top, bottom

 @param left 注释
 @param toRight 注释
 @param top 注释
 @param bottom 注释
 */
- (void)setLeft:(CGFloat)left toRight:(CGFloat)toRight top:(CGFloat)top bottom:(CGFloat)bottom;

/**
 left, right, top, height

 @param left 注释
 @param toRight 注释
 @param top 注释
 @param height 注释
 */
- (void)setLeft:(CGFloat)left toRight:(CGFloat)toRight top:(CGFloat)top height:(CGFloat)height;


@end
