//
//  MPValidObject.h
//  MiaoPai
//
//  Created by Simon on 14-6-20.
//  Copyright (c) 2014年 Xuan Yi Xia Technology Co., LTD. All rights reserved.
//

#import "MPTObject.h"

@interface MPTValidObject : MPTObject

BOOL isValidValue(id object);
BOOL isValidObject(id object, Class aClass);
BOOL isValidNSDictionary(id object);
BOOL isValidNSArray(id object);
BOOL isValidContainEmptyArray(id object);
BOOL isValidNSString(id object);
BOOL isValidNSNumber(id object);
BOOL isValidNSURL(id object);

id getValidObjectFromArray(NSArray *array, NSInteger index);
id getValidObjectFromDictionary(NSDictionary *dic, NSString *key);

void setValidObjectForDictionary(NSMutableDictionary *dic, NSString*key, id value);
void addValidObjectForArray(NSMutableArray *array, id value);
void addValidArrayForArray(NSMutableArray *array, NSArray *value);
void replaceValidObjectForArray(NSMutableArray *array, NSInteger index, id value);

void removeValidObjectFromArray(NSMutableArray *array, NSInteger index);
@end
