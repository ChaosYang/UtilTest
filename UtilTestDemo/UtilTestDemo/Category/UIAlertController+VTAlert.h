//
//  UIAlertController+VTAlert.h
//  ViHealth
//
//  Created by yangweichao on 2021/4/20.
//  Copyright © 2021 Viatom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (VTAlert)

/// @brief 可修改message 对齐方式
/// @param title 标题
/// @param message  内容
/// @param alignment  内容对齐方式
+ (instancetype)vt_alertWithTitle:(nullable NSString *)title
                          message:(nullable NSString *)message
                 messageAlignment:(NSTextAlignment)alignment;

/// @brief 可修改文字颜色的构造方法
/// @param title 标题
/// @param color 标题颜色
/// @param message 内容
/// @param messageColor 内容颜色
+ (instancetype)vt_alertWithTitle:(nullable NSString *)title
                       titleColor:(nullable UIColor *)color
                          message:(nullable NSString *)message
                     messageColor:(nullable UIColor *)messageColor;

/// @brief 复杂富文本构成的提示
/// @param attributeTitle attributeTitle
/// @param attributeMessage attributeMessage
+ (instancetype)vt_alertWithAttributeTitle:(nullable NSAttributedString *)attributeTitle
                          attributeMessage:(nullable NSAttributedString *)attributeMessage;

- (void)resetTitleColor:(UIColor *)color;


@end


@interface UIAlertAction (VTAlert)


/// @brief 可调整文字颜色和对齐方式
/// @param title 文字
/// @param titleColor 文字颜色
/// @param alignment 文字对齐方式
/// @param style 原生style
/// @param handler 事件
+ (instancetype)vt_actionWithTitle:(nullable NSString *)title
                        titleColor:(nullable UIColor *)titleColor
                    titleAlignment:(NSTextAlignment)alignment
                             style:(UIAlertActionStyle)style
                           handler:(void (^ __nullable)(UIAlertAction *action))handler;

/// @brief 可调整文字颜色--UIAlertActionStyleDefault
/// @param title 文字
/// @param titleColor 文字颜色
/// @param handler 事件
+ (instancetype)vt_defaultActionWithTitle:(nullable NSString *)title
                               titleColor:(nullable UIColor *)titleColor
                                  handler:(void (^ __nullable)(UIAlertAction *action))handler;

@end

NS_ASSUME_NONNULL_END
