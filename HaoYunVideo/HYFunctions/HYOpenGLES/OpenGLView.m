//
//  OpenGLView.m
//  HaoYunVideo
//
//  Created by 范浩云 on 2019/12/18.
//  Copyright © 2019 范浩云. All rights reserved.
//

#import "OpenGLView.h"
#import "OpenGLContext.h"
#import "OpenGLRender.h"
#import "OpenGLTriangleMoveRender.h"
#import "OpenGLTextureRender.h"
#import "OpenGLSimpleRender.h"

@interface OpenGLView()

@property (nonatomic, assign) GLuint framebuffer;

@property (nonatomic, assign) GLuint renderbuffer;

//可以看到这个文件的封装非常简单，提供了支持的OpenGL API等级和OpenGL上下文（这里记得吧，OpenGL是一个状态机，所以这里抽象出OpenGL的执行环境作为外部接口，意味着在iOS上OpenGL的执行代码都是运行在这些Context中的）。
//@property (nonatomic, strong) EAGLContext *eaglContext;
@property (nonatomic, strong) OpenGLContext *context;

//渲染
//@property (nonatomic, strong) OpenGLRender *render;


//@property (nonatomic, strong) OpenGLTextureRender *render;


@property (nonatomic, strong) OpenGLSimpleRender *render;




//@property (nonatomic, strong) OpenGLTriangleMoveRender *render;




//OpenGL部分的接口有了，那么UIKit的呢？怎么将它们联系起来呢？首先，我们知道UIView中的渲染功能实际上是由CAlayer来完成的，然后再查一下文档发现有一个CALayer叫CAEAGLLayer。也就意味着UIKit中和OpenGL对接的部分就是通过这个Layer来完成的。
@property (nonatomic, strong) CAEAGLLayer *eaglLayer;

@property (nonatomic, assign) CGSize oldSize;

@property (nonatomic, strong) CADisplayLink *displayLink;


//一边是EAGLContext，一边是CAEAGLLayer。OpenGL和UIView的接口都有了，那么具体如何将它们联系在一起呢？
//
//仔细看一下CAEAGLLayer.h这个文件，可以发现这个Layer跟随一个叫EAGLDrawable的协议。意味着这个Layer将通过EAGLDrawable中的方法将OpenGL和Layer联系在一起，简单的说这个Layer内部实现了EAGLDrawable的方法实现利用OpenGL引擎来渲染图形图像。而我们只需要向CAEAGLLayer喂渲染数据就行了。（这里EGL就实现了，接口相当简洁吧！）

@end



@implementation OpenGLView

// 表示这个视图的Layer是CAEAGLLayer
+ (Class)layerClass{
    return [CAEAGLLayer class];
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

//初始化方法
- (void)commonInit {
    self.eaglLayer = (CAEAGLLayer *)self.layer;
    
//    // 初始化Context并且OpenGL状态机为该Context
//    self.eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
//    [EAGLContext setCurrentContext:self.eaglContext];
//
    
    
    self.context = [[OpenGLContext alloc] init];
    self.render = [[OpenGLSimpleRender alloc] init];
    
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkUpdete)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

// Layout的时候重新适配一个Renderbuffer
//Renderbuffer显示区域的大小是在绑定的时候就确定的，如果想变更大小只有重新创建绑定一遍。所以当UIView在layoutSubviews的时候要检查一下帧大小是否改变了，并重新绑定Renderbuffer。
- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    //当前的size 为零或者当前的帧的大小有变化的时候就更新帧的大小
    //并重新绑定Renderbuffer。
    if (CGSizeEqualToSize(self.oldSize, CGSizeZero)
        || !CGSizeEqualToSize(_oldSize, size)) {
        [self linkOpenGLBuffer];
        self.oldSize = size;
    }
}



//TODO:重新绑定帧缓冲区
//接下来就是framebuffer <-> GL_FRAMEBUFFER <-> GL_RENDERBUFFER <-> renderbuffer的绑定流程：
- (void)linkOpenGLBuffer {
    // 用于显示的layer
    self.eaglLayer = (CAEAGLLayer *)self.layer;
    
    // CALayer默认是透明的，而透明的层对性能负荷很大。所以将其关闭。
    self.eaglLayer.opaque = YES;
    
    // 释放旧的renderbuffer
    if (_renderbuffer) {
        glDeleteRenderbuffers(1, &_renderbuffer);
        _renderbuffer = 0;
    }
    
    // 释放旧的framebuffer
    if (_framebuffer) {
        glDeleteFramebuffers(1, &_framebuffer);
        _framebuffer = 0;
    }
    
    // 生成renderbuffer
    glGenRenderbuffers(1, &_renderbuffer);
    
    // 绑定_renderbuffer到当前OpenGL Context的GL_RENDERBUFFER中
    glBindRenderbuffer(GL_RENDERBUFFER, _renderbuffer);
    
    // 绑定_renderbuffer到eaglLayer上
//    [_eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
       [self.context.eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    // 生成framebuffer(之后OpenGL的数据均传递到这个framebuffer中)
    glGenFramebuffers(1, &_framebuffer);
    
    // 绑定_framebuffer到当前OpenGL Context的GL_FRAMEBUFFER中
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
    
    // 绑定当前OpenGL Context的GL_FRAMEBUFFER和GL_RENDERBUFFER
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderbuffer);
    
    // 在此完成_framebuffer<--->GL_FRAMEBUFFER<--->GL_RENDERBUFFER<--->_renderbuffer的绑定
    
    // 检查framebuffer是否创建成功
    NSError *error;
    NSAssert1([self checkFramebuffer:&error], @"%@",error.userInfo[@"ErrorMessage"]);
}
- (BOOL)checkFramebuffer:(NSError *__autoreleasing *)error {
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    NSString *errorMessage = nil;
    BOOL result = NO;
    
    switch (status) {
        case GL_FRAMEBUFFER_UNSUPPORTED:
            errorMessage = @"framebuffer不支持该格式";
            result = NO;
            break;
        case GL_FRAMEBUFFER_COMPLETE:
            NSLog(@"framebuffer 创建成功");
            result = YES;
            break;
        case GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:
            errorMessage = @"Framebuffer不完整 缺失组件";
            result = NO;
            break;
        case GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS:
            errorMessage = @"Framebuffer 不完整, 附加图片必须要指定大小";
            result = NO;
            break;
        default:
            // 一般是超出GL纹理的最大限制
            errorMessage = @"未知错误 error !!!!";
            result = NO;
            break;
    }
    
    NSLog(@"%@",errorMessage ? errorMessage : @"");
    *error = errorMessage ? [NSError errorWithDomain:@"error" code:status userInfo:@{@"ErrorMessage" : errorMessage}] : nil;
    
    return result;
}


- (void)displayLinkUpdete
{
    
// 保证是在当前Context中
//   if ([EAGLContext currentContext] != _eaglContext) {
//       [EAGLContext setCurrentContext:_eaglContext];
//   }
      [self.context useAsCurrent];
    
    
    
   // 保证GL_RENDERBUFFER和GL_FRAMEBUFFER绑定的对象是正确的
   glBindRenderbuffer(GL_RENDERBUFFER, _renderbuffer);
   glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
   
   // 给framebuffer画上背景色（最简单的fbo操作)
   glClearColor(1, 0, 0, 0);// 红色
   glClear(GL_COLOR_BUFFER_BIT);
    
   // 告知eaglContext可以renderbuffer
//   [self.eaglContext presentRenderbuffer:GL_RENDERBUFFER];
    
    
    [self.render render:self.frame.size];
    
    // 告知eaglContext可以renderbuffer
    [self.context swapToScreen];
    
}
@end
