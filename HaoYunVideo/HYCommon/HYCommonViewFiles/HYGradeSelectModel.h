//
//  HYGradeSelectModel.h
//  HaoYunVideo
////  HaoYunVideo
////{
//    "data": {
//        "primaryList": [
//            {
//                "primaryId": 1007000000,
//                "primaryName": "学前班",
//                "isClickBehind": "1",
//                "secondaryList": [
//                    {
//                        "secondaryId": 1007010000,
//                        "secondaryName": "上学期",
//                        "threeLevelList": [
//                            {
//                                "threeLevelId": 1007010100,
//                                "threeLevelName": "人教版"
//                            }
//                        ]
//                    }
//                ]
//            }
//
//
//        ],
//        "primaryTitle": "年级",
//        "secondaryTitle": "学期",
//        "threeLevelTitle": "教材版本",
//        "isDisplayClose": "1",
//        "default": {
//            "primaryId": 12,
//            "primaryName": "二年级",
//            "secondaryId": 1002020000,
//            "secondaryName": "下学期",
//            "threeLevelId": 1002020100,
//            "threeLevelName": "人教版"
//        }
//    }
//}
//  Created by fanhaoyun on 2020/7/14.
//  Copyright © 2020 范浩云. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@interface HYThreeLevelListItem : NSObject<NSCoding, NSCopying>

@property(nonatomic,assign)  NSInteger threeLevelId;
@property(nonatomic,strong)  NSString  *threeLevelName;
@property(nonatomic,assign) BOOL isSelected;
@property(nonatomic,strong) NSIndexPath * indexPath;


@end


@interface HYSecondaryListItem : NSObject<NSCoding, NSCopying>
@property(nonatomic,assign)  NSInteger secondaryId;
@property(nonatomic,strong)  NSString  *secondaryName;
@property(nonatomic,strong) NSArray <HYThreeLevelListItem*>* threeLevelList;
@property(nonatomic,assign) BOOL isSelected;
@property(nonatomic,strong) NSIndexPath * indexPath;


@end

@interface HYPrimaryListItem : NSObject<NSCoding, NSCopying>
@property(nonatomic,assign) NSInteger primaryId;
@property(nonatomic,strong) NSString  *primaryName;
@property(nonatomic,assign) NSInteger isClickBehind;
@property(nonatomic,assign) BOOL isSelected;
@property(nonatomic,strong) NSIndexPath * indexPath;
@property(nonatomic,strong) NSArray <HYSecondaryListItem *>* secondaryList;

@end


@interface HYDefaultModel : NSObject<NSCoding,NSCopying>

@property(nonatomic,assign)  NSInteger primaryId;
@property(nonatomic,strong)  NSString  *primaryName;
@property(nonatomic,assign)  NSInteger secondaryId;
@property(nonatomic,strong)  NSString * secondaryName;
@property(nonatomic,assign)  NSInteger threeLevelId;
@property(nonatomic,strong)  NSString * threeLevelName;

@end


@interface HYDataItem : NSObject<NSCoding, NSCopying>

@property(nonatomic,strong) NSArray<HYPrimaryListItem * >* primaryList;
@property(nonatomic,strong) NSString * primaryTitle;
@property(nonatomic,strong) NSString * secondaryTitle;
@property(nonatomic,strong) NSString * threeLevelTitle;
@property(nonatomic,assign) NSInteger isDisplayClose;
@property(nonatomic,strong) HYDefaultModel * defaultModel;

@end









