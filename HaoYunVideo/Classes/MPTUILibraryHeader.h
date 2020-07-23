//
//  MPTUILibraryHeader.h
//  Pods
//
//  Created by jiaxuzhou on 2017/8/14.
//
//

#ifndef MPTUILibraryHeader_h
#define MPTUILibraryHeader_h

#import "MPCScrollView.h"
#import "MPCView.h"
#import "UIColor+Tools.h"
#import "UIView+Tools.h"
#import "UINavigationController+ZFFullscreenPopGesture.h"
#import "UIView+FrameHelper.h"
#import "NSObject+Tools.h"
#import "QAIMNavigaionView.h"
#import "MPBTools.h"
#import "MPTObject.h"
#import "MPTValidObject.h"



/// 屏幕尺寸 比率
#define MPT_ScreenB [UIScreen mainScreen].bounds
#define MPT_ScreenH ([UIScreen mainScreen].bounds.size.height)
#define MPT_ScreenW ([UIScreen mainScreen].bounds.size.width)
#define MPT_ScreenRateW (375/MPT_ScreenW)
#define MPT_EqualSixScale MPT_ScreenH / 667

// 设备
#define MPT_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define MPT_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define MPT_IS4S (MPT_ScreenH == MPT_SCREEN_HEIGHT_OF_IPHONE4S)
#define MPT_IS5SInchScreen (MPT_ScreenH == MPT_SCREEN_HEIGHT_OF_IPHONE5)
#define MPT_ISIPHONE6 (MPT_ScreenH == MPT_SCREEN_HEIGHT_OF_IPHONE6)
#define MPT_ISIPHONE6PLUS (MPT_ScreenH == MPT_SCREEN_HEIGHT_OF_IPHONE6PLUS)

#define MPT_SCREEN_HEIGHT_OF_IPHONE4S 480
#define MPT_SCREEN_HEIGHT_OF_IPHONE5 568
#define MPT_SCREEN_HEIGHT_OF_IPHONE6 667
#define MPT_SCREEN_HEIGHT_OF_IPHONE6PLUS 736
#define MPT_CAPTURE_MAX_DURATION 300.0f
#define MPT_CaptureHideMVDuration 60.0f

/// 系统相关
#define MPT_IOS10 (DeviceSystemMajorVersion() >= 10)
#define MPT_IOS9 (DeviceSystemMajorVersion() >= 9)
#define MPT_IOS8 (DeviceSystemMajorVersion() >= 8)

#define MPT_IOS10Equal (DeviceSystemMajorVersion() == 10)
#define MPT_IOS9Equal (DeviceSystemMajorVersion() == 9)
#define MPT_IOS8Equal (DeviceSystemMajorVersion() == 8)

/// 计算UI相关
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define MPT_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define MPT_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define MPT_TEXTSIZE_MULTILINE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define MPT_TEXTSIZE_MULTILINE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif


#define MPT_Device_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define MPT_Device_iPhoneX_StatusH 34
#define MPT_Device_iPhoneX_FooterH 34
#define MPT_Device_iPhoneX_NavH 44
#define MPT_Device_iPhoneX_NavStatusH (MPT_Device_iPhoneX_StatusH + MPT_Device_iPhoneX_NavH)
#define MPT_Device_iPhoneX_CenterViewH (MPT_ScreenW-MPT_Device_iPhoneX_NavStatusH - MPT_Device_iPhoneX_FooterH)

#define MPT_Device_GetTrueHeight(normalH,iphoneXH) (MPT_Device_Is_iPhoneX ? iphoneXH : normalH)

#define pageNum(array,pageSize) (array.count/((pageSize>0)?pageSize:20))+((array.count%((pageSize>0)?pageSize:20))>0?1:0) +1

#endif /* MPTUILibraryHeader_h */
