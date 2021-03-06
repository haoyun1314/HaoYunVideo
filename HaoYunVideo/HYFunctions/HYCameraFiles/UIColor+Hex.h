//
//  UIColor+Hex.h
//  color
//
//  Created by Andrew Sliwinski on 9/15/12.
//  Copyright (c) 2012 Andrew Sliwinski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;

+ (UIColor *)colorWithHex:(UInt32)hex;
+ (UIColor *)colorWithHexString:(id)input;
+ (UIColor *)colorWithARGBHex:(uint)hex;
- (UInt32)hexValue;
+ (UIColor *)colorWithRGB:(uint32_t)rgbValue;
@end
