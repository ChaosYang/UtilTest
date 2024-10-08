//
//  UIDevice+Additional.h
//  UtilTestDemo
//
//  Created by yangweichao on 2021/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Additional)

/// @brief 判断当前iPhone型号是否不低于iphone X  暂定为刘海屏
@property (nonatomic, readonly) BOOL isIphoneX;

/// @brief 设备是否越狱
@property (nonatomic, readonly) BOOL isJailBreak;

/// @brief 是否是模拟器
@property (nonatomic, readonly) BOOL isSimulator;

/// @brief 是否是ipad
@property (nonatomic, readonly) BOOL isIpad;

/// @brief 每mm对应的pt数量
/// @author viatom-chensihua
@property (nonatomic, readonly) CGFloat ptPer_mm;

/// @brief 状态栏高度
@property (nonatomic, readonly) double statusBarHeight;

@end

NS_ASSUME_NONNULL_END
