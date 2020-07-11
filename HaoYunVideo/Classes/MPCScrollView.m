
#import "MPCScrollView.h"

@implementation MPCScrollView


#pragma mark - *********************************** View Lifecycle **********************************

- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        /// 初始化变量
        [self initVariable];
        
        /// 设置公共属性，与App的UI规范 有关
        [self setCustomAttribute];
    }
    
    return self;
}

- (void)initVariable
{
    
}

/// 设置公共属性，与App的UI规范 无关
- (void)setCommonAttribute
{
    
}

/// 设置公共属性，与App的UI规范 有关
- (void)setCustomAttribute
{
    if (self)
    {
        /// 设置背景颜色
        self.backgroundColor = [UIColor clearColor];
        /// 不显示 水平 滑条
        self.showsHorizontalScrollIndicator = NO;
        /// 不显示 垂直 滑条
        self.showsVerticalScrollIndicator = NO;
        self.clipsToBounds = YES;
    }
}

#pragma mark - ********************************** 初始化方法 工厂方法 *********************************

#pragma mark - 初始化基本设置

+ (instancetype)getWithFrame:(CGRect)frame target:(id)target;
{
    /// 默认 Grouped 类型
    MPCScrollView *tabv = [[MPCScrollView alloc] initWithFrame:frame
                                                      target:target];
    return tabv;
}

#pragma mark - ********************************** 初始化方法 实例方法 *********************************

#pragma mark - 初始化基本设置

- (instancetype)initWithFrame:(CGRect)frame target:(id)target
{
    if (self = [self initWithFrame:frame])
    {
        /// 设置代理
        self.delegate = target;
    }
    
    return self;
}

#pragma mark - *********************************** 设置属性 实例方法 **********************************

- (void)setCornerRadiusForAll:(float)cornerRadius
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setCornerRadiusForPart:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    // 上面两个圆角
    UIBezierPath *maskPath=  [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:cornerRadii];
    
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc] init];
    
    maskLayer.frame=self.bounds;
    
    maskLayer.path=maskPath.CGPath;
    
    self.layer.mask=maskLayer;
    
    self.layer.masksToBounds=YES;
}

#pragma mark - *********************************** 设置代理 **********************************

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *view = touch.view;
    
    //用户识别在会话列表时滑动删除会话,与滑动切换栏目的手势冲突
    if (([@"UITableViewCellContentView" isEqualToString:[[view class] description]] && [view.superview isKindOfClass:[UITableViewCell class]] && ((UITableViewCell *)view.superview).editing))
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIView *view = gestureRecognizer.view;
    
    
    //用户识别在会话列表时滑动删除会话,与滑动切换栏目的手势冲突
    if (([@"UITableViewCellContentView" isEqualToString:[[view class] description]] && [view.superview isKindOfClass:[UITableViewCell class]] && ((UITableViewCell *)view.superview).editing))
    {
        return NO;
    }
    
    if (([@"MPCScrollView" isEqualToString:[[view class] description]] && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [self commitTranslationisLeft:[((UIPanGestureRecognizer *)gestureRecognizer) translationInView:gestureRecognizer.view]]) && ((UIScrollView *)view).contentOffset.x >[UIScreen mainScreen].bounds.size.width)
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)commitTranslationisLeft:(CGPoint)translation
{
    if (translation.x <0)
    {
        return YES;
    }
    
    return NO;
}

@end
