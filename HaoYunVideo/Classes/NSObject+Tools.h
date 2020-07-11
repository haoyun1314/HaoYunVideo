//
//  NSObject+Tools.h
//  Pods
//
//  Created by jiaxuzhou on 2017/7/23.
//
//

#import <Foundation/Foundation.h>

/// NSobject保护

// 判断obj是否为className类型
#define MPT_Object_Is_Class(obj,className) [obj isKindOfClass:className]
/// 判断是否为
#define MPT_Object_Is_ClassMember(obj,className) [obj isMemberOfClass:className]

/// 是否NSobject类型
#define MPT_Object_Class(obj) MPT_Object_Is_Class(obj,[NSObject class])

/// 是否为空null
#define MPT_Object_Not_Null(obj) ((obj) && ((NSNull *)obj != [NSNull null]))
#define MPT_Object_Is_Null(obj) ((!obj) || ((NSNull *)obj == [NSNull null]))

/// 是否有效，不为空，且是NSobject类型
#define MPT_Object_Is_Valid(obj) ((MPT_Object_Not_Null(obj)) && (MPT_Object_Class(obj)))

/// 是否无效，或为空，或不是NSobject
#define MPT_Object_Not_Valid(obj) ((MPT_Object_Is_Null(obj)) || (!MPT_Object_Class(obj)))




@interface NSObject (Tools)


@end
