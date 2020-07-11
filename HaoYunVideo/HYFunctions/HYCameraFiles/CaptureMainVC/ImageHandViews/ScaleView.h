//
//  ScaleView.h
//  HaoYunVideo
//
//  Created by fanhaoyun on 2020/5/19.
//  Copyright © 2020 范浩云. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ScaleView :  UIScrollView<UIScrollViewDelegate>

@property(nonatomic,strong) UIView *zoomView;

@property(nonatomic,assign) BOOL disableCenterImageView;

- (void)setFrameWithViewForZooming:(UIView *)view inScrollView:(UIScrollView *)scrollView;

@end


