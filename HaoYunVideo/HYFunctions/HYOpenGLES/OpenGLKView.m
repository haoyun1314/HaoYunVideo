//
//  OpenGLKView.m
//  HaoYunVideo
//
//  Created by 范浩云 on 2019/12/18.
//  Copyright © 2019 范浩云. All rights reserved.
//

#import "OpenGLKView.h"

@implementation OpenGLKView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    }
    return self;
}
//基于GLKView的OpenGL
//GLKView中就封装了EGL和UIKit的链接过程和画面刷新功能，在上层只需要给它设置一个Contex就可以开始进行OpenGL了。
//自定义GLKView的话就在它的drawRect中编写了GL代码。

//
//外部使用的话可以使用它的代理方法- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect;


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    glClearColor(0.0f, 1.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}


@end
