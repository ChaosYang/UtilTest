//
//  NSString+VTRegexp.m
//  UtilTestDemo
//
//  Created by yangweichao on 2021/4/26.
//

#import "NSString+VTRegexp.h"

@implementation NSString (VTRegexp)

static NSString * const vtNumberRegexp = @"^[0-9]+$";
static NSString * const vtEmailRegexp = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
static NSString * const vtPhoneRegexp = @"^1(3\\d|4[5-9]|5[0-35-9]|6[567]|7[0-8]|8\\d|9[0-35-9])\\d{8}$";
static NSString * const vtChineseRegexp = @"^[\u4e00-\u9fa5]{0,}$";

- (BOOL)isEmpty{
    if (!self) {
        return YES;
    }else{
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [self stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (BOOL)isAllNumber{
    return [self match:vtNumberRegexp];
}

- (BOOL)containsNumber{
    NSRange range = [self rangeOfString:vtNumberRegexp options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (BOOL)isValidEmail{
    return [self match:vtEmailRegexp];
}

- (BOOL)isValidPhoneNumber{
    return [self match:vtPhoneRegexp];
}

- (BOOL)isChinese{
    return [self match:vtChineseRegexp];
}

- (BOOL)isValidDateTime:(VTDateFormat)format{
    /*
     * \\d{3}[1-9]|\\d{2}[1-9]\\d{1}|\\d{1}[1-9]\\d{2}|[1-9]\\d{3} 年份
     * ((0[48]|[2468][048]|[3579][26])00)|([0-9]{2})(0[48]|[2468][048]|[13579][26]) 闰年
     * (0[13578]|1[02])-(0[1-9]|[12]\\d|3[01]) 月份 1/3/5/7/8/10/12
     * (0[469]|11)-(0[1-9]|[12][0-9]|30)  月份4/6/9/11
     * 02-(0[1-9]|[1]\\d|2[0-8]) 平月  02-(0[1-9]|[1]\\d|2\\d)  闰月
     * (3[01]|[12][0-9]|0?[1-9]) 日期
     * \\s+([0-1][:-]?[0-9]|2[0-3])[:-]?([0-5][0-9])[:-]?([0-5][0-9]) 时间
     */
    // 第一种情况  1、3、5、7、8、10、12 均为31天
    NSString *regex1 = @"((1[8-9]\\d{2})|([2-9]\\d{3}))([-\\/\\._]?)(10|12|0[13578])([-\\/\\._]?)(3[01]|[12][0-9]|0[1-9])";
    // 第二种情况  4、6、9、11 均为30天
    NSString *regex2 = @"((1[8-9]\\d{2})|([2-9]\\d{3}))([-\\/\\._]?)(11|0[469])([-\\/\\._]?)(30|[12][0-9]|0[1-9])";
    // 第三种情况 平月
    NSString *regex3 = @"((1[8-9]\\d{2})|([2-9]\\d{3}))([-\\/\\._]?)(02)([-\\/\\._]?)(2[0-8]|1[0-9]|0[1-9])";
    // 第四种情况 能被400整除的 闰年 闰月
    NSString *regex4 = @"((0[48]|[2468][048]|[3579][26])00)([-\\/\\._]?)(02)([-\\/\\._]?)(29)";
    // 第五种情况 能被4整除但不能被100整除的年份
    NSString *regex5 = @"([0-9]{2})(0[48]|[2468][048]|[13579][26])([-\\/\\._]?)(02)([-\\/\\._]?)(29)";
    // 补充时间格式
    NSString *regexTime = @"([\\s]?)([0-1]\\d|2[0-4])([:-]?)([0-5]\\d)([:-]?)([0-5]\\d)";
    if (format == VTDateFormatDefault) {
        regex1 = @"((1[8-9]\\d{2})|([2-9]\\d{3}))(10|12|0[13578])(3[01]|[12][0-9]|0[1-9])";
        regex2 = @"((1[8-9]\\d{2})|([2-9]\\d{3}))(11|0[469])(30|[12][0-9]|0[1-9])";
        regex3 = @"((1[8-9]\\d{2})|([2-9]\\d{3}))(02)(2[0-8]|1[0-9]|0[1-9])";
        regex4 = @"((0[48]|[2468][048]|[3579][26])00)(02)(29)";
        regex5 = @"([0-9]{2})(0[48]|[2468][048]|[13579][26])(02)(29)";
        regexTime = @"([0-1]\\d|2[0-4])([0-5]\\d)([0-5]\\d)";
    }else if (format == VTDateFormatValue1) {
        regex1 = @"((1[8-9]\\d{2})|([2-9]\\d{3}))([-])(10|12|0[13578])([-])(3[01]|[12][0-9]|0[1-9])";
        regex2 = @"((1[8-9]\\d{2})|([2-9]\\d{3}))([-])(11|0[469])([-])(30|[12][0-9]|0[1-9])";
        regex3 = @"((1[8-9]\\d{2})|([2-9]\\d{3}))([-])(02)([-])(2[0-8]|1[0-9]|0[1-9])";
        regex4 = @"((0[48]|[2468][048]|[3579][26])00)([-])(02)([-])(29)";
        regex5 = @"([0-9]{2})(0[48]|[2468][048]|[13579][26])([-])(02)([-])(29)";
        regexTime = @"([\\s])([0-1]\\d|2[0-4])([:])([0-5]\\d)([:])([0-5]\\d)";
    }else if (format == VTDateFormatValue2) {
        regex1 = @"((1[8-9]\\d{2})|([2-9]\\d{3}))([\\/])(10|12|0[13578])([\\/])(3[01]|[12][0-9]|0[1-9])";
        regex2 = @"((1[8-9]\\d{2})|([2-9]\\d{3}))([\\/])(11|0[469])([\\/])(30|[12][0-9]|0[1-9])";
        regex3 = @"((1[8-9]\\d{2})|([2-9]\\d{3}))([\\/])(02)([\\/])(2[0-8]|1[0-9]|0[1-9])";
        regex4 = @"((0[48]|[2468][048]|[3579][26])00)([\\/])(02)([\\/])(29)";
        regex5 = @"([0-9]{2})(0[48]|[2468][048]|[13579][26])([\\/])(02)([\\/])(29)";
        regexTime = @"([\\s])([0-1]\\d|2[0-4])([:])([0-5]\\d)([:])([0-5]\\d)";
    }
    NSString *regex = [NSString stringWithFormat:@"^(%@|%@|%@|%@|%@)%@$",regex1, regex2, regex3, regex4, regex5, regexTime];
    return [self match:regex];
}

- (BOOL)match:(NSString *)regex{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

@end
