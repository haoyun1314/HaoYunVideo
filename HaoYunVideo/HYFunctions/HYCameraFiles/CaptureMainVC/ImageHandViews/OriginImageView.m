//
//  OriginImageView.m
//  HaoYunVideo
//
//  Created by fanhaoyun on 2020/5/19.
//  Copyright © 2020 范浩云. All rights reserved.
//

#import "OriginImageView.h"
#import "ScaleView.h"
#import "HYPasterView.h"

/**底部的scrollView的高*/
const CGFloat pasterScrollView_H = 120;
/**空白的距离间隔*/
extern CGFloat inset_space;
/**默认的图片上的贴纸大小*/
static const CGFloat defaultPasterViewW_H = 134;
/**底部按钮的高度*/
static CGFloat bottomButtonH = 44;

@interface OriginImageView()

@property (nonatomic, strong) ScaleView *scrollView;


@property (nonatomic, strong) UIImageView * handeImgView;

@end

@implementation OriginImageView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}


-(void)initSubViews
{
    [self addSubview:self.scrollView];
}


-(void)setImg:(UIImage *)img
{
    _img = img;
    _orgintImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _orgintImgV.contentMode = UIViewContentModeScaleAspectFit;
    _orgintImgV.userInteractionEnabled = YES;
    self.orgintImgV.image = img;
    [self.scrollView setZoomView:self.orgintImgV];
    [self.scrollView addSubview:self.orgintImgV];
    
    /*
     ====
    self.handeImgView = [[UIImageView alloc] initWithFrame:_orgintImgV.bounds];
    _handeImgView.contentMode = UIViewContentModeScaleAspectFit;
    _handeImgView.userInteractionEnabled = YES;
    _handeImgView.backgroundColor = [UIColor clearColor];
    [self.orgintImgV addSubview:self.handeImgView];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandleImg:)];
    [_handeImgView addGestureRecognizer:tapGesture];
    */
    
    
    
}



-(void)tapHandleImg:(UITapGestureRecognizer *)tapGesture
{
    NSLog(@"帅");
    CGPoint initPoint= [tapGesture locationInView:self.handeImgView];
    HYPasterView *pasterView = [[HYPasterView alloc]initWithFrame:CGRectMake(0, 0, defaultPasterViewW_H, defaultPasterViewW_H)];
    pasterView.isEditor = YES;
//    -(void)scale_clearBtnShow:(BOOL)isShow
    [pasterView scale_clearBtnShow:YES];

    __weak typeof(self) weakSelf = self;
    pasterView.isRight = YES;
    pasterView.isBord = YES;
    if (YES)
    {
        pasterView.pasterImage = [UIImage imageNamed:@"JZB_Small_Right"];
    }
    else
    {
        pasterView.pasterImage = [UIImage imageNamed:@"JZB_Wong_View_Icon"];
    }
    
    pasterView.center =initPoint;
    [self.handeImgView addSubview:pasterView];
    [pasterView checkIsOut];
    pasterView.dragViewBlock = ^(UIView *dragView) {
        
    };
    
    
}






- (ScaleView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[ScaleView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior  = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        //设置缩放的最大最小值
        [_scrollView setMaximumZoomScale:4.0];
        [_scrollView setMinimumZoomScale:1.0];
    }
    return _scrollView;
}




@end
