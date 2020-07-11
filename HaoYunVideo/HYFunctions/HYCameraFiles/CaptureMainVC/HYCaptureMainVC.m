 //
//  HYCaptureMainVC.m
//  HaoYunVideo
//
//  Created by 范浩云 on 2018/3/1.
//Copyright © 2018年 范浩云. All rights reserved.
//


#import "HYCaptureMainVC.h"
#import "QAIMNavigaionView.h"
#import "HYCameraView.h"
#import "HYImageHandleVC.h"
#import "TZImagePickerController.h"
#import "HYVideoHandleVC.h"
#import "HYSelectView.h"

@interface HYCaptureMainVC ()<TZImagePickerControllerDelegate,HYSelectViewDelegate>

@property(nonatomic,strong) HYCameraView * cameraView;


@property (nonatomic,strong) UIButton * photoBtn;

@property (nonatomic,strong) TZImagePickerController * tzImagePickerVC;

@property(nonatomic,strong) HYSelectView * hySelectView;

@property(nonatomic,assign) Campture_Handle_Type selectType;

@end


@implementation HYCaptureMainVC


#pragma mark - ********************** View Lifecycle **********************

- (void)dealloc
{
    // 一定要关注这个函数是否被执行了！！！
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    // 初始化变量
    [self initVariable];
    
    // 初始化界面
    [self initViews];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];

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
    
    HYCameraView * cameraView = [[HYCameraView alloc]initWithFrame:self.view.bounds];
    self.cameraView = cameraView;
    [self.view addSubview:cameraView];    
    __weak typeof(self) weakSelf = self;
    cameraView.pushPageBlock = ^(Campture_Handle_Type type, id object) {
        switch (type) {
            case Campture_Handle_Type_Editor:
            {
                UIImage * imgObj = (UIImage *)object;
                HYImageHandleVC * handleVc = [[HYImageHandleVC alloc] init];
                handleVc.orginImge = imgObj;
                handleVc.modalPresentationStyle =UIModalPresentationFullScreen;
                [weakSelf.navigationController pushViewController:handleVc animated:YES];
                NSLog(@"imgObj = %@",imgObj);
            }
                break;
            case Campture_Handle_Type_Vidieo:
            {
                HYVideoHandleVC * handelVC = [[HYVideoHandleVC alloc]init];
                handelVC.videoUrl = (NSString  *)object;
                [weakSelf.navigationController pushViewController:handelVC animated:YES];

            }
                break;
  
            default:
                break;
        }
    };
    
    
    QAIMNavigaionView * naView = [[QAIMNavigaionView alloc]initWithFrame:CGRectMake(0, 0, MPT_ScreenW, 64)];
    [self.view addSubview:naView];
    naView.contentView.backgroundColor = [UIColor clearColor];
    naView.headLine.alpha = 0;
    [naView setBlockBtnClick:^(UIButton *btn, QAE_ClickType type) {
        switch (type) {
            case QAE_BackBtnClick:
            {
                [weakSelf backBtn:btn];
            }
                break;
            case QAE_RightBtnClick:
            {
                
            }
                break;
            default:
                break;
        }
    }];
    
    [self.view addSubview:self.photoBtn];
    self.photoBtn.size = CGSizeMake(50, 50);
    self.photoBtn.bottom = self.view.bottom-50;
    self.photoBtn.left = self.view.left +20;
    self.photoBtn.layer.cornerRadius = 25;
    self.photoBtn.layer.masksToBounds = YES;
    
    
    self.hySelectView = [[HYSelectView alloc]initWithFrame:CGRectMake(0,0,MPT_ScreenW, 44)];
    self.hySelectView.delegate = self;
    [self.view addSubview:_hySelectView];
    _hySelectView.LabColor =[UIColor colorWithHexString:@"#FFFFFF"];
    [_hySelectView setLableCount:3];
    [_hySelectView setShowArray:@[@"图片处理",@"图片处理",@"视频处理"]];
    _hySelectView.lableWidth = 56;
    _hySelectView.lableMid = 25;
    _hySelectView.maxHeight = 14;
    //显示
    [_hySelectView show];
    _hySelectView.bottom = self.view.bottom;
    
    
    

    
}


- (void)YQSlideViewDidChangeIndex:(int)count
{
    switch (count) {
        case 0:
            self.selectType = Campture_Handle_Type_Filter;
            break;
        case 1:
            self.selectType = Campture_Handle_Type_Editor;
            
            break;
        case 2:
            self.selectType = Campture_Handle_Type_Vidieo;
            break;
            
        default:
            break;
    }
    self.cameraView.selectType  =  self.selectType;    
    
}

- (void)YQSlideViewDidTouchIndex:(int)count
{
    
    [self.hySelectView scrollTo:count];
    
}


-(void)backBtn:(UIButton *)aSender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)photoClick:(UIButton *)aSender
{
    
        self.tzImagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        self.tzImagePickerVC.navigationBar.translucent = NO;
        self.tzImagePickerVC.naviBgColor = [UIColor whiteColor];
        self.tzImagePickerVC.naviTitleColor = [UIColor blackColor];
        self.tzImagePickerVC.barItemTextColor = [UIColor blackColor];
        self.tzImagePickerVC.statusBarStyle = UIStatusBarStyleDefault;
        self.tzImagePickerVC.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
        self.tzImagePickerVC.oKButtonTitleColorNormal = [UIColor whiteColor];
        self.tzImagePickerVC.showPhotoCannotSelectLayer = YES;
        self.tzImagePickerVC.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        
        self.tzImagePickerVC.allowPickingOriginalPhoto = NO;
        self.tzImagePickerVC.allowPickingVideo = NO;
        self.tzImagePickerVC.allowPickingImage = YES;
        self.tzImagePickerVC.allowPickingGif = NO;
        self.tzImagePickerVC.allowPickingMultipleVideo = NO; //
        self.tzImagePickerVC.allowPreview = NO;
        __weak typeof(self) weakSelf = self;

        
        [self.tzImagePickerVC setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        }];
        
        // 自定义导航栏上的返回按钮
        [self.tzImagePickerVC setNavLeftBarButtonSettingBlock:^(UIButton *leftButton)
         {
            leftButton.hidden = YES;
        }];
        
//        __weak typeof(self) weakSelf = self;
        [self.tzImagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto)
         {
            [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIImage * objImage = (UIImage *)obj;
                HYImageHandleVC * handleVc = [[HYImageHandleVC alloc] init];
                handleVc.orginImge = objImage;
                handleVc.modalPresentationStyle =UIModalPresentationFullScreen;
                [weakSelf.navigationController pushViewController:handleVc animated:YES];
            }];
        }];
        self.tzImagePickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:self.tzImagePickerVC animated:YES completion:nil];
        
}



-(void)getPhotoBlock:(void(^)(UIImage *))getImage
{
   
}




-(UIButton *)photoBtn
{
    if (!_photoBtn)
    {
        _photoBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoBtn setTitle:@"相册" forState:UIControlStateNormal];
        _photoBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_photoBtn  addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoBtn;
}

@end
