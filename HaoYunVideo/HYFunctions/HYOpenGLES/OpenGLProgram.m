//
//  OpenGLProgram.m
//  HaoYunVideo
//
//  Created by 范浩云 on 2019/12/19.
//  Copyright © 2019 范浩云. All rights reserved.
//

#import "OpenGLProgram.h"

@interface OpenGLProgram()

@property (nonatomic, strong) NSString *vertShaderStr;
@property (nonatomic, strong) NSString *fragShaderStr;

@property (nonatomic, strong) NSString *vertexShaderLog;
@property (nonatomic, strong) NSString *fragmentShaderLog;
@property (nonatomic, strong) NSString *programLog;
@property (nonatomic, assign) BOOL initialized;

@property (nonatomic, assign) GLuint program;

//GLuint program:指定要附加着色器对象的程序对象
//GLuint shader:指定要附加的着色器对象

//定点着色器
@property (nonatomic, assign) GLuint vertShader;
//
@property (nonatomic, assign) GLuint fragShader;

//这其中Vertex Shader和Fragment Shader两步是可编程的。简而言之，Vertex Shader负责将顶点数据进一步处理，Fragment Shader将像素数据进一步处理。所以Vertex Shader中的代码针对每个点都会调用一次，Fragment Shader中的代码针对每个像素都会调用一次。接下来我就分三个部分讲解Shader的相关知识。



//1.要使用Shader首先要编译Shader代码。
//2.然后把编译好的Shader附加到Program上，Program可以理解为一个跑在GPU上的小程序。
//3.然后链接Program
//链接完后就可以使用了。所有和GPU交互的代码都会用到program的值。激活Vertex Shader属性的代码就用到了program。

@end

@implementation OpenGLProgram

- (instancetype)initWithVertexShader:(NSString *)vertexShader
                      fragmentShader:(NSString *)fragmentShader {
    if (self = [super init]) {
        self.vertShaderStr = vertexShader;
        self.fragShaderStr = fragmentShader;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // 创建GL Program
    self.program = glCreateProgram();
    
    // 编译脚本
    if (![self compileShader:&_vertShader type:GL_VERTEX_SHADER shaderString:_vertShaderStr]) {
        NSLog(@"Failed to compile vertex shader");
    }
    
    if (![self compileShader:&_fragShader type:GL_FRAGMENT_SHADER shaderString:_fragShaderStr]) {
        NSLog(@"Failed to compile fragment shader");
    }
    
    // 然后把编译好的Shader附加到Program上，Program可以理解为一个跑在GPU上的小程序。
    glAttachShader(_program, _vertShader);
    glAttachShader(_program, _fragShader);
}

- (void)dealloc {
    if (self.vertShader)
        glDeleteShader(self.vertShader);
    
    if (self.fragShader)
        glDeleteShader(self.fragShader);
    
    if (self.program)
        glDeleteProgram(self.program);
}


- (GLint)attributeIndex:(NSString *)attributeName {
    return glGetAttribLocation(self.program, [attributeName cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (GLint)uniformIndex:(NSString *)uniformName {
    return glGetUniformLocation(self.program, [uniformName cStringUsingEncoding:NSUTF8StringEncoding]);
}


//然后链接Program

- (BOOL)linkShader {
    GLint status;
    
    // 链接脚本到Program
    glLinkProgram(self.program);
    glGetProgramiv(self.program, GL_LINK_STATUS, &status);
    if (status == GL_FALSE)
        return NO;
    
    // 在链接后编译的脚本便可以删除
    if (self.vertShader) {
        glDeleteShader(self.vertShader);
        self.vertShader = 0;
    }
    
    if (self.fragShader) {
        glDeleteShader(self.fragShader);
        self.fragShader = 0;
    }
    
    self.initialized = YES;
    
    return YES;
}


//链接完后就可以使用了。所有和GPU交互的代码都会用到program的值。激活Vertex Shader属性的代码就用到了program。

- (void)use {
    glUseProgram(self.program);
}

- (void)validate {
    GLint logLength;
    
    // 失效Program
    glValidateProgram(self.program);
    glGetProgramiv(self.program, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar log[logLength];
        glGetProgramInfoLog(self.program, logLength, &logLength, log);
        char logBuffer[logLength];
        sprintf(logBuffer,"%s", log);
        self.programLog = [NSString stringWithCString:logBuffer encoding:NSUTF8StringEncoding];
    }
    
    self.initialized = NO;
}

#pragma mark - Internal
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type shaderString:(NSString *)shaderString {
    
    GLint status; //编译状态值
    const GLchar *source = [shaderString cStringUsingEncoding:NSUTF8StringEncoding];
    if (!source) {
        NSLog(@"Failed to load shader");
        return NO;
    }
    
    // 创建及编译Shader
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
//    今天学LearnOpenGL的时候看到了这个函数，因为最终的图像有误，但是不知道具体哪里出错，发现glGetShaderiv()函数可以用来检测着色器编译是否成功
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    
    // 输出错误日志
    if (status != GL_TRUE) {
        GLint logLength = 0;
        glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
        if (logLength > 0) {
            GLchar log[logLength];
            glGetShaderInfoLog(*shader, logLength, &logLength, log);
            char logBuffer[logLength];
            sprintf(logBuffer,"%s", log);
            if (shader == &_vertShader) {
                self.vertexShaderLog = [NSString stringWithCString:logBuffer encoding:NSUTF8StringEncoding];
            }
            else {
                self.fragmentShaderLog = [NSString stringWithCString:logBuffer encoding:NSUTF8StringEncoding];
            }
        }
    }
    
    return status == GL_TRUE ? YES : NO;
}

@end
