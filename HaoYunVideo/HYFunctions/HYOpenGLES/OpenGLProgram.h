//
//  OpenGLProgram.h
//  HaoYunVideo
//
//  Created by 范浩云 on 2019/12/19.
//  Copyright © 2019 范浩云. All rights reserved.
//

#import <Foundation/Foundation.h>
@import OpenGLES;
//也就是上下文(Context)提供设置选项，操作缓冲这些环境变量，而渲染管线(Program)负责真正的渲染绘制。
//
//不同的渲染管线(Program)可以运行在同一个上下文(Context)中达到资源共享和程序顺序。也可以运行在不同上下文(Context)来实现资源独占和程序并行，而不同的上下文(Context)之间可可以通过ShareObject实现资源共
@interface OpenGLProgram : NSObject

@property (nonatomic, strong, readonly) NSString *vertexShaderLog;

@property (nonatomic, strong, readonly) NSString *fragmentShaderLog;

@property (nonatomic, strong, readonly) NSString *programLog;

@property (nonatomic, assign, readonly) BOOL initialized;

- (instancetype)initWithVertexShader:(NSString *)vertexShader
                      fragmentShader:(NSString *)fragmentShader;

- (GLint)attributeIndex:(NSString *)attributeName;

- (GLint)uniformIndex:(NSString *)uniformName;

- (BOOL)linkShader;

- (void)use;

- (void)validate;

@end

