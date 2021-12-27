//
//  NSObject+Additional.h
//  UtilTestDemo
//
//  Created by yangweichao on 2021/9/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Additional)

+ (NSArray *)getAllPropertys;

+ (NSArray <NSDictionary *>*)getAllIVars;

@end

NS_ASSUME_NONNULL_END
