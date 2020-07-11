//
//  JZBAccessPermissionManger.m
//  HomeWork_Patriarch
//
//  Created by 范浩云 on 2019/9/11.
//  Copyright © 2019 zybJZB. All rights reserved.
//

#import "JZBAccessPermissionManger.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <EventKit/EventKit.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>


@implementation JZBAccessPermissionManger

//TODO:获取相册权限
+ (void)authorizePhotosWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
     if (@available(iOS 8.0, *))
     {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        switch (status) {
            case PHAuthorizationStatusAuthorized:
            {
                if (completion) {
                    completion(YES,NO);
                }
            }
                break;
            case PHAuthorizationStatusRestricted:
            case PHAuthorizationStatusDenied:
            {
                //这种情况下想要弹窗需要自定义一个提示
                if (completion) {
                    completion(NO,NO);
                }
            }
                break;
            case PHAuthorizationStatusNotDetermined:
            {
                //PHAuthorizationStatusNotDetermined 这种情况下会弹一个框
                //其它情况下即使获取权限也不会弹
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(status == PHAuthorizationStatusAuthorized,YES);
                        });
                    }
                }];
            }
                break;
            default:
            {
                //这种情况下想要弹窗需要自定义一个提示
                if (completion) {
                    completion(NO,NO);
                }
            }
                break;
        }
     }
     else
    {
        
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        switch (status) {
            case ALAuthorizationStatusAuthorized:
            {
                if (completion) {
                    completion(YES, NO);
                }
            }
                break;
            case ALAuthorizationStatusNotDetermined:
            {
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                       usingBlock:^(ALAssetsGroup *assetGroup, BOOL *stop) {
                                           if (*stop) {
                                               if (completion) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       completion(YES, NO);
                                                   });
                                                   
                                               }
                                           } else {
                                               *stop = YES;
                                           }
                                       }
                                     failureBlock:^(NSError *error) {
                                         if (completion) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 completion(NO, YES);
                                             });
                                         }
                                     }];
            } break;
            case ALAuthorizationStatusRestricted:
            case ALAuthorizationStatusDenied:
            {
                if (completion) {
                    completion(NO, NO);
                }
            }
                break;
        }
    }
}

//TODO:获取相机权限
+ (void)authorizeCameraWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;
{
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                completion(YES,NO);
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                completion(NO,NO);
                break;
            case AVAuthorizationStatusNotDetermined:
            {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                         completionHandler:^(BOOL granted) {
                                             if (completion) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     completion(granted,YES);
                                                 });
                                             }
                                         }];
                
            }
                break;
        }
    } else {
        //iOS7以前默认都会授权
        completion(YES,NO);
    }
}

//TODO:获取麦克风权限
+ (void)authorizeAudioWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authStatus)
    {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted)
                    {
                        if (completion) {
                            completion(granted,YES);
                        }
                    }
                });
            }];
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
            completion(YES,NO);
        }
            break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            completion(NO,NO);
            break;
    }
}


//TODO:音乐库访问权限
+ (void)authorizeMPMediaLibraryWithCompletion:(void(^)(BOOL granted, BOOL firstTime))complection {
    
    // @available(iOS 9.3, *)
    if (@available(iOS 9.3, *)) {
        
        MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];
        
        switch (status) {
            case MPMediaLibraryAuthorizationStatusAuthorized:
            {
                if (complection) {
                    complection(YES, NO);
                }
                
            }
                break;
            case MPMediaLibraryAuthorizationStatusRestricted:
            case MPMediaLibraryAuthorizationStatusDenied:
            {
                if (complection) {
                    complection(NO, NO);
                }
            }
                break;
            case MPMediaLibraryAuthorizationStatusNotDetermined:
            {
                [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
                    if (complection) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            complection(status == MPMediaLibraryAuthorizationStatusAuthorized, YES);
                        });
                    }
                    
                }];
            }
                break;
            default:
            {
                if (complection) {
                    complection(NO, NO);
                }
                
            }
                break;
        }
        
    } else {//9.3之前权限默认打开
        complection(YES, NO);
    }
    
}



//TODO:3、日历/提醒事项授权
+ (void)authorizeEKAuthorizationWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    EKAuthorizationStatus authorizationStatus =
    [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (authorizationStatus) {
        case EKAuthorizationStatusAuthorized: {
            if (completion) {
                completion(YES, NO);
            }
        } break;
        case EKAuthorizationStatusNotDetermined:
        {
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:EKEntityTypeEvent
                                       completion:^(BOOL granted, NSError *error) {
                                           if (completion) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   completion(granted,YES);
                                               });
                                           }
                                       }];
        }
            break;
        case EKAuthorizationStatusRestricted:
        case EKAuthorizationStatusDenied: {
            if (completion) {
                completion(NO, NO);
            }
        } break;
    }
}

//TODO:获取通讯录
+ (void)authorizeAddressBookWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    if (@available(iOS 9,*))
    {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status)
        {
            case CNAuthorizationStatusAuthorized:
            {
                if (completion) {
                    completion(YES,NO);
                }
            }
                break;
            case CNAuthorizationStatusDenied:
            case CNAuthorizationStatusRestricted:
            {
                if (completion) {
                    completion(NO,NO);
                }
            }
                break;
            case CNAuthorizationStatusNotDetermined:
            {
                [[CNContactStore new] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (completion) {
                            completion(granted,YES);
                        }
                    });
                }];
                
            }
                break;
        }
    }
    else
    {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        
        switch (status) {
            case kABAuthorizationStatusAuthorized: {
                if (completion) {
                    completion(YES,NO);
                }
            } break;
            case kABAuthorizationStatusNotDetermined: {
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(granted,YES);
                        });
                    }
                });
            } break;
            case kABAuthorizationStatusRestricted:
            case kABAuthorizationStatusDenied: {
                if (completion) {
                    completion(NO,NO);
                }
            } break;
        }
    }
}



@end
