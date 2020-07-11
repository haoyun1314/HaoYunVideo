
//
//  QAIMNavigaionView.h
//  QAGameIM
//
//  Created by 范浩云 on 2018/3/14.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,QAE_ClickType)
{
    QAE_BackBtnClick,   //返回
    QAE_RightBtnClick   //导航右侧点击
};

typedef void(^QAHClickBolck)(UIButton *btn,QAE_ClickType type);

@interface QAIMNavigaionView : UIView
//
@property (nonatomic,strong) UIView * contentView;
//
@property (nonatomic,strong) UIView *headLine ;
//
 @property(nonatomic,strong) UILabel *titleLabel;
//
@property(nonatomic,strong) UIButton *backButton;
//
@property(nonatomic,strong)NSString* rightTitle;
//
@property(nonatomic,strong) UIButton * rightButton;
//
@property (nonatomic, copy) QAHClickBolck blockBtnClick;

@end
