 //
//  RootViewController.m
//  HaoYunVideo
//
//  Created by 范浩云 on 2018/2/26.
//Copyright © 2018年 范浩云. All rights reserved.
//


#import "RootViewController.h"
#import "RootTabBarViewController.h"


@interface RootViewController ()

// 低导
@property (nonatomic, strong) RootTabBarViewController *tabBarVC;

// 当前正在显示的vc  包括nav或者是RootTabBarViewController
@property (nonatomic, strong) id currentVC;

@end


@implementation RootViewController


static RootViewController *sharedInstance = nil;


#pragma mark - ********************** 单利函数 **********************

+ (RootViewController *)sharedInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once (&onceToken, ^ {
        sharedInstance = [[RootViewController alloc] init];
    });
    
    return  sharedInstance;
}


#pragma mark - ********************** View Lifecycle **********************

- (void)dealloc
{
    // 一定要关注这个函数是否被执行了！！！
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor greenColor];
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
    [self initTabBarViewController];
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
    [self showTabBarVC:NO withSuccess:nil];
}

- (void)initTabBarViewController
{
    self.tabBarVC = [[RootTabBarViewController alloc] init];
    [self addChildViewController:self.tabBarVC];
}


#pragma mark - ********************** show **********************

- (void)showTabBarVC:(BOOL)isShowAnimate withSuccess:(void (^)(void))successBlock
{
    if(isShowAnimate && self.currentVC!=nil)
    {
        __weak RootViewController *weakSelf = self;
        [self transitionFromViewController:self.currentVC
                          toViewController:self.tabBarVC
                                  duration:0.5
                                   options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    // 这个地方可以自己自定义动画
                                }
                                completion:^(BOOL finished){
                                    if (finished)
                                    {
                                        weakSelf.currentVC = weakSelf.tabBarVC;
                                        
                                        if(successBlock)
                                        {
                                            successBlock();
                                        }
                                    }
                                }];
    }
    else
    {
        // 将首页导航栏vc显示到self上
        [self.view addSubview:self.tabBarVC.view];
        [self.tabBarVC didMoveToParentViewController:self];
        self.currentVC = self.tabBarVC;
        if(successBlock)
        {
            successBlock();
        }
    }
}

#pragma mark - ********************** remove **********************

- (void)removeTabBarVC
{
    [self.tabBarVC willMoveToParentViewController:nil];
    [self.tabBarVC.view removeFromSuperview];
    [self.tabBarVC removeFromParentViewController];
    self.tabBarVC = nil;
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


@end
