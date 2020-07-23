//
//  HYGradeSelectModel.m
//  HaoYunVideo
//

//  Created by fanhaoyun on 2020/7/14.
//  Copyright © 2020 范浩云. All rights reserved.
//

#import "HYGradeSelectModel.h"
#define YYModelSynthCoderAndHash \
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; } \
- (id)initWithCoder:(NSCoder *)aDecoder { return [self yy_modelInitWithCoder:aDecoder]; } \
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; } \
- (NSUInteger)hash { return [self yy_modelHash]; } \
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }





@implementation HYThreeLevelListItem

YYModelSynthCoderAndHash
@end

@implementation HYSecondaryListItem
YYModelSynthCoderAndHash
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"threeLevelList":[HYThreeLevelListItem class]};
}
@end



@implementation HYPrimaryListItem

YYModelSynthCoderAndHash

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"secondaryList":[HYSecondaryListItem class]};
}

@end


@implementation HYDefaultModel
YYModelSynthCoderAndHash
@end


@implementation HYDataItem

YYModelSynthCoderAndHash
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"defaultModel" : @"default"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"primaryList":[HYPrimaryListItem class],@"defaultModel":@"HYDefaultModel"};
}
    

    
@end



