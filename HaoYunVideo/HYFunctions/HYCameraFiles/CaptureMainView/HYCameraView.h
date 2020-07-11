//
//  HYCameraView.h
//  HaoYunVideo
//
//  Created by 范浩云 on 2019/9/17.
//Copyright © 2019 范浩云. All rights reserved.
//
#import <UIKit/UIKit.h>


typedef void(^PushPageBlock)(Campture_Handle_Type type,id object);

@interface HYCameraView : UIView

//拍摄按钮
@property (nonatomic, strong) UIButton *takePhoto;
//push的界面
@property (nonatomic, copy) PushPageBlock pushPageBlock;

@property(nonatomic,assign) Campture_Handle_Type selectType;


@end
