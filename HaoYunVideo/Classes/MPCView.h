//
//  MPCView.h
//  Pods
//
//  Created by HouGeng on 17/7/22.
//
//

#import <UIKit/UIKit.h>

@interface MPCView : UIView

/// 扩展属性，携带字典参数
@property (nonatomic, strong) NSMutableDictionary *mdicParam;


#pragma mark - ********************************** 初始化方法 工厂模式 *********************************

+ (instancetype)getWithFrame:(CGRect)frame;

/*!
 *  @author caixun
 *  @brief  设置圆角 4个角全部进行圆角操作
 *  @param cornerRadius 圆角半径
 */
- (void)setCornerRadiusForAll:(float)cornerRadius;

/*!
 *  @author caixun
 *  @brief  设置圆角 指定某个角进行圆角操作
 *  @param corners     要做圆角操作的角
 *  @param cornerRadii 圆角半径
 */
- (void)setCornerRadiusForPart:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;


@end
