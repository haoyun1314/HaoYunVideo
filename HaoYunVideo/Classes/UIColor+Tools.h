//
//  UIColor+Tools.h
//  MiaoPai
//
//  Created by jiaxuzhou on 2017/6/10.
//  Copyright © 2017年 Jeakin. All rights reserved.
//
//


#import <UIKit/UIKit.h>


/// 通过RGBA设置颜色，使用0x格式，如：MPT_RGBAAllColor(0xAABBCC, 0.5);
#define MPT_RGBAAllColor(rgb, a) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0  \
green:((float)((rgb & 0xFF00) >> 8))/255.0     \
blue:((float)(rgb & 0xFF))/255.0              \
alpha:(a)/1.0]

/// 通过RGB设置颜色，使用0x格式，如：MPT_RGBAllColor(0xAABBCC);
#define MPT_RGBAllColor(rgb) MPT_RGBAAllColor(rgb, 1.0)

/// 通过RGBA设置颜色，支持10位和16位，使用16位时每个色值前加0x，系统会默认16进制
#define MPT_RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0  \
green:(g)/255.0  \
blue:(b)/255.0  \
alpha:(a)/1.0]

/// 通过RGB设置颜色，支持10位和16位，使用16位时每个色值前加0x，系统会默认16进制
#define MPT_RGBColor(r, g, b) MPT_RGBAColor(r, g, b, 1.0)


@interface UIColor (Tools)

/**
 *  返回导航条类的颜色(#F8F8F8), 用于 顶部导航条，地步导航条
 *
 *  @return Color (#F8F8F8)
 */
+ (UIColor *)MPTBarColor;

/**
 *  返回背景颜色(#212026),用于一些cell的背景颜色
 *
 *  @return Color (#212026)
 */
+ (UIColor *)MPTLowBackColor;

/**
 *  返回秒拍亮黄色(#FFD600)
 *
 *  @return Color (#FFD600)
 */
+ (UIColor *)MPTLightYellowColor;

/**
 *  返回辅助文本颜色(#67666c), 用于 辅助信息、辅助信息icon 等
 *
 *  @return Color (#67666c)
 */
+ (UIColor *)MPTAssistColor;

/**
 *  返回辅助颜色(#3a3842), 用于按钮背景、分割线 等
 *
 *  @return Color (#3a3842)
 */
+ (UIColor *)MPTAssistBackgroundColor;

/**
 *  返回秒拍亮绿色(#2fc692)
 *
 *  @return Color (#2fc692)
 */
+ (UIColor *)MPTLightGreenColor;

/**
 *  返回510背景颜色(#31313e)
 *
 *  @return Color (#31313e)
 */
+ (UIColor *)MPT510BackgroundColor;

/**
 *  返回510深背景颜色(#23232b)
 *
 *  @return Color (#23232b)
 */
+ (UIColor *)MPT510DarkBackgroundColor;

/**
 *  返回510分割线颜色(#535362)
 *
 *  @return Color (#535362)
 */
+ (UIColor *)MPT510SeparatorColor;

/**
 *  返回评论分割线颜色
 *
 *  @return color (#424253)
 */
+ (UIColor *)MPT510CommentSeparatorColor;

/**
 *  返回510高亮颜色(#424253)
 *
 *  @return Color (#424253)
 */
+ (UIColor *)MPT510HighLightColor;

/**
 *  返回510更深的颜色(#18181f)
 *
 *  @return Color (#18181f)
 */
+ (UIColor *)MPT510DarkDarkColor;

/**
 *  通过 Hex 设置颜色
 *
 *  @param hex 如 白色（#FFFFFF）[UIColor YXColorWithHexCode:@"FFFFFF"];
 *
 *  @return UIColor
 */
+ (UIColor *)YXColorWithHexCode:(NSString *)hex;

/**
 *  通过 Hex 设置颜色，并且指定颜色透明通道
 *
 *  @param hex 如 白色（#FFFFFF）[UIColor YXColorWithHexCode:@"FFFFFF"];
 *  @param alpha 颜色值范围在 0~1 之间
 *
 *  @return UIColor
 */
+ (UIColor *)YXColorWithHexCode:(NSString *)hex alpha:(CGFloat)alpha;

/**
 *  通过 rgb 设置颜色，透明度为1
 *
 *  @param r 红色
 *  @param g 绿色
 *  @param b 蓝色
 *
 *  @return UIColor
 */
+ (UIColor *)YXRGBColor:(CGFloat)r g:(CGFloat)g b:(CGFloat)b;

/**
 *  通过 rgba 设置颜色
 *
 *  @param r 红色
 *  @param g 绿色
 *  @param b 蓝色
 *  @param a 透明度
 *
 *  @return UIColor
 */
+ (UIColor *)YXRGBAColor:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a;

+ (UIColor *)YXRGBColorWithSameNum:(CGFloat)num;

+ (UIColor *)YXRGBAColorWithSameNum:(CGFloat)num a:(CGFloat)a;

/**
 *  获取一个随机颜色，测试用
 *
 *  @return 获取一个随机颜色
 */
+ (UIColor *)randomColor;

/**
 *  返回背景颜色(#EDEDED)
 *
 *  @return Color (#EDEDED)
 */
+ (UIColor *)MPTBackgroundColor;

/**
 *  返回拍摄背景颜色(#FFFFFF)
 *
 *  @return Color (#FFFFFF)
 */
+ (UIColor *)MPTCaptureBackgroundColor;

/**
 *  返回秒拍文字颜色(#23232B)
 *
 *  @return Color (#23232B)
 */
+ (UIColor *)MPTMainTextColor;

/**
 *  返回秒拍辅助文字颜色(#919191)
 *
 *  @return Color (#919191)
 */
+ (UIColor *)MPTAssistTextColor;

/**
 *  返回秒拍辅助文字颜色(#FF7B4D)
 *
 *  @return Color (#FF7B4D)
 */
+ (UIColor *)MPTImportantTextColor;

/**
 *  返回秒拍分割线颜色颜色(#EDEDED)
 *
 *  @return Color (#EDEDED)
 */
+ (UIColor *)MPTSeparatorColor;

/**
 *  返回秒拍分割线颜色颜色(#FFFFF)
 *
 *  @return Color (#FFFFFF)
 */
+ (UIColor *)MPTCellColor;

/**
 *  返回秒拍分割线颜色颜色(#DBDBDB)
 *
 *  @return Color (#DBDBDB)
 */
+ (UIColor *)MPTCellHighLightColor;

/**
 *  返回秒拍角标背景颜色(#FF5655)
 *
 *  @return Color (#FF5655)
 */
+ (UIColor *)MPTSuperscriptsBackgroundColor;

/**
 *  返回秒拍主按钮背景颜色(#FFD600)
 *
 *  @return Color (#FFD600)
 */
+ (UIColor *)MPTMainButtonNormalBackgroundColor;

/**
 *  返回秒拍主按钮高亮背景颜色(#CCAB00)
 *
 *  @return Color (#CCAB00)
 */
+ (UIColor *)MPTMainButtonHighlightedBackgroundColor;

/**
 *  返回秒拍主按钮高亮字体颜色(#BDA243)
 *
 *  @return Color (#BDA243)
 */
+ (UIColor *)MPTMainButtonHighlightedTextColor;

/**
 *  返回秒拍主按钮禁用背景颜色(#FFE24D)
 *
 *  @return Color (#FFE24D)
 */
+ (UIColor *)MPTMainButtonDisableBackgroundColor;

/**
 *  返回秒拍主按钮禁用字体颜色(#BDA243)
 *
 *  @return Color (#BDA243)
 */
+ (UIColor *)MPTMainButtonDisableTextColor;

/**
 *  返回秒拍扩展颜色颜色(#4A4A4A)
 *
 *  @return Color (#4A4A4A)
 */
+ (UIColor *)MPTExtendColor;

/**
 *  返回秒拍转发Cell背景颜色(#F5F5F5)
 *
 *  @return Color (#F5F5F5)
 */
+ (UIColor *)MPTForwardBackgroundColor;

/**
 *  返回秒拍扩展文本颜色(#FF7B4D)
 *
 *  @return Color (#FF7B4D)
 */
+ (UIColor *)MPTExtendTextColor;

/**
 *  返回默认状态的黄色(#ffd600)
 *
 *  @return Color (#ffd600)
 */
+ (UIColor *)MPTDefaultLightYellowColor;

/**
 *  返回点击状态的黄色(#ccab00)
 *
 *  @return Color (#ccab00)
 */
+ (UIColor *)MPTSelectedLightYellowColor;

/**
 *  返回不可点击状态的黄色(#ffe24d)
 *
 *  @return Color (#ffe24d)
 */
+ (UIColor *)MPTDisableLightYellowColor;

/**
 #D2D2D2

 @return #D2D2D2
 */
+ (UIColor *)MPTRelationButtonFollowNormalBackgroundColor;

/**
 #939393

 @return #939393
 */
+ (UIColor *)MPTRelationButtonFollowHighlightedBackgroundColor;

/**
 #3095FC

 @return #3095FC
 */
+ (UIColor *)MPTRelationButtonInviteNormalBackgroundColor;

/**
 #2268B0

 @return #2268B0
 */
+ (UIColor *)MPTRelationButtonInviteHighlightedBackgroundColor;


@end
