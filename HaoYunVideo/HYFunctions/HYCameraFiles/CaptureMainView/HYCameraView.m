 //
//  HYCameraView.m
//  HaoYunVideo
//
//  Created by 范浩云 on 2019/9/17.
//Copyright © 2019 范浩云. All rights reserved.
//


#import "HYCameraView.h"
#import "HYCaptureManager.h"
#import "JZBAccessPermissionManger.h"
#import "HYSelectView.h"


@interface HYCameraView ()

@property (nonatomic) HYCaptureManager *captureManager;



@end


@implementation HYCameraView


#pragma mark - ********************** View Lifecycle **********************

- (void)dealloc
{
    // 一定要关注这个函数是否被执行了！！！
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // 注册消息
        [self regNotification];
        
        // 初始化变量
        [self initVariable];
        
        // 创建相关子view
        [self initMainViews];
    }
    
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if(newSuperview == nil)
    {
        // 这块需要注意一下，当前view如果在其他地方被移除了的话，要小心下面这行代码！
        [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        return ;
    }
}


#pragma mark - ********************** init and config **********************

/**
 TODO: 初始化变量，例如：分页的page可以在该函数中赋初值
 */
- (void)initVariable
{
    
}

/**
 TODO: 创建相关子view
 */
- (void)initMainViews
{
    [JZBAccessPermissionManger authorizeCameraWithCompletion:^(BOOL granted, BOOL firstTime)
     {
        if (granted)
        {
            HYCaptureManager *manager = [[HYCaptureManager alloc] init];
            self.captureManager = manager;
            self.captureManager.captureType = CaptureManagerTypeSummerHomework;
            [self.captureManager configureWithParentLayer:self previewRect:CGRectMake(0, 0,MPT_ScreenW, MPT_ScreenH) withVideoOrientation:AVCaptureVideoOrientationPortrait isFrontCamera:NO detectEnvBrightness:^(CGFloat brightness)
            {
                NSLog(@"brightness = %f",brightness);
            }];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 [self.captureManager.session startRunning];
            });
        }
     }];
    

    
    
    [self addSubview:self.takePhoto];
    self.takePhoto.bottom = self.bottom-44;
    [self.takePhoto addTarget:self action:@selector(takePhotoClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}



-(void)takePhotoClick:(UIButton *)aSender
{
    if (self.selectType == Campture_Handle_Type_Editor)
    {
        __weak typeof(self) weakSelf = self;
         [self.captureManager takePicture:^(UIImage *stillImage)
          {
              NSLog(@"stillImage = %@",stillImage);
              if (weakSelf.pushPageBlock) {
                  weakSelf.pushPageBlock(self.selectType, stillImage);
              }
          }];
    }
    else if (self.selectType ==Campture_Handle_Type_Vidieo)
    {
        if (aSender.selected ==NO)
        {
            aSender.selected = YES;
        }
        else
        {
            aSender.selected = NO;
        }
        
        NSLog(@"aSender.isSelected = %d",aSender.isSelected);
        
        if (aSender.isSelected == YES)
        {
            [self.captureManager startRecord];
        }
        else
        {
            [self.captureManager stopRecord];
            if (self.pushPageBlock) {
                self.pushPageBlock(self.selectType,self.captureManager.videoUrl);
            }
        }
        
    }
    
    
    
 
}




/**
 TODO: 注册通知
 */
- (void)regNotification
{

}


#pragma mark - ******************************************* 对外方法 **********************************


#pragma mark - ******************************************* 基类方法(一般发生在重写函数) ****************


#pragma mark - ******************************************* Touch Event ***********************

/**
 TODO: 返回按钮点击事件的响应函数
 
 @param sender 被点击的按钮
 */
- (void)btnClickBack:(UIButton *)aSender
{
    
}


#pragma mark - ******************************************* 私有方法 **********************************


#pragma mark - ******************************************* Net Connection Event ********************

#pragma mark - 请求 demo

- (void)req_url_demo
{
    
}


#pragma mark - ******************************************* Delegate Event **************************




#pragma mark - ******************************************* Notification Event **********************

#pragma mark - 通知 demo

- (void)notification_demo:(NSNotification *)aNotification
{
    
}


#pragma mark - ******************************************* 属性变量的 Set 和 Get 方法 *****************

- (UIButton *)takePhoto {
    if (!_takePhoto) {
        _takePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnWH = 65;
        [_takePhoto setFrame:CGRectMake((MPT_ScreenW - btnWH)/2,0, btnWH, btnWH)];
        UIImage * imgIcon = [UIImage imageNamed:@"JZBN_Camera"];
        UIImage * highLihtIcon = [UIImage imageNamed:@"JZBN_Camera"];
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
        UIImage * btnIcon = [imgIcon resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        [_takePhoto setBackgroundImage:btnIcon forState:UIControlStateNormal];
        [_takePhoto setBackgroundImage:highLihtIcon forState:UIControlStateHighlighted];
    }
    return _takePhoto;
}


@end
