//
//  JZBCodeScanVC.m
//  HomeWork_Patriarch
//
//  Created by fanhaoyun on 2020/7/21.
//  Copyright © 2020 作业帮口算. All rights reserved.
//

#import "HYCodeScanVC.h"
#import <AVFoundation/AVFoundation.h>


static const char *kScanQRCodeQueueName = "ScanQRCodeQueue";

@interface HYCodeScanVC ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic)  UIView *sanFrameView;
@property (strong, nonatomic)  UIButton *startButton;
@property (strong, nonatomic)  UIButton *lightButton;
@property (strong, nonatomic)  UITextView *linkLable;
@property (strong, nonatomic)  UIButton *openLink;



@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL lastResut;
@property (nonatomic) dispatch_queue_t sessionQueue;





@end

@implementation HYCodeScanVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.sanFrameView];
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.lightButton];
    [self.view addSubview:self.linkLable];
    [self.view addSubview:self.openLink];


    self.sanFrameView.xCenter = self.view.xCenter;
    self.sanFrameView.yCenter = self.view.yCenter-100;

    self.startButton.top = self.sanFrameView.bottom +10;
    self.startButton.left = self.sanFrameView.left;


    self.lightButton.top = self.sanFrameView.bottom +10;
    self.lightButton.right = self.sanFrameView.right;

    self.linkLable.top = self.lightButton.bottom+10;
    self.linkLable.xCenter = self.view.xCenter;



    self.openLink.top = self.linkLable.bottom+10;
    self.openLink.xCenter = self.view.xCenter;

    _lastResut = YES;
    [self createQueue];
    [self startReading];
}





-(UITextView *)linkLable
{
    if (!_linkLable) {
        _linkLable = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, MPT_ScreenW-20, 70)];
        _linkLable.backgroundColor = [UIColor whiteColor];
        _linkLable.textColor = [UIColor grayColor];
        _linkLable.layer.cornerRadius  = 20;
        _linkLable.layer.masksToBounds = YES;
    }
    return _linkLable;
}

-(UIButton *)openLink
{
    if (!_openLink) {
        _openLink = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,100, 40)];
        [_openLink setTitle:@"端内打开" forState:UIControlStateNormal];
        _openLink.backgroundColor = [UIColor blueColor];
        [_openLink addTarget:self action:@selector(openLinkBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openLink;
}



-(UIButton *)lightButton
{
    if (!_lightButton) {
        _lightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,100, 40)];
        [_lightButton setTitle:@"打开照明" forState:UIControlStateNormal];
        _lightButton.backgroundColor = [UIColor blueColor];
        [_lightButton addTarget:self action:@selector(openSystemLight:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lightButton;
}


-(UIButton *)startButton
{
    if (!_startButton) {
        _startButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,100, 40)];
        [_startButton setTitle:@"重新扫描" forState:UIControlStateNormal];
        _startButton.backgroundColor = [UIColor blueColor];
        [_startButton addTarget:self action:@selector(startScanner:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}


-(UIView *)sanFrameView
{
    if (!_sanFrameView) {
        _sanFrameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,250, 250)];
        _sanFrameView.backgroundColor = [UIColor blackColor];
    }
    return _sanFrameView;
}



- (BOOL)startReading
{
    [_startButton setTitle:@"停止" forState:UIControlStateNormal];
    NSError * error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];

    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create(kScanQRCodeQueueName, NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_sanFrameView.layer.bounds];
    [_sanFrameView.layer addSublayer:_videoPreviewLayer];
    
    
    __weak typeof(self)weakSelf = self;
     dispatch_async(self.sessionQueue, ^{
         if (!weakSelf.captureSession.running) {
             [weakSelf.captureSession startRunning];
         }
     });
    
  
    
    return YES;
}


- (void)createQueue
{
    dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    self.sessionQueue = sessionQueue;
}

- (void)stopReading
{
    [_startButton setTitle:@"重新扫描" forState:UIControlStateNormal];
    [self.captureSession stopRunning];
     self.captureSession = nil;
}

- (void)reportScanResult:(NSString *)result
{
    [self stopReading];
    if (!_lastResut) {
        return;
    }
    _lastResut = NO;
    
//     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
    self.linkLable.text = result;
    _lastResut = YES;
}

- (void)systemLightSwitch:(BOOL)open
{
    if (open) {
        [_lightButton setTitle:@"关闭照明" forState:UIControlStateNormal];
    } else {
        [_lightButton setTitle:@"打开照明" forState:UIControlStateNormal];
    }
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (open) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }
}

#pragma AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            result = metadataObj.stringValue;
        } else {
            NSLog(@"不是二维码");
        }
        [self performSelectorOnMainThread:@selector(reportScanResult:) withObject:result waitUntilDone:NO];
    }
}
- (void)startScanner:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"重新扫描"]) {
        [self startReading];
    } else {
        [self stopReading];
    }
}

- (void)openSystemLight:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"打开照明"]) {
        [self systemLightSwitch:YES];
    } else {
        [self systemLightSwitch:NO];
    }
}

-(void)openLinkBtn:(UIButton *)alinkBtn
{
//    WebViewController *vc = [[WebViewController alloc] initWithUrl:self.linkLable.text];
//    [self.navigationController pushViewController:vc animated:NO];
    
    
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.linkLable.text]];

}


- (void)dealloc
{
    [self stopReading];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
