//
//  QAIMNavigaionView.m
//  QAGameIM
//
//  Created by 范浩云 on 2018/3/14.
//


#import "QAIMNavigaionView.h"
//#import "NSBundle+GetImg.h"


#define QStatusBarHeight    (QG_IS_IPHONE_X ? 44.0 : 20.0)
#define QNavBarHeight  (44.0)
#define QCustomNavBarHeight  (QStatusBarHeight + QNavBarHeight)
#define QG_IS_IPHONE_X (QDEVICE_WIDTH == 375.f && QDEVICE_HEIGHT == 812.f)
#define QPHOTO_FRAME_WIDTH   10
#define QDEVICE_HEIGHT      [UIScreen mainScreen].bounds.size.height
#define QDEVICE_WIDTH       [UIScreen mainScreen].bounds.size.width
#define QFONT(Size) [UIFont fontWithName:FONT_NAME size:Size]
#define QFONT_NAME  ((SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) ? (@"PingFangSC-Regular") : (@"STHeitiSC-Light"))




@interface QAIMNavigaionView ()
    
@property(nonatomic,strong) UIButton * bigBackBtn;
    
@end


@implementation QAIMNavigaionView
    
    
#pragma mark - ********************** View Lifecycle **********************
    
- (void)dealloc
    {
        // 一定要关注这个函数是否被执行了！！！
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
- (id)initWithFrame:(CGRect)frame
    {
        self = [super initWithFrame:frame];
        
        if (self)
        {
            // 注册消息
            [self regNotification];
            
            // 初始化变量
            [self initVariable];
            
            // 创建相关子view
            [self initMainViews];
        }
        
        return self;
    }
    
-(void)willMoveToSuperview:(UIView *)newSuperview
    {
        [super willMoveToSuperview:newSuperview];
        
        if(newSuperview == nil)
        {
            // 这块需要注意一下，当前view如果在其他地方被移除了的话，要小心下面这行代码！
            [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            return ;
        }
    }
    
    
#pragma mark - ********************** init and config **********************
    
    /**
     TODO: 初始化变量，例如：分页的page可以在该函数中赋初值
     */
- (void)initVariable
    {
        
    }
    
    /**
     TODO: 创建相关子view
     */
- (void)initMainViews
    {
        //添加View
        [self addSubview:self.contentView];
        [_contentView addSubview:self.titleLabel];
        [_contentView addSubview:self.backButton];
        [_contentView addSubview:self.bigBackBtn];
        [_contentView addSubview:self.rightButton];
        [_contentView addSubview:self.headLine];
        
        
        
        
        _contentView.frame = self.bounds;
        _titleLabel.frame  = CGRectMake(0, QStatusBarHeight, self.frame.size.width,self.frame.size.height-QStatusBarHeight);
        _backButton.frame  = CGRectMake(13, QStatusBarHeight, 60, self.frame.size.height-QStatusBarHeight);
        _bigBackBtn.frame = CGRectMake(0, QStatusBarHeight, 80, self.frame.size.height-QStatusBarHeight);
        _headLine.frame =CGRectMake(0, self.frame.size.height - .5, QDEVICE_WIDTH, .5);
        _rightButton.frame = CGRectMake(QDEVICE_WIDTH - 13 - 100, QStatusBarHeight, 100,self.frame.size.height-QStatusBarHeight);
    }
    
    /**
     TODO: 注册通知
     */
- (void)regNotification
    {
        
    }
    
    
#pragma mark - ******************************************* 对外方法 **********************************
    
    
#pragma mark - ******************************************* 基类方法(一般发生在重写函数) ****************
    
    
#pragma mark - ******************************************* Touch Event ***********************
    
    /**
     TODO: 返回按钮点击事件的响应函数
     
     */
- (void)btnClickBack:(UIButton *)aSender
    {
        
    }
    
-(void)clickNavEvent:(UIButton *)aSender
    {
        if (self.blockBtnClick) {
            self.blockBtnClick(aSender,QAE_BackBtnClick);
        }
    }
    
-(void)rightBtnClickEvent:(UIButton *)aSender
    {
        if (self.blockBtnClick) {
            self.blockBtnClick(aSender,QAE_RightBtnClick);
        }
    }
    
#pragma mark - ******************************************* 私有方法 **********************************
    
    
#pragma mark - ******************************************* Net Connection Event ********************
    
#pragma mark - 请求 demo
    
- (void)req_url_demo
    {
        
    }
    
    
#pragma mark - ******************************************* Delegate Event **************************
    
#pragma mark - 代理 demo
    
- (void)delegate_demo
    {
        
    }
    
    
#pragma mark - ******************************************* Notification Event **********************
    
#pragma mark - 通知 demo
    
- (void)notification_demo:(NSNotification *)aNotification
    {
        
    }
    
    
#pragma mark - ******************************************* 属性变量的 Set 和 Get 方法 *****************
-(UIView *)contentView
    {
        if (!_contentView) {
            _contentView =[[UIView alloc] initWithFrame:CGRectZero];
            _contentView.backgroundColor = [self YXColorWithHexCode:@"ffffff"];
        }
        return _contentView;
    }
    
    
-(UIView *)headLine
    {
        if (!_headLine) {
            _headLine = [[UIView alloc]initWithFrame:CGRectZero];
            _headLine.backgroundColor =  [self YXColorWithHexCode:@"e4e4e4"];
        }
        return _headLine;
    }
    
    
-(UILabel *)titleLabel
    {
        if (!_titleLabel) {
            _titleLabel =[[UILabel alloc] initWithFrame:CGRectZero];
            _titleLabel.textColor =  [self YXColorWithHexCode:@"#3B424C"];
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        }
        return _titleLabel;
    }
    
-(UIButton *)bigBackBtn
    {
        if (!_bigBackBtn) {
            _bigBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_bigBackBtn addTarget:self action:@selector(clickNavEvent:) forControlEvents:UIControlEventTouchUpInside];
        }
        return _bigBackBtn;
    }
    
-(UIButton *)backButton
    {
        if (!_backButton) {
            _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _rightButton.titleLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:12];
            [_backButton setImage:[UIImage imageNamed:@"JZBN_CloseQ"] forState:UIControlStateNormal];
            [_backButton addTarget:self action:@selector(clickNavEvent:) forControlEvents:UIControlEventTouchUpInside];
        }
        return _backButton;
}
    
    
-(UIButton *)rightButton
    {
        if (!_rightButton) {
            _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_rightButton setTitle:@"" forState:UIControlStateNormal];
            _rightButton.titleLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:15];
            _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [_rightButton setTitleColor:[self YXColorWithHexCode:@"333333"] forState:UIControlStateNormal];
            [_rightButton addTarget:self action:@selector(rightBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        }
        return _rightButton;
    }
    
- (UIColor *)YXColorWithHexCode:(NSString *)hex
{
    NSString *cleanString = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if ([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    
    if ([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF) / 255.0f;
    float green = ((baseValue >> 16) & 0xFF) / 255.0f;
    float blue = ((baseValue >> 8) & 0xFF) / 255.0f;
    float alpha = ((baseValue >> 0) & 0xFF) / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
    @end
