//
//  HYBottomShowSelectView.h
//  HaoYunVideo
//
//  Created by fanhaoyun on 2020/7/12.
//  Copyright © 2020 范浩云. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface HYBottomShowSelectView : UIView



-(void)gradeViewShowWindowToParent:(UIView *)aParentView showBlock:(void(^)(void))showBlock
                      disMissBlock:(void (^)(NSDictionary * paraDic))dismissBlock
                         sureBlock:(void (^)(NSDictionary * paraDic))sureBlock;

@end

