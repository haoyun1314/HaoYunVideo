//
//  MPBTools.m
//  MiaoPai
//
//  Created by jiaxuzhou on 2017/6/10.
//  Copyright © 2017年 Jeakin. All rights reserved.
//


#import "MPBTools.h"


@implementation MPBTools


NSUInteger DeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        NSString *systemVersion = [UIDevice currentDevice].systemVersion;
        _deviceSystemMajorVersion = [[systemVersion componentsSeparatedByString:@"."][0] intValue];
    });
    
    return _deviceSystemMajorVersion;
}


@end
