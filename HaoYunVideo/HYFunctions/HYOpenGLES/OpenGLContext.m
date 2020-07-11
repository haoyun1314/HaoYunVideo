//
//  OpenGLContext.m
//  HaoYunVideo
//
//  Created by 范浩云 on 2019/12/19.
//  Copyright © 2019 范浩云. All rights reserved.
//

#import "OpenGLContext.h"

@interface OpenGLContext()

@property (nonatomic, strong) EAGLContext *eaglContext;

@end

@implementation OpenGLContext

- (instancetype)init {
    if (self = [super init]) {
        self.eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        [EAGLContext setCurrentContext:self.eaglContext];
    }
    return self;
}

- (void)swapToScreen {
    [self.eaglContext presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)useAsCurrent {
    if ([EAGLContext currentContext] != self.eaglContext) {
        [EAGLContext setCurrentContext:self.eaglContext];
    }
}

- (BOOL)isCurrentContext {
    return [EAGLContext currentContext] == self.eaglContext;
}


@end
