//
//  UIView+Toolss.m
//  MiaoPai
//
//  Created by jiaxuzhou on 2017/6/21.
//  Copyright © 2017年 Jeakin. All rights reserved.
//
//


#import "UIView+Tools.h"


@implementation UIView (Tools)


/**
 设置缺角圆角

 @param corners 注释
 @param cornerRadius 注释
 */
- (void)setCornerRadiusForRectCorner:(UIRectCorner)corners withCornerRadius:(CGSize)cornerRadius
{
    UIBezierPath *maskPath=  [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:cornerRadius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    self.layer.masksToBounds = YES;
}

/**
 设置圆角边框

 @param cornerRadius 注释
 @param borderColor 注释
 @param borderWidth 注释
 */
- (void)setCornerRadius:(CGFloat)cornerRadius
            borderColor:(UIColor *)borderColor
            borderWidth:(CGFloat)borderWidth
{
    //分别设置
    self.clipsToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

- (void)setCircle
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2.0;
}

- (void)setCircleWithBorderColor:(UIColor *)borderColor
                     borderWidth:(CGFloat)borderWidth
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2.0;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

/**
 origin

 @return 注释
 */
- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)right
{
    return CGRectGetMaxX(self.frame);
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    self.frame = frame;
}

- (void)setLeft:(CGFloat)left toRight:(CGFloat)toRight top:(CGFloat)top bottom:(CGFloat)bottom
{
    CGFloat scW = [UIScreen mainScreen].bounds.size.width;
    self.frame = CGRectMake(left, top, scW-toRight-left, bottom - top);
}

- (void)setLeft:(CGFloat)left toRight:(CGFloat)toRight top:(CGFloat)top height:(CGFloat)height
{
    CGFloat scW = [UIScreen mainScreen].bounds.size.width;
    self.frame = CGRectMake(left, top, scW-toRight-left, height);
}


@end
