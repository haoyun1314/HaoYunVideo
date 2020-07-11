//
//  UIColor+Tools.m
//  MiaoPai
//
//  Created by jiaxuzhou on 2017/6/10.
//  Copyright © 2017年 Jeakin. All rights reserved.
//
//


#import "UIColor+Tools.h"


@implementation UIColor (Tools)


+ (UIColor *)YXColorWithHexCode:(NSString *)hex
{
    NSString *cleanString = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if ([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    
    if([cleanString length] == 6)
    {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)YXColorWithHexCode:(NSString *)hex alpha:(CGFloat)alpha
{
    return [[UIColor YXColorWithHexCode:hex] colorWithAlphaComponent:alpha];
}

+ (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (UIColor *)MPTLowBackColor
{
    return [UIColor YXColorWithHexCode:@"#212026"];
}

+ (UIColor *)MPTLightYellowColor
{
    return [UIColor YXColorWithHexCode:@"#FFD600"];//ffc800
}

+ (UIColor *)MPTAssistColor
{
    return [UIColor YXColorWithHexCode:@"#919191"];
}

+ (UIColor *)MPTAssistBackgroundColor
{
    return [UIColor YXColorWithHexCode:@"#3a3842"];
}

+ (UIColor *)MPTLightGreenColor
{
    return [UIColor YXColorWithHexCode:@"#2fc692"];
}

+ (UIColor *)MPT510BackgroundColor
{
    return [UIColor YXColorWithHexCode:@"#31313e"];
}

+ (UIColor *)MPT510DarkBackgroundColor
{
    return [UIColor YXColorWithHexCode:@"#23232b"];
}

+ (UIColor *)MPT510SeparatorColor
{
    return [UIColor YXColorWithHexCode:@"#23232b"];
}

+ (UIColor *)MPT510CommentSeparatorColor
{
    return [UIColor YXColorWithHexCode:@"#424253"];
}

+ (UIColor *)MPT510HighLightColor
{
    return [UIColor YXColorWithHexCode:@"#424253"];
}

+ (UIColor *)MPT510DarkDarkColor
{
    return [UIColor YXColorWithHexCode:@"#18181f"];
}

+ (UIColor *)YXRGBColor:(CGFloat)r g:(CGFloat)g b:(CGFloat)b
{
    return [UIColor YXRGBAColor:r g:g b:b a:1.0];
}

+ (UIColor *)YXRGBAColor:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a
{
    return [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a];
}

+ (UIColor *)YXRGBColorWithSameNum:(CGFloat)num
{
    return [UIColor YXRGBColor:num g:num b:num];
}

+ (UIColor *)YXRGBAColorWithSameNum:(CGFloat)num a:(CGFloat)a
{
    return [UIColor YXRGBAColor:num g:num b:num a:a];
}

+ (UIColor *)MPTBackgroundColor
{
    return [UIColor YXColorWithHexCode:@"#EDEDED"];
}

+ (UIColor *)MPTCaptureBackgroundColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)MPTMainTextColor
{
    return [UIColor YXColorWithHexCode:@"23232B"];
}

+ (UIColor *)MPTAssistTextColor
{
    return [UIColor YXColorWithHexCode:@"#919191"];
}

+ (UIColor *)MPTImportantTextColor
{
    return [UIColor YXColorWithHexCode:@"#FF7B4D"];
}

+ (UIColor *)MPTSeparatorColor
{
    return [UIColor YXColorWithHexCode:@"#EDEDED"];
}

+ (UIColor *)MPTCellColor
{
    return [UIColor YXColorWithHexCode:@"#FFFFFF"];
}

+ (UIColor *)MPTCellHighLightColor
{
    return [UIColor YXColorWithHexCode:@"#DBDBDB"];
}

+ (UIColor *)MPTSuperscriptsBackgroundColor
{
    return [UIColor YXColorWithHexCode:@"#FF5655"];
}

+ (UIColor *)MPTMainButtonNormalBackgroundColor
{
    return [UIColor YXColorWithHexCode:@"#FFD600"];//FFC800
}

+ (UIColor *)MPTMainButtonHighlightedBackgroundColor
{
    return [UIColor YXColorWithHexCode:@"#CCAB00"]; //B28C00
}

+ (UIColor *)MPTMainButtonHighlightedTextColor
{
    return [UIColor YXColorWithHexCode:@"#18181E"];
}

+ (UIColor *)MPTMainButtonDisableBackgroundColor
{
    return [UIColor YXColorWithHexCode:@"#FFE24D"]; //FFD94D
}

+ (UIColor *)MPTMainButtonDisableTextColor
{
    return [UIColor YXColorWithHexCode:@"#BDA243"];
}

+ (UIColor *)MPTBarColor
{
    return [UIColor YXColorWithHexCode:@"#F8F8F8"];
}

+ (UIColor *)MPTExtendColor
{
    return [UIColor YXColorWithHexCode:@"#4A4A4A"];
}

+ (UIColor *)MPTForwardBackgroundColor
{
    return [UIColor YXColorWithHexCode:@"#F5F5F5"];
}

+ (UIColor *)MPTExtendTextColor
{
    return [UIColor YXColorWithHexCode:@"#FF7B4D"];
}

+ (UIColor *)MPTDefaultLightYellowColor
{
    return [UIColor YXColorWithHexCode:@"#FFD600"];
}

+ (UIColor *)MPTSelectedLightYellowColor
{
    return [UIColor YXColorWithHexCode:@"#CCAB00"];
}

+ (UIColor *)MPTDisableLightYellowColor
{
    return [UIColor YXColorWithHexCode:@"#FFE24D"];
}

+ (UIColor *)MPTRelationButtonFollowNormalBackgroundColor
{
    return [UIColor YXColorWithHexCode:@"#D2D2D2"];
}

+ (UIColor *)MPTRelationButtonFollowHighlightedBackgroundColor
{
    return [UIColor YXColorWithHexCode:@"#939393"];
}

+ (UIColor *)MPTRelationButtonInviteNormalBackgroundColor
{
    return [UIColor YXColorWithHexCode:@"#3095FC"];
}

+ (UIColor *)MPTRelationButtonInviteHighlightedBackgroundColor
{
    return [UIColor YXColorWithHexCode:@"#2268B0"];
}


@end
