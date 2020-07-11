//
//  MPBPlayerReachability.h
//  Masonry
//
//  Created by 蔡勋 on 2018/1/10.
//


#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>


typedef enum : NSInteger
{
    MPBPlayerNotReachable = 0,
    MPBPlayerReachableViaWiFi,
    MPBPlayerReachableViaWWAN
} MPBPlayerNetworkStatus;


extern NSString *kMPBPlayerReachabilityChangedNotification;


@interface MPBPlayerReachability : NSObject

+ (instancetype)reachabilityWithHostName_MPBPlayer:(NSString *)hostName;

+ (instancetype)reachabilityWithAddress_MPBPlayer:(const struct sockaddr *)hostAddress;

+ (instancetype)reachabilityForInternetConnection_MPBPlayer;


#pragma mark reachabilityForLocalWiFi

- (BOOL)startNotifier_MPBPlayer;
- (void)stopNotifier_MPBPlayer;

- (MPBPlayerNetworkStatus)currentReachabilityStatus;

- (BOOL)connectionRequired_MPBPlayer;

+ (BOOL)isNotReachable_MPBPlayer;
+ (BOOL)isViaWiFi_MPBPlayer;
+ (BOOL)isViaWWAN_MPBPlayer;


@end
