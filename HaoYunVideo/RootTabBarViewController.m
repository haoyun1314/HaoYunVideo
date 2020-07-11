 //
//  RootTabBarViewController.m
//  HaoYunVideo
//
//  Created by 范浩云 on 2018/2/26.
//Copyright © 2018年 范浩云. All rights reserved.
//


#import "RootTabBarViewController.h"
#import "TPCTabBarController.h"
#import "TPCTabBarItem.h"
#import "MPFIMChatListMainVC.h"
#import "MPFNearVC.h"
#import "MPFProfileVC.h"
#import "MPFLikeVC.h"
#import "MPFSearchVC.h"
#import "MPFHomeVC.h"
#import "MPFCaptureVC.h"
#import "HYCaptureMainVC.h"

@interface RootTabBarViewController ()
<
TPCTabBarControllerDelegate,
UIScrollViewDelegate
>
{
    MPBNavigationController *navImTemp;
    MPBNavigationController *navNearTemp;
}

//
@property (nonatomic, strong) TPCTabBarController *tcpTabBarVC;

///  左右滑动
@property (nonatomic, strong) MPCScrollView *scorV;

//
@property (nonatomic, strong) MPFIMChatListMainVC *imMainVC;


@property (strong,nonatomic) MPFNearVC* nearMainVC;




@end


@implementation RootTabBarViewController


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
     // tabbar
        __weak typeof(self) weakSelf = self;
        self.tcpTabBarVC = [[TPCTabBarController alloc] init];
        self.tcpTabBarVC.selectIndexBlock = ^MPBNavigationController *(NSInteger index) {
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            _tabbarCurrentIndex = index;
            if (index == 2)
            {
                MPBNavigationController *navCapture = [[MPBNavigationController alloc] initWithRootViewController:[[HYCaptureMainVC alloc] init]];
                navCapture.modalPresentationStyle = UIModalPresentationFullScreen;
    //            navCapture.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [strongSelf.tcpTabBarVC presentViewController:navCapture animated:YES completion:nil];
                
                return navCapture;
            }
            else
            {
                return nil;
            }
        };
        
        /// 首页
        MPBNavigationController *navHome = [[MPBNavigationController alloc] initWithRootViewController:[[MPFHomeVC alloc] init]];
    
        /// 搜索
        MPBNavigationController *navSearch = [[MPBNavigationController alloc] initWithRootViewController:[[MPFSearchVC alloc] init]];
        /// 拍摄
        MPBNavigationController *navCapture = [[MPBNavigationController alloc] initWithRootViewController:[[MPBViewController alloc] init]];

        /// 喜欢
        MPBNavigationController *navLike = [[MPBNavigationController alloc] initWithRootViewController:[[MPFLikeVC alloc] init]];
        /// 我的
        MPBNavigationController *navMe = [[MPBNavigationController alloc] initWithRootViewController:[[MPFProfileVC alloc] initWithTabbarChildVC:YES]];
        /// IM
        self.imMainVC = [[MPFIMChatListMainVC alloc] init];
        MPBNavigationController *navIm = [[MPBNavigationController alloc] initWithRootViewController:self.imMainVC];
        navImTemp = navIm;
        /// 附近的人
        self.nearMainVC = [[MPFNearVC alloc] init];
        navNearTemp = [[MPBNavigationController alloc] initWithRootViewController:self.nearMainVC];

        [self.tcpTabBarVC setViewControllers:@[navHome,navSearch,navCapture,navLike,navMe]];
        self.tcpTabBarVC.delegate = self;
        
        [self customizeTabBarForController];
        
        [self addChildViewController:self.tcpTabBarVC];
//        [self addChildViewController:navNearTemp];
//        [self addChildViewController:navIm];
        
    [self.view addSubview:self.tcpTabBarVC .view];
        
//        navNearTemp.view.frame  = CGRectMake(0, navNearTemp.view.y, navNearTemp.view.width, navNearTemp.view.height);
//        [_scorV addSubview:navNearTemp.view];
        
//        self.tcpTabBarVC.view.x = MPT_ScreenW;
//        [_scorV addSubview:self.tcpTabBarVC.view];
        [self.tcpTabBarVC didMoveToParentViewController:self];

//        navIm.view.frame  = CGRectMake( 2 * MPT_ScreenW, navIm.view.y, navIm.view.width, navIm.view.height);
//        navIm.navFrameX = 2 * MPT_ScreenW;
//        [_scorV addSubview:navIm.view];
//        [_scorV setContentOffset:CGPointMake(MPT_ScreenW, 0)];
        
}


- (void)customizeTabBarForController
{
    UIImage *finishedImage = [UIImage imageNamed:@"tabbarHomeN"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbarHomeN"];
    NSArray *tabBarItemImages = @[@"tabbarHome",
                                  @"tabbarSearch",
                                  @"tabbarCapter",
                                  @"tabbarLike",
                                  @"tabbarOwer"];
    
    NSInteger index = 0;
    for (TPCTabBarItem *item in [[self.tcpTabBarVC tabBar] items])
    {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_S",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_N",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
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
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - ******************************************* 私有方法 **********************************


#pragma mark - ******************************************* Net Connection Event ********************

#pragma mark - 请求 demo

- (void)req_url_demo
{
    
}


#pragma mark - ******************************************* Delegate Event **************************


#pragma mark - ******************************************* Delegate Event **************************

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    MPTLog(@"滚动scllor %@",NSStringFromCGSize(scrollView.contentSize));
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  
        [self.scorV setContentOffset:CGPointMake(MPT_ScreenW, 0) animated:NO];
    
    // 附近
    if (_scorV.contentOffset.x == 0)
    {
    }
    // 首页
    if (_scorV.contentOffset.x == 1 * MPT_ScreenW)
    {
    }
    // IM
    if (_scorV.contentOffset.x == 2 * MPT_ScreenW)
    {
    }
}
#pragma mark - 代理 TPCTabBarController Delegate

- (BOOL)tabBarController:(TPCTabBarController *)tabBarController shouldSelectViewController:(UINavigationController *)viewController index:(NSInteger)index
{
//    // 首页 B版可以进入 免登陆
//    if ((([MPFGlobalSettingManager homeABStyle] != MPFABTestStyleB && index == 0) || index == 3 || index == 4) && ![MPSAppSingleton shareInstance].isLogin)
//    {
//        // 用户未登录
//        [MPFLoginViewController loginWithCompletion:nil];
//        return NO;
//    }
//
    if ([self getCurrentSelectIndex] == 0 && index == 0) {
        // 首页再次点击刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyHomeVCToRefresh" object:nil];
    }
    
    if ([self getCurrentSelectIndex] == 1 && index == 1) {
        // 发现页再次点击回到顶部
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyDiscoveryVCToTop" object:nil];
    }
    
    if (index == 3)
    {
    }
    
    return YES;
}
- (NSUInteger)getCurrentSelectIndex
{
    return self.tcpTabBarVC.selectedIndex;
}

- (void)tabBarController:(TPCTabBarController *)tabBarController didSelectViewController:(UINavigationController *)viewController
{
   
}



#pragma mark - ******************************************* Notification Event **********************

#pragma mark - 通知 demo

- (void)notification_demo:(NSNotification *)aNotification
{
    
}


#pragma mark - ******************************************* 属性变量的 Set 和 Get 方法 *****************

- (UIScrollView *)scorV
{
    if(!_scorV)
    {
        _scorV = [[MPCScrollView alloc] initWithFrame:CGRectMake(0, 0, MPT_ScreenW, MPT_ScreenH)];
        _scorV.delegate = self;
        _scorV.contentSize = CGSizeMake( MPT_ScreenW * 3, MPT_ScreenH);
        _scorV.backgroundColor = [UIColor whiteColor];
        _scorV.pagingEnabled = YES;
        _scorV.showsVerticalScrollIndicator = NO;
        _scorV.showsHorizontalScrollIndicator = NO;
        _scorV.bounces = NO;
        _scorV.scrollEnabled = NO;
    }
    
    return _scorV;
}
@end
