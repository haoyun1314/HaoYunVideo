 //
//  MPCodeExampleVC.m
//  MiaoPai
//
//  Created by 蔡勋 on 2017/5/25.
//  Copyright © 2017年 Jeakin. All rights reserved.
//


#import "MPCodeExampleVC.h"
/*
 备注：引用的头文件，尽量放到.m文件里面引入，上面是系统头文件，下面工程头文件
 */
#import <AddressBook/AddressBook.h>


/*
 备注：Delegate要一个一行，<和>符号要单独一行，并且经历区分系统和自定义代理
 */
@interface MPCodeExampleVC ()
<
UIAlertViewDelegate
>
{
    /*
     备注：类实例变量用_开头
     */
    /*
     备注：*号与变量挨着
     */
    /*
     备注：命名使用驼峰法，开头表示变量类型，以10个字母以内最佳，但要保证语义明确，特殊情况特殊处理
     */
    
    NSObject *_objectDemo;
    
    /**************************** 控件类 ****************************/
    
    UIView *_viewDemo;
    
    UIViewController *_vcDemo;
    
    UITableView *_tableViewDemo;
    UITableViewCell *_tableCellDemo;
    
    UICollectionView *_collectionViewDemo;
    UICollectionViewCell *_collectionCellDemo;
    
    UIScrollView *_scrollViewDemo;
    
    UIWebView *_webView;
    
    //WKWebView *_WebView;
    
    UIImage *_imgDemo;
    
    UIImageView *_imgViewDemo;
    
    UILabel *_lableDemo;
    
    UIButton *_btnDemo;
    
    UITextField *_textFieldDemo;
    
    UITextView *_textViewDemo;
    
    UIAlertView *_alertViewDemo;
    
    UISwitch *_switchDemo;
    
    UISearchBar *_searchBarDemo;
    
    UINavigationBar *_navBarDemo;
    
    UINavigationController *_navCtrlDemo;
    
    UIToolbar *_toolBarDemo;
    
    UIColor *_colorDemo;
    
    // 进度条类型
    UIProgressView *_progressViewDemo;
    
    UIControl *_controlDemo;
    
    UIPageControl *_pageCtrlDemo;
    
    UITapGestureRecognizer *_tapGestureDemo;
    
    UIPanGestureRecognizer *_panGestureDemo;
    
    UIPinchGestureRecognizer *_pinchGestureDmeo;
    
    UIRotationGestureRecognizer *_rotationGestureDemo;
    
    UILongPressGestureRecognizer *_longPressGestureDemo;
    
    CABasicAnimation *_basicAnimationDemo;
    
    CGAffineTransform _affineTransformDemo;
    
    /**************************** 数据类 ****************************/
    
    CGSize *_sizeDemo;
    
    BOOL _isDemo;
    
    CGFloat _floatDemo;
    
    CGRect _rectDemo;
    
    CGPoint _pointDemo;
    
    NSInteger _intDemo;
    NSUInteger _uIntDemo;
    
    /// c开头表示C类型
    int _cIntDemo;
    unsigned int _cUIntDmoe;
    
    float _cFloatDemo;
    double _cDoubleDemo;
    
    NSNumber *_numberDemo;
    
    NSData *_dataDemo;
    
    NSDate *_dateDemo;
    NSDateFormatter *_dateFormatterDemo;
    
    NSValue *_valueDemo;
    
    NSLock *_lockDemo;
    
    /// 不可变与可变，m表示可变
    NSString *_stringDemo;
    NSMutableString *_mStringDemo;
    
    /// Attr表示富文本
    NSAttributedString *_attrStringDemo;
    NSMutableAttributedString *_mAttrStringDemo;
    
    NSArray *_arrayDemo;
    NSMutableArray *_mArrayDemo;
    
    NSDictionary *_dicDemo;
    NSMutableDictionary *_mDicDemo;
    
    NSTimer *_timerDemo;
    
    NSTimeInterval *_timeIntervalDemo;
    
    NSSet *_setDemo;
    
    NSURL *_urlDemo;
    NSURLConnection *_urlConnectionDemo;
    NSMutableURLRequest *_mUrlRequestDemo;
    
    UIEdgeInsets _edgeInsetDemo;
    
    SEL _selDemo;
    
    /// id类型，能确定接收的id类型时，接上具体类型
    id _idDemo;
    id _idDicDemo;
    id _idArrayDemo;
    
    NSHTTPCookie *_httpCookie;
    
    NSCache *_cacheDemo;
    
    NSRange _rangeDemo;
    
    /// 正则表达式对象
    NSRegularExpression *_regularExpressionDemo;
    
    /// NSDataDetector是NSRegularExpression的子类，用于检测半结构化的数据，日期，地址，URL，电话号码等
    NSDataDetector *_dataDetectorDemo;
    
    /// NSRegularExpression对象匹配出来的结果对象，包含属性：1.所属类型2.在原字符串中的范围
    NSTextCheckingResult *_textCheckingResultDemo;
    
    /*************************** coreText类命名 **************************/
    
    /// 以cf开头的是要需要注意释放的
    
    CFStringRef _cfStringRefDemo;
    
    CFArrayRef _cfArrayRefDemo;
    
    /**************************** 通讯录类命名 ****************************/
    
    /// 以cfab开头:cf代表Core Foundation，ab代表通讯录
    
    ABAddressBookRef _cfabAddrBookDemo; /// 通讯录
    
    ABRecordRef _cfabRecordRefDemo; /// 通讯录单个联系人
    
    ABMultiValueRef _cfabMultiValueRefDemo; /// 通讯录多值属性
    
    /**************************** 自定义类命名 ****************************/
    
    MPHDemo _blockDemo;
    
    // 枚举变量
    MPE_Demo _enumDemo;
}

/*
 备注：属性变量使用方式：由于每个同学使用属性使用习惯不同，所以使用.方法时最靠谱的
 .方法调用：调用set/get方法
 _方法调用：直接访问内存，效率高，但是不走set/get方法
 属性都不用实现属性 @synthesize
 */
/// 变量要有注释
@property (nonatomic, strong) UIButton *btnDemo;


@end


@implementation MPCodeExampleVC


#pragma mark - ********************** View Lifecycle **********************

- (void)dealloc
{
    // 一定要关注这个函数是否被执行了！！！
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化变量
    [self initVariable];
    
    // 初始化界面
    [self initViews];
    
    // 注册消息
    [self regNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

 @param sender 被点击的按钮
 */
- (void)btnClickBack:(UIButton *)aSender
{
    [self.navigationController popViewControllerAnimated:YES];
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


@end
