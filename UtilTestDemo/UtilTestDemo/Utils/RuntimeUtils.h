//
//  RuntimeUtils.h
//  UtilTestDemo
//
//  Created by yangweichao on 2021/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RuntimeUtils : NSObject

/// @brief 获取目标所有属性
/// @param target 类
/// @return 所有属性名
+ (NSArray *)getAllPropertys:(Class)target;

/// @brief 获取目标所有成员变量
/// @param target  类
/// @return 所有成员变量及其类型构成的字典组成的数组   key :  ivarName  & ivarType
+ (NSArray <NSDictionary *>*)getAllIVars:(Class)target;

@end

NS_ASSUME_NONNULL_END
