//
//  JZBAccessPermissionManger.h
//  HomeWork_Patriarch
//
//  Created by 范浩云 on 2019/9/11.
//  Copyright © 2019 zybJZB. All rights reserved.
//常用：比较固定
//-相机-相册-麦克风-媒体库iTuns-日历提醒事件-联系人。

/******权限获取iOS8**********/

#import <Foundation/Foundation.h>


@interface JZBAccessPermissionManger : NSObject

/**
 获取相册权限
 @param
 completion 回掉block
 granted: YES授权 NO:没有授权
 firstTime:第一次获取权限
 
 0 :NotDetermined 用户尚未做出选择这个应用程序的访问
 1 :Restricted 设置了家长控制，照片数据不能访问
 2 :Denied  拒绝授予权限
 3 :Authorized 授予权限

 info.plist设置:相册权限：Privacy - Photo Library Usage Description 允许此权限才能使用系统相册。

 */
+ (void)authorizePhotosWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;


/**
获取相机权限

 @param
 completion 回掉block
 granted: YES授权 NO:没有授权
 firstTime:第一次获取权限
 
 0 :NotDetermined
 1 :Restricted
 2 :Denied
 3 :Authorized

 info.plist设置:Privacy - Camera Usage Description 允许此权限才能使用相机。
 */
+ (void)authorizeCameraWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;


/**
 麦克风权限

 @param
 
 completion 回掉block
 granted: YES授权 NO:没有授权
 firstTime:第一次获取权限
 
 0 :NotDetermined
 1 :Restricted
 2 :Denied
 3 :Authorized
 
升到iOS10之后，
 info.plist设置:麦克风权限Privacy - Microphone Usage Description 是否允许此App使用你的麦克风
 
 */
+ (void)authorizeAudioWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;

/**
 音乐库访问权限
 iOS9.3之前权限是默认打开的
 从用户同步的iTunes库中获取项目和播放列
 
 @param complection
 completion 回掉block
 granted: YES授权 NO:没有授权
 firstTime:第一次获取权限
 
 0 :NotDetermined
 1 :Restricted
 2 :Denied
 3 :Authorized
 
 升到iOS10之后，
 info.plist设置:访问媒体资料库 Privacy - Media Library Usage Description 播放音乐或者视频
 　
 */
+ (void)authorizeMPMediaLibraryWithCompletion:(void(^)(BOOL granted, BOOL firstTime))complection;



/**
 日历/提醒事项授权

 @param completion
 completion 回掉block
 granted: YES授权 NO:没有授权
 firstTime:第一次获取权限
 
 0 :NotDetermined
 1 :Restricted
 2 :Denied
 3 :Authorized
 
 iOS10之后，要用到某个权限必须在info.plist里指明，否则会引起崩溃和审核失败。添加权限字符串访问日历:NSCalendarsUsageDescription 访问提醒事项:NSRemindersUsageDescription
 */
+ (void)authorizeEKAuthorizationWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;



/**
 获取通讯录权限

 @param completion
 completion 回掉block
 granted: YES授权 NO:没有授权
 firstTime:第一次获取权限
 
 0 :NotDetermined
 1 :Restricted
 2 :Denied
 3 :Authorized
 

 
 
 升到iOS10之后，
 info.plist设置:访问通讯录 Privacy - Contacts Usage Description 联系人
 */
+ (void)authorizeAddressBookWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;

@end


