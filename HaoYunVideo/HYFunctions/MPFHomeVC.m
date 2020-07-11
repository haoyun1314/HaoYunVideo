
//
//  MPFHomeVC.m
//  HaoYunVideo
//
//  Created by 范浩云 on 2019/12/8.
//Copyright © 2019 范浩云. All rights reserved.
//


#import "MPFHomeVC.h"
#import "OpenGLView.h"
#import "OpenGLSimpleRender.h"


@interface MPFHomeVC ()

@property (nonatomic, strong) OpenGLView *glView;

@property (nonatomic, strong) UISlider *slider;



@end


@implementation MPFHomeVC


#pragma mark - ********************** View Lifecycle **********************

- (void)dealloc
{
    // 一定要关注这个函数是否被执行了！！！
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化变量
    [self initVariable];
    
    // 初始化界面
    [self initViews];
    
    // 注册消息
    [self regNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - ********************** init and config **********************

/**
 TODO: 初始化变量，例如：分页的page可以在该函数中赋初值
 */
- (void)initVariable
{
    
}

- (void)initViews
{
    // 初始化Nav导航栏
    [self initNavView];
    
    // 创建相关子view
    [self initMainViews];
}

/**
 TODO: 初始化Nav导航栏
 */
- (void)initNavView
{
    
}

/**
 TODO: 创建相关子view
 */
- (void)initMainViews
{
    self.glView = [[OpenGLView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.glView];
    [self createSlider];
}




-(void)sliderValueDidChanged:(UISlider*)aSlider
{
    NSLog(@"%f",aSlider.value);
    OpenGLSimpleRender *simpleRender = [self.glView valueForKey:@"render"];
    [simpleRender setEffectPercent:aSlider.value];
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
 */
- (void)btnClickBack:(UIButton *)aSender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - ******************************************* 私有方法 **********************************


#pragma mark - ******************************************* Net Connection Event ********************

#pragma mark - 请求 demo

- (void)req_url_demo
{
    
}


#pragma mark - ******************************************* Delegate Event **************************

#pragma mark - 代理 demo

- (void)delegate_demo
{
    
}


#pragma mark - ******************************************* Notification Event **********************

#pragma mark - 通知 demo

- (void)notification_demo:(NSNotification *)aNotification
{
    
}


#pragma mark - ******************************************* 属性变量的 Set 和 Get 方法 *****************



//TODO:创建Slider
-(void)createSlider
{  /// 创建Slider 设置Frame
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 247) * .5f,64+10, 247, 50)];
    slider.backgroundColor = [UIColor yellowColor];
    [slider setContinuous:YES];
    [slider addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    // 滑块条最小值处设置的图片，默认为nil
//     slider.minimumValueImage = minimumValueImage;
     // 滑块条最大值处设置的图片，默认为nil
//     slider.maximumValueImage = maximumValueImage;
     // minimumTrackTintColor : 小于滑块当前值滑块条的颜色，默认为蓝色
     slider.minimumTrackTintColor = [UIColor redColor];
     // maximumTrackTintColor: 大于滑块当前值滑块条的颜色，默认为白色
     slider.maximumTrackTintColor = [UIColor blueColor];
     // thumbTintColor : 当前滑块的颜色，默认为白色
     slider.thumbTintColor = [UIColor yellowColor];
     // minimumTrackTintColor : 小于滑块当前值滑块条的颜色，默认为蓝色
     slider.minimumTrackTintColor = [UIColor redColor];
     // maximumTrackTintColor: 大于滑块当前值滑块条的颜色，默认为白色
     slider.maximumTrackTintColor = [UIColor blueColor];
     // thumbTintColor : 当前滑块的颜色，默认为白色
     slider.thumbTintColor = [UIColor yellowColor];
    self.slider = slider;
    /// 添加Slider
    [self.view addSubview:slider];
}

@end
