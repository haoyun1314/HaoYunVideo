//
//  HYCaptureManager.h
//  HaoYunVideo
//
//  Created by 范浩云 on 2019/9/17.
//  Copyright © 2019 范浩云. All rights reserved.
//
//拍照流程：
// 1.创建会话
// 2.创建输入设备
// 3.创建输入
// 4.创建输出设备
// 5.创建输出
// 6.连接输入与会话
// 7.预览画面
///////////

//======视频输出
//1. 创建捕捉会话
//2. 设置视频的输入 和 输出
//3. 设置音频的输入 和 输出
//4. 添加视频预览层
//5. 开始采集数据，这个时候还没有写入数据，用户点击录制后就可以开始写入数据
//6. 初始化AVAssetWriter, 我们会拿到视频和音频的数据流，用AVAssetWriter写


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AVAssetWriteManager.h"
#import "XCFileManager.h"


#define MAX_PINCH_SCALE_NUM 3.f
#define MIN_PINCH_SCALE_NUM 1.f
#define DeviceIsPad       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


typedef void (^DetectBrightnessCallback)(CGFloat brightness);

typedef NS_ENUM(NSUInteger, NBCaptureManagerType) {
    CaptureManagerTypePicAsk,
    CaptureManagerTypeSummerHomework,
    CaptureManagerTypeError,
    CaptureManagerTypeOther
};


typedef enum : NSUInteger {
    CameraDirectionPortrait,
    CameraDirectionLandscapeLeft,
    CameraDirectionLandscapeRight,
} CameraDirection;




typedef void (^DidCapturePhotoBlock)(UIImage *stillImage);

typedef void (^GetCapurePhoto)(UIImage *stillImage);


@interface HYCaptureManager : NSObject

@property (nonatomic, assign) NBCaptureManagerType captureType;

@property (nonatomic, weak) UIView *preview;

@property (nonatomic,strong) dispatch_queue_t sessionQueue;

@property (nonatomic) dispatch_queue_t scanQueue;

//会话
@property (nonatomic,strong) AVCaptureSession *session;
//预览view
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
//输入设备
@property (nonatomic,strong) AVCaptureDeviceInput *inputDevice;
//视频输出
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;

//IOS10之前的拍照API图片输出
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;
//IOS10以上的拍照API图片输出
@property (nonatomic,strong) AVCapturePhotoOutput *photoImageOutput;

//IOS10以上拍照设置
@property (nonatomic,strong) AVCapturePhotoSettings *photoSetting;
///亮度
@property (nonatomic, copy) void (^brightBlock)(int bright);
///获取图片
@property (nonatomic,copy) DidCapturePhotoBlock capturegGetPhotoBlock;

//拉伸倍数
@property (nonatomic, assign) CGFloat preScaleNum;
@property (nonatomic, assign) CGFloat scaleNum;

//录制

@property (nonatomic,strong) AVCaptureDeviceInput * audioInput;

@property (nonatomic,strong) AVCaptureAudioDataOutput * audoDataOutPut;

@property (nonatomic, assign) FMRecordState recordState;

@property (nonatomic, strong, readonly) NSURL *videoUrl;





///相机的方向
@property (nonatomic,assign) CameraDirection direction;

///开始会话
-(void)sessionStartRunning;
///停止会话
-(void)sessionStopRunning;

/**
 初始化相机配置
 
 @param parent 预览层父视图
 @param preivewRect预览层的frame
 @param orientation 方向
 @param isFrontCamera 是否为前置摄像头
 @param detectBlock 检测光线环境
 */
- (void)configureWithParentLayer:(UIView *)parent
                     previewRect:(CGRect)preivewRect
            withVideoOrientation:(AVCaptureVideoOrientation)orientation
                   isFrontCamera:(BOOL)isFrontCamera
             detectEnvBrightness:(DetectBrightnessCallback)detectBlock;

///拍照
- (void)takePicture:(DidCapturePhotoBlock)block;
///切换摄像头
- (void)switchCamera:(BOOL)isFrontCamera;
///设置倍数
- (void)pinchCameraViewWithScalNum:(CGFloat)scale;
///放大缩小
- (void)pinchCameraView:(UIPinchGestureRecognizer *)gesture;
///切换闪光灯模式
- (void)switchFlashMode:(BOOL)modeOn;
///点击对焦
- (void)focusInPoint:(CGPoint)devicePoint;
///是否有闪光灯提示
- (BOOL)hasFlashModeWithShowTip:(BOOL)showTip;
///添加一些配置
- (void)subjectAreaDidChange:(NSNotification *)notification;
///添加到父视图
-(void)addLayerToParentView:(UIView *)aParentView;
///停止录制
- (void)stopRecord;
///开始录制
- (void)startRecord;




@end
