//
//  UIColor+VTColor.h
//  UtilTestDemo
//
//  Created by yangweichao on 2021/4/25.
//

#import <UIKit/UIKit.h>

#define VTColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s & 0xFF00) >> 8))/255.0 blue:((s & 0xFF))/255.0 alpha:1.0]
#define VTColorFromRGB(r, g, b) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1.0]
#define VTColorFromRGBA(r, g, b, a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (VTColor)

/// @brief 16进制字符串 生成UIColor 透明度为1
/// @param hexString 16进制颜色字符串
+ (UIColor *)vt_colorWithHexString:(NSString *)hexString;

/// @brief 16进制字符串 生成UIColor 透明度可调节
/// @param hexString 16进制颜色字符串
/// @param alpha 透明度
+ (UIColor *)vt_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
