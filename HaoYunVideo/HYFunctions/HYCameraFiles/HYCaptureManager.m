//
//  HYCaptureManager.m
//  HaoYunVideo
//
//  Created by 范浩云 on 2019/9/17.
//  Copyright © 2019 范浩云. All rights reserved.
//

#import "HYCaptureManager.h"
#import <ImageIO/ImageIO.h>
//video
#define RECORD_MAX_TIME 8.0           //最长录制时间
#define TIMER_INTERVAL 0.05         //计时器刷新频率
#define VIDEO_FOLDER @"videoFolder" //视频录制存放文件夹

@interface HYCaptureManager () <AVCaptureVideoDataOutputSampleBufferDelegate,
AVCapturePhotoCaptureDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,AVAssetWriteManagerDelegate>
@property (nonatomic, strong) dispatch_queue_t videoDataOutputQueue;
@property (nonatomic, copy) DetectBrightnessCallback detectBlock;

@property (nonatomic,assign) CGRect preivewRect;
@property (nonatomic,assign) BOOL isSearchPic;//是否是前置摄像头

@property (nonatomic, strong)AVAssetWriteManager *writeManager;

@property (nonatomic, strong, readwrite) NSURL *videoUrl;


@property (nonatomic, assign) FMVideoViewType viewType;

@end

@implementation HYCaptureManager

#pragma mark -
#pragma mark configure
- (id)init {
    if (self = [super init]) {
        _scaleNum = 1.f;
        _preScaleNum = 1.f;
    }
    return self;
}

- (void)dealloc {
    
    NSLog(@"HYCaptureManager");
    
    [_session stopRunning];
    self.previewLayer = nil;
    self.session = nil;
    if (MPT_IOS10) {
        self.stillImageOutput = nil;
        self.photoSetting = nil;
        self.capturegGetPhotoBlock = nil;
        self.photoImageOutput = nil;
    } else {
        self.stillImageOutput = nil;
    }
}

- (void)configureWithParentLayer:(UIView *)parent
                     previewRect:(CGRect)preivewRect
            withVideoOrientation:(AVCaptureVideoOrientation)orientation
                   isFrontCamera:(BOOL)isFrontCamera
             detectEnvBrightness:(DetectBrightnessCallback)detectBlock {
    
     self.preivewRect = preivewRect;
      self.isSearchPic = !isFrontCamera;
    
    // 1、队列
    [self createQueue];
    // 2、session
    [self addSession];
    // 4、input
    [self addVideoInputFrontCamera:isFrontCamera];
    
    // 5、output图片输出
    [self addStillImageOutput];
    //   6.设置视频

    //7.
    //设置预览view
    self.preview = parent;
    [self addVideoPreviewLayerWithRect:preivewRect];
    [parent.layer addSublayer:_previewLayer];
    [_previewLayer.connection setVideoOrientation:orientation];
    
    //录制视频和音频
    [self addVideoDataOutput];
    [self addAudoDataOutPut];
    [self setUpWriter];
    
}



/**
 *  创建一个队列，防止阻塞主线程
 dispatch_queue_t mySerialDispatchQueue = dispatch_queue_create("生成队列的名称", NULL);
 
 第一个参数：
 指定生成返回的Dispatch Queue的名称
 命名规则：简单易懂
 该名称在Xcode和Instruments的调试器中作为Dispatch Queue的名称表示
 该名称也会出现在程序崩溃时所生成的CrashLog中
 
 第二个参数：
 指定为NULL或DISPATCH_QUEUE_SERIAL,生成Serial Dispatch Queue。
 指定为DISPATCH_QUEUE_CONCURRENT，生成Concurrent Dispatch Queue。
 
 返回值：
 表示Dispatch Queue的dispatch_queue_t类型
 */
- (void)createQueue {
    
    //创建一个现形队列
    dispatch_queue_t sessionQueue =
    dispatch_queue_create("com.HaoYun.gcd.CameraSerialDispatchQueue", DISPATCH_QUEUE_SERIAL);
    self.sessionQueue = sessionQueue;
}

/**
 *  session
 */
- (void)addSession
{
    AVCaptureSession *tmpSession = [[AVCaptureSession alloc] init];
    if (DeviceIsPad)
    {
        if ([tmpSession canSetSessionPreset:AVCaptureSessionPresetPhoto])
        {
            tmpSession.sessionPreset = AVCaptureSessionPresetPhoto;
        }
    }
    else
    {
        //图片质量会小很多拍照速度更快
        if ([tmpSession canSetSessionPreset:AVCaptureSessionPresetHigh])
        {
            tmpSession.sessionPreset = AVCaptureSessionPresetHigh;
        }
    }
    self.session = tmpSession;
}

/**
 *  相机的实时预览页面
 *
 *  @param previewRect 预览页面的frame
 */
- (void)addVideoPreviewLayerWithRect:(CGRect)previewRect {
    
    AVCaptureVideoPreviewLayer *preview =
    [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [preview.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    preview.frame = previewRect;
    self.previewLayer = preview;
}

/**
 *  添加输入设备
 *
 *  @param front 前或后摄像头
 */
- (void)addVideoInputFrontCamera:(BOOL)front {
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *backCamera = nil;
    
    //获取前置或者后置摄行头
    for (AVCaptureDevice *device in devices)
    {
        if ([device hasMediaType:AVMediaTypeVideo])
        {
            if ([device position] == AVCaptureDevicePositionBack && !front)
            {
                backCamera = device;
                break;
            } else if ([device position] == AVCaptureDevicePositionFront && front) {
                backCamera = device;
                break;
            }
        }
    }
        
    //向session添加输入设备
    NSError *error = nil;
    AVCaptureDeviceInput *backFacingCameraDeviceInput =
    [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
    if (!error) {
        if ([_session canAddInput:backFacingCameraDeviceInput])
        {
            [_session addInput:backFacingCameraDeviceInput];
            self.inputDevice = backFacingCameraDeviceInput;
        }
        else
        {
        }
    }
}


/**
*  添加输出设备
1.6、重复使用照片设置
 
每个AVCapturePhotoSettings实例只能被一次拍摄使用，否则uniqueID会与之前的拍摄设置的uniqueID相同，导致-capturePhotoWithSettings:delegate:方法异常 NSInvalidArg umentException 。

第一次创建：+ (instancetype)photoSettingsWithFormat:(nullable NSDictionary<NSString *, id> *)format;
 
 第二次重复使用：
我们可以使用下述方法创建一个新的AVCapturePhotoSettings，来实现重复使用特定的设置组合的需求。新创建的实例的uniqueID属性具有新的唯一值，但会复制photoSettings参数中所有其他属性的值。
+ (instancetype)photoSettingsFromPhotoSettings:(AVCapturePhotoSettings *)photoSettings;
 
2、AVCapturePhotoSettings 的唯一标识
@property(readonly) int64_t uniqueID;
创建AVCapturePhotoSettings 实例会自动为此属性分配唯一值。

使用此属性可跟踪照片拍摄请求。在AVCapturePhotoOutput的协议方法都包含一个AVCaptureResolvedPhotoSettings实例，其uniqueID属性与用于请求拍摄时创建的AVCapturePhotoSettings实例的uniqueID值相匹配。
*/
- (void)addStillImageOutput
{
             if (@available(iOS 10.0, *))
             {
                                  
                 AVCapturePhotoOutput *tmpOutput = [[AVCapturePhotoOutput alloc] init];
                 if (@available(iOS 11.0, *))
                 {
                     NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
                     self.photoSetting  = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
                 }
                 else
                 {
                     NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecJPEG};
                     self.photoSetting  = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
                 }
                 [tmpOutput setPhotoSettingsForSceneMonitoring:self.photoSetting];
                 if ([_session canAddOutput:tmpOutput]) {
                     [_session addOutput:tmpOutput];
                 }
                 self.photoImageOutput = tmpOutput;
                 
             } else {
                 AVCaptureStillImageOutput *tmpOutput = [[AVCaptureStillImageOutput alloc] init];
                 NSDictionary *outputSettings = [[NSDictionary alloc]
                                                 initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil]; //输出jpeg
                 tmpOutput.outputSettings = outputSettings;
                 if ([_session canAddOutput:tmpOutput]) {
                     [_session addOutput:tmpOutput];
                 }
                 self.stillImageOutput = tmpOutput;
             }
    
}





/**
 添加额外输出源检测光线环境强弱
 */
- (void)addVideoDataOutput {

    //创建一个默认的串型队列
    self.videoDataOutputQueue = dispatch_queue_create("capture.video.queue", DISPATCH_QUEUE_SERIAL);
    //目标队列是全局并发队列执行优先级是并列的，无须的
    dispatch_set_target_queue(self.videoDataOutputQueue,
                              dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.videoDataOutput.videoSettings =
    @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
    
    [self.videoDataOutput setSampleBufferDelegate:self queue:self.videoDataOutputQueue];
    self.videoDataOutput.alwaysDiscardsLateVideoFrames = NO;
    if ([self.session canAddOutput:self.videoDataOutput]) {
        [self.session addOutput:self.videoDataOutput];
    }
}


- (void)addAudoDataOutPut
{
    // 2.2 获取音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    NSError *error=nil;
    // 2.4 创建音频输入源
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    // 2.6 将音频输入源添加到会话
    if ([self.session canAddInput:self.audioInput]) {
        [self.session addInput:self.audioInput];
    }
    
    self.audoDataOutPut = [[AVCaptureAudioDataOutput alloc] init];
    [self.audoDataOutPut setSampleBufferDelegate:self queue:self.videoDataOutputQueue ];
    if([self.session canAddOutput:self.audoDataOutPut]) {
        [self.session addOutput:self.audoDataOutPut];
    }
    
}





#pragma mark - actions

/**
 *  拍照
 */
- (void)takePicture:(DidCapturePhotoBlock)block
{
    self.capturegGetPhotoBlock = block;
    if (@available(iOS 10.0, *))
    {
        AVCaptureConnection *videoConnection = [self findVideoConnection];
         if (!videoConnection)
         {
              return;
          }
        if (@available(iOS 11.0, *))
        {
            NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
            self.photoSetting  = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
        }
        else
        {
            NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecJPEG};
            self.photoSetting  = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
        }
        
        
        if (self.photoSetting ==nil) {
            return;
        }
        
                
        [self.photoImageOutput setPhotoSettingsForSceneMonitoring:self.photoSetting];
        //必须保持self.photoSetting.uniqueID是唯一的负责会报异常
        NSLog(@"self.photoSetting = %lld",self.photoSetting.uniqueID);
        [videoConnection setVideoOrientation:[self getVideoOrientation]];
        [videoConnection setVideoScaleAndCropFactor:_scaleNum];
        [self.photoImageOutput capturePhotoWithSettings:self.photoSetting delegate:self];
    }
    else
    {
        AVCaptureConnection *videoConnection = [self findVideoConnection];
           [videoConnection setVideoScaleAndCropFactor:_scaleNum];
                   if (!videoConnection) {return;}
                   @try {
                       
                       NSLog(@"%@",[NSThread currentThread]);
                       
                       
                       [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                                      completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
                                                                          if (!error && imageDataSampleBuffer) {
                                                                              
                                                                              NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                                              UIImage *image = [[UIImage alloc] initWithData:imageData];
                                                                              
                                                                              
                                                                              if (block) {
                                                                                  block(image);
                                                                              }
                                                                          }
                                                                          
                                                                      }];
                   }
                   @catch (NSException *exception) {
                   }

    }
}



/**
 //TODO:切换前后摄像头
 *
 *  @param isFrontCamera YES:前摄像头  NO:后摄像头
 */
- (void)switchCamera:(BOOL)isFrontCamera {
    if (!_inputDevice) {
        return;
    }
    [_session beginConfiguration];
    
    [_session removeInput:_inputDevice];
    
    [self addVideoInputFrontCamera:isFrontCamera];
    
    [_session commitConfiguration];
}

/**
 //TODO:拉近拉远镜头
 *
 *  @param scale 拉伸倍数
 */
- (void)pinchCameraViewWithScalNum:(CGFloat)scale {
    _scaleNum = scale;
    if (_scaleNum < MIN_PINCH_SCALE_NUM) {
        _scaleNum = MIN_PINCH_SCALE_NUM;
    } else if (_scaleNum > MAX_PINCH_SCALE_NUM) {
        _scaleNum = MAX_PINCH_SCALE_NUM;
    }
    [self doPinch];
    _preScaleNum = scale;
}

- (void)pinchCameraView:(UIPinchGestureRecognizer *)gesture {
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [gesture numberOfTouches], i;
    for (i = 0; i < numTouches; ++i) {
        CGPoint location = [gesture locationOfTouch:i inView:_preview];
        CGPoint convertedLocation = [_previewLayer convertPoint:location
                                                      fromLayer:_previewLayer.superlayer];
        if (![_previewLayer containsPoint:convertedLocation]) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if (allTouchesAreOnThePreviewLayer) {
        _scaleNum = _preScaleNum * gesture.scale;
        
        if (_scaleNum < MIN_PINCH_SCALE_NUM) {
            _scaleNum = MIN_PINCH_SCALE_NUM;
        } else if (_scaleNum > MAX_PINCH_SCALE_NUM) {
            _scaleNum = MAX_PINCH_SCALE_NUM;
        }
        
        [self doPinch];
    }
    
    if ([gesture state] == UIGestureRecognizerStateEnded ||
        [gesture state] == UIGestureRecognizerStateCancelled ||
        [gesture state] == UIGestureRecognizerStateFailed) {
        _preScaleNum = _scaleNum;
    }
}

- (void)doPinch {
    AVCaptureConnection *videoConnection = [self findVideoConnection];
    CGFloat maxScale =
    videoConnection
    .videoMaxScaleAndCropFactor; // videoScaleAndCropFactor这个属性取值范围是1.0-videoMaxScaleAndCropFactor。iOS5+才可以用
    if (_scaleNum > maxScale) {
        _scaleNum = maxScale;
    }
    
    //    videoConnection.videoScaleAndCropFactor = _scaleNum;
    [CATransaction begin];
    [CATransaction setAnimationDuration:.025];
    [_previewLayer setAffineTransform:CGAffineTransformMakeScale(_scaleNum, _scaleNum)];
    [CATransaction commit];
}

- (BOOL)hasFlashModeWithShowTip:(BOOL)showTip {
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (!captureDeviceClass) {
        return NO;
    }
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![device hasFlash]) {
        if (showTip) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:@"您的设备没有闪光灯功能"
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        return NO;
    }
    return YES;
}

/**
 //TODO:切换闪光灯模式
 *  @param modeOn 闪光灯开关
 */
- (void)switchFlashMode:(BOOL)modeOn {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    
    if ([device hasFlash]) {
        if (modeOn && [device isTorchModeSupported:AVCaptureTorchModeOn]) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else if (!modeOn && [device isTorchModeSupported:AVCaptureTorchModeOff]) {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"您的设备没有闪光灯功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [device unlockForConfiguration];
}

/**
 *  点击后对焦
 *
 *  @param devicePoint 点击的point
 */
- (void)focusInPoint:(CGPoint)devicePoint {
    if (CGRectContainsPoint(_previewLayer.bounds, devicePoint) == NO) {
        return;
    }
    devicePoint = [self convertToPointOfInterestFromViewCoordinates:devicePoint];
    AVCaptureFocusMode focusMode = AVCaptureFocusModeContinuousAutoFocus;
    
    [self focusWithMode:focusMode
         exposeWithMode:AVCaptureExposureModeContinuousAutoExposure
          atDevicePoint:devicePoint
monitorSubjectAreaChange:YES];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode
       exposeWithMode:(AVCaptureExposureMode)exposureMode
        atDevicePoint:(CGPoint)point
monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(weakSelf.sessionQueue, ^{
        AVCaptureDevice *device = [weakSelf.inputDevice device];
        NSError *error = nil;
        if ([device lockForConfiguration:&error]) {
            if ([device isFocusPointOfInterestSupported] &&
                [device isFocusModeSupported:focusMode]) {
                [device setFocusMode:focusMode];
                [device setFocusPointOfInterest:point];
            }
            if ([device isExposurePointOfInterestSupported] &&
                [device isExposureModeSupported:exposureMode]) {
                [device setExposureMode:exposureMode];
                [device setExposurePointOfInterest:point];
            }
            [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
            [device unlockForConfiguration];
        } else {
        }
    });
}

- (void)subjectAreaDidChange:(NSNotification *)notification {
    
    CGPoint devicePoint = CGPointMake(.5, .5);
    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus
         exposeWithMode:AVCaptureExposureModeContinuousAutoExposure
          atDevicePoint:devicePoint
monitorSubjectAreaChange:YES];
}

/**
 *  外部的point转换为camera需要的point(外部point/相机页面的frame)
 *
 *  @param viewCoordinates 外部的point
 *
 *  @return 相对位置的point
 */
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates {
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = _previewLayer.bounds.size;
    
    AVCaptureVideoPreviewLayer *videoPreviewLayer = self.previewLayer;
    
    if ([[videoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResize]) {
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height,
                                      1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        for (AVCaptureInputPort *port in [[self.session.inputs lastObject] ports]) {
            if ([port mediaType] == AVMediaTypeVideo) {
                cleanAperture =
                CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if ([[videoPreviewLayer videoGravity]
                     isEqualToString:AVLayerVideoGravityResizeAspect]) {
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
                        if (point.x >= blackBar && point.x <= blackBar + x2) {
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
                        if (point.y >= blackBar && point.y <= blackBar + y2) {
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if ([[videoPreviewLayer videoGravity]
                            isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2;
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2);
                        xc = point.y / frameSize.height;
                    }
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}

#pragma mark---------------private--------------
- (AVCaptureConnection *)findVideoConnection {
    if (MPT_IOS10) {
        return [self.photoImageOutput connectionWithMediaType:AVMediaTypeVideo];
    } else {
        AVCaptureConnection *videoConnection = nil;
        for (AVCaptureConnection *connection in _stillImageOutput.connections) {
            for (AVCaptureInputPort *port in connection.inputPorts) {
                if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                    videoConnection = connection;
                    [videoConnection setVideoOrientation:[self getVideoOrientation]];
                    break;
                }
            }
            if (videoConnection) {
                break;
            }
        }
        return videoConnection;
    }
}

- (AVCaptureVideoOrientation)getVideoOrientation {
    switch (self.direction) {
        case CameraDirectionPortrait:
            return AVCaptureVideoOrientationPortrait;
        case CameraDirectionLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeRight;
        case CameraDirectionLandscapeRight:
            return AVCaptureVideoOrientationLandscapeLeft;
        default:
            return AVCaptureVideoOrientationLandscapeRight;
            break;
    }
}

- (void)addGrid {
    
}

- (void)drawALineWithFrame:(CGRect)frame andColor:(UIColor *)color inLayer:(CALayer *)parentLayer {
    CALayer *layer = [CALayer layer];
    layer.frame = frame;
    layer.backgroundColor = color.CGColor;
    [parentLayer addSublayer:layer];
}



/**
 ios11开始我们就可以使用HIEF(HEIC)格式来存储图片和视频了.这种格式体积小速度快(硬解码)
 使用苹果的 iPhone 或 iPad 拍摄照片,该照片将以 .HEIC 扩展名保存在「照片」文件当中。由于 HEIC 是一种容器格式，所以它可以存储以 HEVC 格式编码的声音和图像。
 
 例如，你在 iPhone 上拍摄照片时启用了 Live Photo，则会得到一个 .HEIC 文件，这个文件中会包含多张照片和录制的声音文件——组成 Live Photo 的所有内容。
 
 HEIF优于JPEG图像格式
 高效率图像格式在各方面均优于 JPEG，通过使用更现代的压缩算法，它可以将相同数量的数据大小压缩到 JPEG 图像文件的 50% 左右。随着手机 Camera 的不断升级，照片的细节也日益增加。通过将照片存储为 HEIF 格式而不非 JPEG，可以让文件大小减半，几乎可以在同一部手机上存储以前 2 倍的照片数量。如果一些云服务也支持 HEIF 文件，则上传到在线服务的速度也会更快，并且使用更少的存储空间。在 iPhone 上，这意味着您的照片应该会以以前两倍的速度上传到 iCloud 照片库。
 
 HEIC唯一缺点：兼容性
 目前使用 HEIF 或 HEIC 照片唯一的缺点就是兼容性问题。现在的软件只要能够查看图片，那它肯定就可以读取 JPEG 图像，但如果你拍摄了以 HEIF 或 HEIC 扩展名结尾的图片，并不是在所有地方和软件中都可以正确识别
 */
- (void)captureOutput:(AVCapturePhotoOutput *)output
didFinishProcessingPhoto:(AVCapturePhoto *)photo
                error:(nullable NSError *)error API_AVAILABLE(ios(11.0)) {
    if (!error)
    {
        //这个就是HEIF(HEIC)的文件数据,直接保存即可
        NSData *data = photo.fileDataRepresentation;
        NSLog(@"data.length = %lu",(unsigned long)data.length);
        UIImage *image = [UIImage imageWithData:data];
        if (self.capturegGetPhotoBlock) {
            self.capturegGetPhotoBlock(image);
        }
    }else{
    }
}



//iOS10
- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error  API_AVAILABLE(ios(10.0))
{
       if (!error) {
               NSData *data = [AVCapturePhotoOutput
                               JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer
                               previewPhotoSampleBuffer:previewPhotoSampleBuffer];
               UIImage *image = [UIImage imageWithData:data];
               if(self.capturegGetPhotoBlock)
               {
                   self.capturegGetPhotoBlock(image);
               }
           }
}


-(void)sessionStartRunning{

    __weak typeof(self) weakSelf = self;
    dispatch_async(self.sessionQueue, ^{
        __strong typeof(weakSelf) strongSelf =weakSelf;
        if (!strongSelf.session.running) {
            [strongSelf.session startRunning];
        }
    });

}

-(void)sessionStopRunning{

    __weak typeof(self) weakSelf = self;
    dispatch_async(self.sessionQueue, ^{
        __strong typeof(weakSelf) strongSelf =weakSelf;
        if (strongSelf.session.running) {
            [strongSelf.session stopRunning];
        }
    });
}


-(void)addLayerToParentView:(UIView *)aParentView
{
    self.preview = aParentView;
    [aParentView.layer addSublayer:_previewLayer];
}




#pragma mark---AVAssetWriteManagerDelegate


- (void)finishWriting
{
    
}
- (void)updateWritingProgress:(CGFloat)progress
{
    
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate----AVCaptureAudioDataOutputSampleBufferDelegate----

//写入视频
- (void)setUpWriter
{
    self.videoUrl = [[NSURL alloc] initFileURLWithPath:[self createVideoFilePath]];
    self.writeManager = [[AVAssetWriteManager alloc] initWithURL:self.videoUrl viewType:TypeFullScreen];
    self.writeManager.delegate = self;
    
}


- (void)startRecord
{
    if (self.recordState == FMRecordStateInit) {
        [self.writeManager startWrite];
        self.recordState = FMRecordStateRecording;
    }
}

- (void)stopRecord
{
    [self.writeManager stopWrite];
    [self.session stopRunning];
    self.recordState = FMRecordStateFinish;
    
}

- (void)reset
{
    self.recordState = FMRecordStateInit;
    [self.session startRunning];
    [self setUpWriter];
    
}



//写入的视频路径
- (NSString *)createVideoFilePath
{
    NSString *videoName = [NSString stringWithFormat:@"%@.mp4", [NSUUID UUID].UUIDString];
    NSString *path = [[self videoFolder] stringByAppendingPathComponent:videoName];
    return path;
}


//存放视频的文件夹
- (NSString *)videoFolder
{
    NSString *cacheDir = [XCFileManager cachesDir];
    NSString *direc = [cacheDir stringByAppendingPathComponent:VIDEO_FOLDER];
    if (![XCFileManager isExistsAtPath:direc]) {
        [XCFileManager createDirectoryAtPath:direc];
    }
    return direc;
}
//清空文件夹
- (void)clearFile
{
    [XCFileManager removeItemAtPath:[self videoFolder]];
    
}

/**
//TODO:AVCaptureVideoDataOutputSampleBufferDelegate
每当AVCaptureVideoDataOutput实例输出新的视频帧时调用
需要设置代理为： AVCaptureVideoDataOutputSampleBufferDelegate
output:输出帧的AVCaptureVideoDataOutput实例
sampleBuffer:一个CMSampleBuffer对象，包含视频帧数据和帧的附加信息，如格式和表示时间。
connection:接收视频的AVCaptureConnection。
*/

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    
    @autoreleasepool {
           
           //视频
           if (connection == [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo]) {
               
               if (!self.writeManager.outputVideoFormatDescription) {
                   @synchronized(self) {
                       CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
                       self.writeManager.outputVideoFormatDescription = formatDescription;
                   }
               } else {
                   @synchronized(self) {
                       if (self.writeManager.writeState == FMRecordStateRecording) {
                           [self.writeManager appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeVideo];
                       }

                   }
               }
               
           }
           
           //音频
           if (connection == [self.audoDataOutPut connectionWithMediaType:AVMediaTypeAudio]) {
               if (!self.writeManager.outputAudioFormatDescription) {
                   @synchronized(self) {
                       CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
                       self.writeManager.outputAudioFormatDescription = formatDescription;
                   }
               }
               @synchronized(self) {

                   if (self.writeManager.writeState == FMRecordStateRecording) {
                       [self.writeManager appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeAudio];
                   }
               }
               
           }
       }
    
    
    
    
}

@end
