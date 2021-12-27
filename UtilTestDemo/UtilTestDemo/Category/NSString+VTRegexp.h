//
//  NSString+VTRegexp.h
//  UtilTestDemo
//
//  Created by yangweichao on 2021/4/26.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    VTDateFormatDefault, // yyyyMMddHHmmss
    VTDateFormatValue1,  // yyyy-MM-dd HH:mm:ss
    VTDateFormatValue2,  // yyyy/MM/dd HH:mm:ss
} VTDateFormat;

typedef enum : NSUInteger {
    VTIdentityLevelNormal,  // 基本校验
    VTIdentityLevelPrecise, // 精准校验
} VTIdentityLevel;

NS_ASSUME_NONNULL_BEGIN

@interface NSString (VTRegexp)

/// @brief 判断空字符串
- (BOOL)isEmpty;

/// @brief 判断是否全部是数字
- (BOOL)isAllNumber;

/// @brief 判断是否是邮箱
- (BOOL)isValidEmail;

/// @brief 判断手机号码
- (BOOL)isValidPhoneNumber;

/// @brief 判断是否是汉字
- (BOOL)isChinese;

/// @brief 判断是否是要求的日期格式  日期分隔符可以是/ - . _ 或者没有 ； 时间分割符为: 或者没有  yyyy MM  dd HH mm ss
- (BOOL)isValidDateTime:(VTDateFormat)format;

/// @brief 判断是否为精准的身份证信息
- (BOOL)isValidIdentityNumber:(VTIdentityLevel)level;

/// @brief 匹配正则
/// @param regex  正则字符串
- (BOOL)match:(NSString *)regex;

@end

NS_ASSUME_NONNULL_END
