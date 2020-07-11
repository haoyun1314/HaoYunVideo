//
//  MPCodeExampleVC.h
//  MiaoPai
//
//  Created by 蔡勋 on 2017/5/25.
//  Copyright © 2017年 Jeakin. All rights reserved.
//


/*
 代码规范：
 1、多用空格，多用回车（这个类里面的东西都是用了大量的空格和回车，大家仔细看看）
 2、命名规范，简单的用英文，复杂的用中文，长度要控制好，别太长了，别用太复杂的英文，免得再麻烦有道、词霸等工具
 3、多用已经定义好的公共方法
 4、尽量消灭警告，如果是第三方代码，原则上就别动了，除非你有很大的信心
 5、注意内存管理，做完工具跟一遍dealloc函数是否被执行
 6、XCODE显示一行的字符，100字符，打开XCode的行数标示
 7、能用block、代理搞定的，就少用消息机制
 8、此项目中所有代码建议优先纯代码实现，Xib坑爹的地方太多了
 9、项目的图片资源，要定期使用工具压缩一下，并且清理一下将不用的图片删除掉
 10、提交代码一定要审核；
 11、创建Button时，注意button的点击有效区域，要尽量大一些；
 */


/*
 项目级别
 项目中一些命名方式（以MP开头作为开头）
 
 MPB : Base基类，目前预留给基类工程使用
 MPC : Custom自定义控件类
 MPD : Delegate代理类
 MPE : Enum枚举类型
 MPF : Function功能类（eg：首页）
 MPH : Block类
 MPM : Model类
 notification : Notification通知函数，函数以小写开头
 MPP : Protocol协议类
 MPS : Singleton单例类
 delegate:Delegate实现函数，函数以delegate开头
 */



#import <UIKit/UIKit.h>


/*
 备注：自定义枚举类型 前缀以‘MPE_’起头，后面用大家熟悉的驼峰法，便于区分
 这里注意要指定所声明枚举的“数据类型”，还有就是给枚举成员“添加注释”
 NS_ENUM与后面的左括号有一个空格
 起始枚举的数字要有指定的值，养成习惯
 */
typedef NS_ENUM (NSInteger, MPE_Demo)
{
    /// 枚举demo1注释
    MPE_Demo0 = 0,
    
    /// 枚举demo1注释
    MPE_Demo1,
    
    /// 枚举demo2注释
    MPE_Demo2,
};


/*
 备注：代理类
 */
@protocol MPDDemoDelegate;


/// XXX的Block回调
typedef void (^MPHDemo)(NSInteger aIntParam);


/**
 备注：该vc的主要功能是什么，哪个版本添加的
 */
@interface MPCodeExampleVC : UIViewController

/*
 备注：相同功能的放在一堆，以外的按照变量类型去分块
 */
/*
 备注：注意空格，把nonatomic放在前面
 */
/*
 备注：外部变量属性，要注意使用哪个属性格式
 */
/*
 备注：不希望外部因非法操作更改了数组内容，用只读属性readonly
 */
/*
 备注：基本类型用 assign 属性，这个也都写上，格式上能保持一致
 */
/// 变量的意义
@property (nonatomic, assign, readonly) NSInteger intDemo;

/// 变量的意义
@property (nonatomic, copy) NSString *strCopyDemo;
/// 变量的意义
@property (nonatomic, strong) NSString *strStrongDemo;

/*
 备注：代理用 weak 属性
 */
/// 变量的意义
@property (nonatomic, weak) id<MPDDemoDelegate> delegate;

/*
 备注：代码块用 copy 属性
 */
/// 变量的意义
@property (nonatomic, copy) MPHDemo blockDemo;


@end



/**
 备注：该代理的主要功能是什么，哪个版本添加的
 */
@protocol MPDDemoDelegate <NSObject>

/*
 备注：必须实现的函数，以mpdRequied开头
 */
@required
- (void)mpdRequiedDemo;

/*
 备注：可选实现的函数，以mpdOptional开头
 */
@optional
- (void)mpdOptionalDemo;


@end
