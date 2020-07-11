//
//  ScaleView.m
//  HaoYunVideo
//
//  Created by fanhaoyun on 2020/5/19.
//  Copyright © 2020 范浩云. All rights reserved.
//

#import "ScaleView.h"

@interface ScaleView()
@end


@implementation ScaleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _zoomView;
}

- (void)setFrameWithViewForZooming:(UIView *)view inScrollView:(UIScrollView *)scrollView
{
    @autoreleasepool {
        
        CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentInset.left - scrollView.contentInset.right - scrollView.contentSize.width) * 0.5, 0.0);
        CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom - scrollView.contentSize.height) * 0.5, 0.0);
        self.zoomView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                           scrollView.contentSize.height * 0.5 + offsetY);
        
    }
}




// 放大或缩小时图片位置(frame)调整,保证居中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    @autoreleasepool {
        
        CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentInset.left - scrollView.contentInset.right - scrollView.contentSize.width) * 0.5, 0.0);
        CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom - scrollView.contentSize.height) * 0.5, 0.0);
        self.zoomView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                           scrollView.contentSize.height * 0.5 + offsetY);
        
    }
}




- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
{
    [self setFrameWithViewForZooming:view inScrollView:scrollView];
}


@end
