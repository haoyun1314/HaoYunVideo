//
//  MutableCopyCatetory.h
//  
//
//  Created by fanhaoyun on 2020/6/16.
//




#import <Foundation/Foundation.h>
@interface NSArray (Category)
-(NSMutableArray *)mutableArrayDeepCopy;
@end

@interface NSDictionary (Category)
-(NSMutableDictionary *)mutableDicDeepCopy;
@end
