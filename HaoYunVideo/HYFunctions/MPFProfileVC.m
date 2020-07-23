  //
 //  MPFProfileVC.m
 //  HaoYunVideo
 //
 //  Created by 范浩云 on 2019/12/8.
 //Copyright © 2019 范浩云. All rights reserved.
 //


 #import "MPFProfileVC.h"
 #import "HYBottomShowSelectView.h"
#import "HYAVFoundationVC.h"


 @interface MPFProfileVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *classArray;
@property (strong, nonatomic) UITableView *tableView;


 @end


 @implementation MPFProfileVC


 #pragma mark - ********************** View Lifecycle **********************

 - (void)dealloc
 {
     // 一定要关注这个函数是否被执行了！！！
     
     [[NSNotificationCenter defaultCenter] removeObserver:self];
 }


 - (instancetype)initWithTabbarChildVC:(BOOL)isTabbarChildVC
 {
     if (self = [super init]) {
         
         self.isMainVC = YES;
        
     }
     
     return self;
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



#pragma mark---开始

 - (void)viewDidLoad
 {
     [super viewDidLoad];
   
     [self setupUI];
      [self getdata];
 }


#pragma mark - UI
- (void)setupUI {
    self.navigationItem.title = @"iOS基础集合";
    self.navigationController.navigationBar.translucent = YES;
    [self.view addSubview:self.tableView];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MPT_ScreenW, MPT_ScreenH) style:UITableViewStylePlain];
        _tableView.estimatedRowHeight = 1;
        _tableView.delegate =self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    }
    return _tableView;
}

#pragma mark--data

-(void)getdata
{
        //tableView、UIAlertView等系统控件，在不自定义颜色的情况下，默认颜色都是动态的，支持暗黑模式
        [self.dataSource addObjectsFromArray:@[@"暗黑/光亮模式",
                                               @"AppleId三方登录应用",
                                               @"AVFoundation",
                                               @"OpenGL-ES学习",
                                               @"LeetCode算法练习集合",
                                               @"工作中踩过的坑",
                                               @"iOS Crash防护",
                                               @"WKWebView相关",@"年级选择弹框"]];
//        [self.classArray addObjectsFromArray:@[[SLDarkModeViewController class],
//                                               [UIViewController class],
//                                               [SLAVListViewController class],
//                                               [SLOpenGLController class],
//                                               [UIViewController class],
//                                               [SLWorkIssuesViewController class],
//                                               [SLCrashViewController class],
//                                               [SLWebViewListController class]]];
        [self.tableView reloadData];
}

#pragma mark - Getter
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)classArray {
    if (_classArray == nil) {
        _classArray = [NSMutableArray array];
    }
    return _classArray;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text =  [NSString stringWithFormat:@"%ld、%@",(long)indexPath.row + 1,self.dataSource[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString * currentSelectName = [self.dataSource objectAtIndex:indexPath.row];
    if ([currentSelectName isEqualToString:@"年级选择弹框"])
    {
         [self showBottomView];
    }
    
    if ([currentSelectName isEqualToString:@"AVFoundation"])
     {
         HYAVFoundationVC * foundationVC = [[HYAVFoundationVC alloc]init];
         [self.navigationController pushViewController:foundationVC animated:YES];
     }

}



 -(void)showBottomView
 {
     HYBottomShowSelectView * showBtttomView = [[HYBottomShowSelectView alloc]initWithFrame:CGRectMake(0, 0, MPT_ScreenW,MPT_ScreenH)];
     
     [showBtttomView gradeViewShowWindowToParent:[UIApplication sharedApplication].keyWindow showBlock:^{
         
     } disMissBlock:^(NSDictionary *paraDic) {
         
     } sureBlock:^(NSDictionary *paraDic) {
         
     }];
     
 }





 @end
