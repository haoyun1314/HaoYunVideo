//
//  OpenGLRender.m
//  HaoYunVideo
//
//  Created by 范浩云 on 2019/12/19.
//  Copyright © 2019 范浩云. All rights reserved.
//

#import "OpenGLRender.h"

//其中使用到attribute,varying,uniform这三个限定符和vec2,sampler2D这两个变量类型以及一个highp精度指定。它们具体的含义下面详解，在这里我们只需要知道：
//
//attribute用于从外部给Vertex Shader传递数值。
//varying用于Vertex Shader给Fragment Shader传递数值。
//uniform用于给Fragment Shader传递数值。
//vec2是一个二元数的类型定义。
//sampler2D是一个纹理句柄的类型定义。
//highp用于指定变量为高精度。

//数据组织和传递
//这里我们要学习一下我们要传递给顶点着色器的是什么数据块，怎么传递给它？在OpenGL中有以下几种组织数据和传递数据的方式：
//
//使用glVertex或者Display List
//VA(Vertex Array)
//VBO(Vertex Buffer Object)
//VAO(Vertex Array Object)



// 顶点着色器代码
NSString *const kVertexShaderString = SHADER_STRING
(
 attribute vec2 position;  // 4个顶点
 attribute vec2 inputTextureCoordinate;// 两个定点
 varying vec2 textureCoordinate;
 
 void main() {
     gl_Position = vec4(position.xy, 0, 1);
     textureCoordinate = inputTextureCoordinate;
 }
 );

// 片段着色器代码
NSString *const kFragmentShaderString = SHADER_STRING
(
  // 定义全局变量
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputTexture;
 
 void main() {
     gl_FragColor = texture2D(inputTexture, textureCoordinate);
 }
 );



@interface OpenGLRender()

@property (nonatomic, assign) GLint positionAttribute;

@property (nonatomic, assign) GLint inputTextureCoorAttribute;

@property (nonatomic, assign) GLint textureUniform;

@end

@implementation OpenGLRender


- (instancetype)init
{
    return [self initWithVertex:kVertexShaderString fragment:kFragmentShaderString];
}

- (instancetype)initWithVertex:(NSString *)vertex fragment:(NSString *)fragment
{
     if (self = [super init])
     {
    //要使用Shader首先要编译Shader代码。
           self.program = [[OpenGLProgram alloc] initWithVertexShader:kVertexShaderString fragmentShader:kFragmentShaderString];
           
           if (![self.program linkShader]) {
               NSLog(@"Program link log:%@",self.program.programLog);
               NSLog(@"Vertex shader compile log:%@",self.program.vertexShaderLog);
               NSLog(@"Fragment shader compile log:%@",self.program.fragmentShaderLog);
               assert(false);
           }
           
           // 给Program添加属性(shader脚本中定义好的变量)，默认脚本中使用三个变量
           self.positionAttribute = [self.program attributeIndex:@"position"];
           self.inputTextureCoorAttribute = [self.program attributeIndex:@"inputTextureCoordinate"];
           self.textureUniform = [self.program uniformIndex:@"inputTexture"];
     }
    return self;
}


- (void)render:(CGSize)size
{
    [self render:size setupViewPort:YES];
}

// 通过默认脚本绘制一个三角形
- (void)render:(CGSize)size setupViewPort:(BOOL)setupViewPort{
    // 当前上下文使用该渲染管线
    [self.program use];
    
    // 定义裁剪空间转换到屏幕上的空间大小
    glViewport(0, 0, size.width, size.height);
    
    // 输入顶点坐标
    glEnableVertexAttribArray(self.positionAttribute);
    const float vertex[8] = {
        -0.5, -0.5,
        -0.5, 0.5,
        0.5, 0.5 };
    
    // 将顶点坐标和programz中position这个变量联系到一起
//    我们通过glVertexAttribPointer函数将三角形的三个顶点分别传递到position这个变量中。


    glVertexAttribPointer(self.positionAttribute, 2, GL_FLOAT, GL_FALSE, 0, vertex);
    
    // 使用三角形图元绘制
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 3);
//    述
//    glEnableVertexAttribArray启用index指定的通用顶点属性数组。 glDisableVertexAttribArray禁用index指定的通用顶点属性数组。 默认情况下，禁用所有客户端功能，包括所有通用顶点属性数组。 如果启用，将访问通用顶点属性数组中的值，并在调用顶点数组命令（如glDrawArrays或glDrawElements）时用于呈现。
    glDisableVertexAttribArray(self.positionAttribute);
}



/**
 *  调整纹理顶点坐标让它和ViewPort比例一致
 */
- (GLfloat *)textureVertexForViewSize:(CGSize)viewSize textureSize:(CGSize)textureSize {
    static GLfloat position[8];
    
    GLfloat viewAspectRatio = viewSize.width / viewSize.height;
    GLfloat textureAspectRatio = textureSize.width / textureSize.height;
    
    GLfloat widthScaling = 1;
    GLfloat heightScaling = 1;
    if (viewAspectRatio < textureAspectRatio) {
        GLfloat height = (viewSize.width / textureSize.width) * textureSize.height;
        heightScaling = height / viewSize.height;
    }else{
        GLfloat width = (viewSize.height / textureSize.height) * textureSize.width;
        widthScaling = width / viewSize.width;
    }
    
    position[0] = -widthScaling;
    position[1] = -heightScaling;
    position[2] = widthScaling;
    position[3] = -heightScaling;
    position[4] = -widthScaling;
    position[5] = heightScaling;
    position[6] = widthScaling;
    position[7] = heightScaling;
    return position;
}


@end
