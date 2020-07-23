//
//  UIFont+JZBNFont.m
//  HomeWork_Patriarch
//
//  Created by 范浩云 on 2019/6/17.
//  Copyright © 2019 zybJZB. All rights reserved.
//

@implementation UIFont (JZBNFont)

+ (UIFont *)JZBNFontWithName:(NSString*)name size:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:name size:size];
    if(font==nil)
    {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

@end
