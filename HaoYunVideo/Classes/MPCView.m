//
//  MPCView.m
//  Pods
//
//  Created by HouGeng on 17/7/22.
//
//

#import "MPCView.h"

@implementation MPCView

#pragma mark - *********************************** View Lifecycle **********************************

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        /// 初始化变量
        //        [self initVariable]; /// 暂时用不到
        
        /// 设置公共属性，与App的UI规范 无关
        [self setCommonAttribute];
        
        /// 设置公共属性，与App的UI规范 有关
        //        [self setCustomAttribute]; /// 暂时用不到
    }
    
    return self;
}

- (void)initVariable
{
    
}

/// 设置公共属性，与App的UI规范 无关
- (void)setCommonAttribute
{
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.clipsToBounds = YES;
    }
}

/// 设置公共属性，与App的UI规范 有关
- (void)setCustomAttribute
{
    if (self)
    {
        /// 在此做与App的UI规范有关的设置
    }
}

- (void)dealloc
{
    
}


#pragma mark - ********************************** 初始化方法 工厂模式 *********************************

+ (instancetype)getWithFrame:(CGRect)frame
{
    MPCView *view = [[self alloc] initWithFrame:frame];
    
    return view;
}


#pragma mark - ********************************** 初始化方法 实例方法 *********************************


#pragma mark - *********************************** 设置属性 实例方法 **********************************


#pragma mark - ************************************* Functions *************************************

- (void)setCornerRadiusForAll:(float)cornerRadius
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setCornerRadiusForPart:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    // 上面两个圆角
    UIBezierPath *maskPath=  [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:cornerRadii];
    
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc] init];
    
    maskLayer.frame=self.bounds;
    
    maskLayer.path=maskPath.CGPath;
    
    self.layer.mask=maskLayer;
    
    self.layer.masksToBounds=YES;
}


@end
