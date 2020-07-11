

//
//  HYSelectView.m
//  HaoYunVideo
//
//  Created by 范浩云 on 2019/9/18.
//Copyright © 2019 范浩云. All rights reserved.
//
#define kViewWidth(v)            v.frame.size.width
#define kViewHeight(v)           v.frame.size.height
#define kViewX(v)                v.frame.origin.x
#define kViewY(v)                v.frame.origin.y
#define kViewMaxX(v)             (v.frame.origin.x + v.frame.size.width)
#define kViewMaxY(v)             (v.frame.origin.y + v.frame.size.height)

#import "HYSelectView.h"


@interface HYSelectView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView   *SCRV;
@property (nonatomic,strong) NSMutableArray *SlideLabArr;
@property (nonatomic,strong) NSMutableArray *showArr;
@property int allcount;
@property int lastCount;

@property BOOL  colorMode;
@property float colorModeR;
@property float colorModeG;
@property float colorModeB;
@property float colorModeSR;
@property float colorModeSG;
@property float colorModeSB;

@end

@implementation HYSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    //--------------------------------------------------默认参数
    self.lableWidth      = 33;
    self.lableMid        = 10;
    self.maxHeight       = 25;
    self.minHeight       = 15;
    self.SecLevelAlpha   = 1;
    self.ThirdLevelAlpha = 1;
    self.LabColor        = [UIColor blackColor];
    
    //--------------------------------------------------相关View初始化
    
    self.SCRV = [[UIScrollView alloc]initWithFrame:CGRectZero];
    self.SCRV.showsHorizontalScrollIndicator = NO;
    self.SCRV.delegate = self;
    [self addSubview:self.SCRV];
    
    self.clipsToBounds = YES;
    self.lastCount     = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(didTap:)];
    [self addGestureRecognizer:tap];
    return self;
}

- (void)show {
    if (self.SlideLabArr.count>0) {
        for (UILabel *lab in self.SlideLabArr) {
            [lab removeFromSuperview];
        }
        [self.SlideLabArr removeAllObjects];
    }
    if (!self.SlideLabArr) {
        self.SlideLabArr = [NSMutableArray array];
    }
    
    self.SCRV.frame = CGRectMake((kViewWidth(self)- self.lableWidth-2*self.lableMid)/2,
                                 (kViewHeight(self)-self.maxHeight)/2,
                                 self.lableWidth+self.lableMid,
                                 self.maxHeight);
    
    if (self.allcount > 0) {
        for (int i=0; i<self.allcount; i++) {
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero];
            lab.font = [UIFont JZBNFontWithName:@"PingFangSC-Regular" size:self.minHeight];
            
            if (i==0) {
                lab.frame = CGRectMake(self.lableMid, 0, self.lableWidth, self.maxHeight);
            } else {
                UILabel *lastLab = self.SlideLabArr[i-1];
                lab.frame = CGRectMake(kViewMaxX(lastLab) + self.lableMid,
                                       self.maxHeight - self.minHeight,
                                       self.lableWidth, self.minHeight);
                lab.font = [UIFont JZBNFontWithName:@"PingFangSC-Regular" size:self.minHeight];
                
            }
            if (i==0) {
                lab.alpha = 1;
            } else if (i==1) {
                lab.alpha = self.SecLevelAlpha;
            } else {
                lab.alpha = self.ThirdLevelAlpha;
            }
            
            lab.adjustsFontSizeToFitWidth = YES;
            if (self.showArr.count > 0) {
                lab.text = (NSString *)self.showArr[i];
            }else{
                lab.text = [NSString stringWithFormat:@"%d",i+1];
            }
            
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor     = self.LabColor;
            
            
            [self.SCRV addSubview:lab];
            [self.SlideLabArr addObject:lab];
        }
        
        UILabel *lastLab = self.SlideLabArr[self.SlideLabArr.count - 1];
        self.SCRV.contentSize = CGSizeMake(kViewMaxX(lastLab) + self.lableMid, 0);
        self.SCRV.pagingEnabled = YES;
        self.SCRV.clipsToBounds = NO;
    }
}

- (void)setLableCount:(int)count
{
    self.allcount = count;
    [self show];
}

- (void)setShowArray:(NSArray *)arr
{
    self.showArr = [NSMutableArray arrayWithArray:arr];
    if (self.showArr.count < self.allcount) {
        for (int i=0; i < self.allcount - self.showArr.count; i++) {
            [self.showArr addObject:@" "];
        }
    }
    
    [self show];
}

- (void)didTap:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self.SCRV];
    CGFloat labDiff = point.x - (self.lableMid / 2);
    int index = labDiff / (self.lableMid + self.lableWidth);
    
    if (self.delegate&& [self.delegate respondsToSelector:@selector(YQSlideViewDidTouchIndex:)]) {
           [self.delegate YQSlideViewDidTouchIndex:index];
    }
 
}

- (void)scrollTo:(int)index {
    if (index >= self.allcount) { return; }
    [self.SCRV setContentOffset:CGPointMake(index * (self.lableMid + self.lableWidth), 0)
                       animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offset = scrollView.contentOffset.x;
    int count  = (offset) / (self.lableMid + self.lableWidth);
    
    UILabel *lastLab = self.SlideLabArr[self.SlideLabArr.count - 1];
    if (offset <= kViewMaxX(lastLab) + 1) {
        if (self.lastCount != count) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(YQSlideViewDidChangeIndex:)])
            {
                [self.delegate YQSlideViewDidChangeIndex:count];
              
            }
            self.lastCount = count;
        }
        
        CGFloat countOffset = offset - count * (self.lableMid + self.lableWidth);
        CGFloat offsetRait  = 1;
        if (countOffset != 0) {
            offsetRait = 1-countOffset / (self.lableWidth + self.lableMid);
        }
        
        
        
        if (count > 0) {
            UILabel *lastLab = self.SlideLabArr[count-1];
            lastLab.frame = CGRectMake(kViewX(lastLab),
                                       (self.maxHeight - self.minHeight),
                                       kViewWidth(lastLab),
                                       self.minHeight);
            lastLab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
            
        }
        
        if (count < self.SlideLabArr.count-1) {
            UILabel *nextLab = self.SlideLabArr[count+1];
            if (nextLab) {
                nextLab.frame = CGRectMake(kViewX(nextLab),
                                           (self.maxHeight-self.minHeight)*offsetRait,
                                           kViewWidth(nextLab),
                                           self.minHeight +
                                           (self.maxHeight - self.minHeight) * (1 - offsetRait));
                nextLab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
            }
        }
        
        
        if (count<self.SlideLabArr.count-2) {
            UILabel *next2Lab = self.SlideLabArr[count+2];
            next2Lab.frame = CGRectMake(kViewX(next2Lab),
                                        (self.maxHeight - self.minHeight),
                                        kViewWidth(next2Lab),
                                        self.minHeight);
            next2Lab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }
        
        UILabel *showingLab = nil;
        if (count >= 0 && count <= self.SlideLabArr.count - 1) {
            showingLab = self.SlideLabArr[count];
        }
        
        if (showingLab) {
            showingLab.frame = CGRectMake(kViewX(showingLab),
                                          (self.maxHeight - self.minHeight) * (1 - offsetRait),
                                          kViewWidth(showingLab),
                                          self.minHeight +
                                          (self.maxHeight - self.minHeight) * offsetRait);
            showingLab.textColor = [UIColor colorWithHexString:@"#FFB423"];
            
        }
        
        
        
        for (int i=0; i < self.SlideLabArr.count; i++) {
            
            if ((i != count) && (i != count + 1) && (i != count - 1) && (i != count + 2)) {
                UILabel *lab = self.SlideLabArr[i];
                lab.frame = CGRectMake(kViewX(lab),
                                       (self.maxHeight - self.minHeight),
                                       kViewWidth(lab),
                                       self.minHeight);
            }
        }
        
    }
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self])
    {
        for (UIView *subview in self.SCRV.subviews)
        {
            CGPoint offset = CGPointMake(point.x - self.SCRV.frame.origin.x +
                                         self.SCRV.contentOffset.x -
                                         subview.frame.origin.x,
                                         
                                         point.y - self.SCRV.frame.origin.y +
                                         self.SCRV.contentOffset.y -
                                         subview.frame.origin.y);
            
            if ((view = [subview hitTest:offset withEvent:event]))
            {
                return view;
            }
        }
        return self.SCRV;
    }
    return view;
}
- (void)next
{
    if (self.lastCount <self.SlideLabArr.count-1) {
        [self.SCRV setContentOffset:CGPointMake(self.SCRV.contentOffset.x+
                                                self.lableWidth + self.lableMid,
                                                self.SCRV.contentOffset.y)
                           animated:YES];
    }
}

- (void)pre
{
    
    if (self.lastCount > 0) {
        [self.SCRV setContentOffset:CGPointMake(self.SCRV.contentOffset.x-
                                                self.lableWidth-self.lableMid,
                                                self.SCRV.contentOffset.y)
                           animated:YES];
    }
}

- (void)DiffrentColorModeWithMainColorR:(float)mr G:(float)mg B:(float)mb
                              SecColorR:(float)sr G:(float)sg B:(float)sb
{
    self.colorMode = YES;
    self.colorModeR = mr;
    self.colorModeG = mg;
    self.colorModeB = mb;
    self.colorModeSR = sr;
    self.colorModeSG = sg;
    self.colorModeSB = sb;
    
}
@end
