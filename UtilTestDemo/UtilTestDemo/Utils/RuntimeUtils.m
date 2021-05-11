//
//  RuntimeUtils.m
//  UtilTestDemo
//
//  Created by yangweichao on 2021/4/21.
//

#import "RuntimeUtils.h"
#import <objc/runtime.h>

@implementation RuntimeUtils

+ (NSArray *)getAllPropertys:(Class)target{
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList(target, &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        
        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
    }
    return mArray.copy;
}

+ (NSArray <NSDictionary *>*)getAllIVars:(Class)target{
    u_int count = 0;
    //获取指定类的Ivar列表及Ivar个数
    Ivar *member = class_copyIvarList(target, &count);
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i ++) {
        Ivar var = member[i];
        const char *memberAddress = ivar_getName(var);
        const char *memberTyoe = ivar_getTypeEncoding(var);
        NSLog(@"address = %s, type = %s", memberAddress, memberTyoe);
        NSString *name = [NSString stringWithCString:memberAddress encoding:NSUTF8StringEncoding];
        NSString *type = [NSString stringWithCString:memberTyoe encoding:NSUTF8StringEncoding];
        [mArray addObject:@{@"ivarName": name, @"ivarType": type}];
    }
    return mArray;
}

@end
