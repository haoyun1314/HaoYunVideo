//
//  OpenGLContext.h
//  HaoYunVideo
//
//  Created by 范浩云 on 2019/12/19.
//  Copyright © 2019 范浩云. All rights reserved.
//

#import <Foundation/Foundation.h>
@import OpenGLES;
NS_ASSUME_NONNULL_BEGIN

@interface OpenGLContext : NSObject
@property (nonatomic, strong, readonly) EAGLContext *eaglContext;

- (void)swapToScreen;
- (void)useAsCurrent;
- (BOOL)isCurrentContext;
@end

NS_ASSUME_NONNULL_END
