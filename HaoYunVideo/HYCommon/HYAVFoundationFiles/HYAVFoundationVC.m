//
//  HYAVFoundationVC.m
//  HaoYunVideo
//
//  Created by fanhaoyun on 2020/7/22.
//  Copyright © 2020 范浩云. All rights reserved.
//

#import "HYAVFoundationVC.h"
#import "HYCodeScanVC.h"
#import "HYFilterCamerVC.h"

@interface HYAVFoundationVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *classArray;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation HYAVFoundationVC



- (void)viewDidLoad {
    self.view.backgroundColor =[UIColor whiteColor];

    [super viewDidLoad];
    [self setupUI];
    [self getData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
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

#pragma mark - UI
- (void)setupUI {
    self.navigationItem.title = @"AVFoundation 音视频";
    self.navigationController.navigationBar.translucent = YES;
    [self.view addSubview:self.tableView];
}

#pragma mark - Data
- (void)getData {
    [self.dataSource addObjectsFromArray:@[
        @"AVFoundation基础概念",
        @"AVFoundation相机拍摄和编辑功能",
        @"AVFoundation 人脸检测",
        @"AVFoundation 实时滤镜拍摄和导出",
        @"GPUImage框架的使用",
        @"VideoToolBox和AudioToolBox音视频编解码",
        @"AVFoundation 利用摄像头实时识别物体颜色",
        @"AVFoundation 原生二维码扫描识别和生成"]];
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
    cell.textLabel.text =  [NSString stringWithFormat:@"%ld、%@",(long)indexPath.row ,self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString * currentSelectName = [self.dataSource objectAtIndex:indexPath.row];
    
    
   
    if ([currentSelectName isEqualToString:@"AVFoundation基础概念"])
    {
        HYFilterCamerVC  * foundationVC = [[HYFilterCamerVC alloc]init];
        [self.navigationController pushViewController:foundationVC animated:YES];
    }
    
   if ([currentSelectName isEqualToString:@"AVFoundation 原生二维码扫描识别和生成"])
      {
          HYCodeScanVC * foundationVC = [[HYCodeScanVC alloc]init];
          [self.navigationController pushViewController:foundationVC animated:YES];
      }
    
    
    
}


@end
