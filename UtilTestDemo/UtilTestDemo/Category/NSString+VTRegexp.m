//
//  NSString+VTRegexp.m
//  UtilTestDemo
//
//  Created by yangweichao on 2021/4/26.
//

#import "NSString+VTRegexp.h"

@implementation NSString (VTRegexp)

static NSString * const vtNumberRegexp = @"^[0-9]+$";
static NSString * const vtDotnumberRegexp = @"(^[0]|^[1-9][0-9]*)([.]{1}[0-9]*){0,1}$";
static NSString * const vtEmailRegexp = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
static NSString * const vtPhoneRegexp = @"^1(3\\d|4[5-9]|5[0-35-9]|6[567]|7[0-8]|8\\d|9[0-35-9])\\d{8}$";
static NSString * const vtChineseRegexp = @"^[\u4e00-\u9fa5]{0,}$";
static NSString * const vtIdentityRegexp = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";

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

- (BOOL)isValidIdentityNumber:(VTIdentityLevel)level{
    if (self.length != 18) return NO;
    if (![self match:vtIdentityRegexp]) return NO;
    if (level == VTIdentityLevelNormal) return YES;
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0; i < 17; i++) {
        NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum += subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod = idCardWiSum % 11;
    //得到最后一位身份证号码
    NSString *idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod == 2) {
        if(![idCardLast isEqualToString:@"X"]|| ![idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)match:(NSString *)regex{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

@end
