 //
//  HYImageHandleVC.m
//  HaoYunVideo
//
//  Created by 范浩云 on 2019/9/18.
//Copyright © 2019 范浩云. All rights reserved.
//


#import "HYImageHandleVC.h"
#import "OriginImageView.h"


@interface HYImageHandleVC ()

@property(nonatomic,strong) OriginImageView * orginImageView;


@property(nonatomic,strong) UIButton * closeBtn;



@end


@implementation HYImageHandleVC


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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
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
    self.view.backgroundColor = [UIColor whiteColor];
}


#pragma mark - ******************************************* 属性变量的 Set 和 Get 方法 *****************

-(void)closeBtnClick:(UIButton *)aSender
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)setOrginImge:(UIImage *)orginImge
{
    _orginImge = orginImge;
    
    [self.view addSubview:self.orginImageView];
    self.orginImageView.img = _orginImge ;
    
    [self.view addSubview:self.closeBtn];
    self.closeBtn.size = CGSizeMake(40, 40);
    self.closeBtn.top = self.view.top+44;
    self.closeBtn.left = self.view.left+20;
    self.closeBtn.layer.cornerRadius = 20;
    self.closeBtn.layer.masksToBounds = YES;
}

-(OriginImageView *)orginImageView
{
    if (!_orginImageView) {
        _orginImageView =  [[OriginImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,self.view.height-66)];
    }
    return _orginImageView;
}

-(UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.backgroundColor = [UIColor blackColor];
        [_closeBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}




@end
