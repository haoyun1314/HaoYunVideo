//
//  OpenGLRender.h
//  HaoYunVideo
//
//  Created by 范浩云 on 2019/12/19.
//  Copyright © 2019 范浩云. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "OpenGLProgram.h"

//制程序(Render)分别抽象出来
#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(name) @STRINGIZE(name)

// 默认脚本
extern NSString *const kVertexShaderString;
extern NSString *const kFragmentShaderString;

@interface OpenGLRender : NSObject
@property (nonatomic, strong) OpenGLProgram *program;


- (instancetype)initWithVertex:(NSString *)vertex fragment:(NSString *)fragment;
- (void)render:(CGSize)size;

- (void)render:(CGSize)size setupViewPort:(BOOL)setupViewPort;
- (GLfloat *)textureVertexForViewSize:(CGSize)viewSize textureSize:(CGSize)textureSize;

@end
