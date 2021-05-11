//
//  QRCodeUtils.h
//  UtilTestDemo
//
//  Created by yangweichao on 2021/5/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (QRCode)

/// @brief 生成二维码
/// @param code 地址
/// @param size size
+ (instancetype)generateQRCode:(NSString *)code size:(CGSize)size;

/// @brief 生成带logo的二维码
/// @param code 地址
/// @param size size
/// @param logo logo
+ (instancetype)generateQRCode:(NSString *)code size:(CGSize)size logo:(nonnull UIImage *)logo;

@end

NS_ASSUME_NONNULL_END
