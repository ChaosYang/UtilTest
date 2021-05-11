//
//  UIAlertController+VTAlert.m
//  ViHealth
//
//  Created by yangweichao on 2021/4/20.
//  Copyright © 2021 Viatom. All rights reserved.
//

#import "UIAlertController+VTAlert.h"

@implementation UIAlertController (VTAlert)


// Default message font ---  看起来是14
+ (instancetype)vt_alertWithTitle:(NSString *)title
                          message:(NSString *)message
                 messageAlignment:(NSTextAlignment)alignment{
    UIAlertController *alert = [[super class] alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = alignment;
    [alertControllerMessageStr setAttributes:@{NSParagraphStyleAttributeName:paragraph,
                                               NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                       range:NSMakeRange(0, alertControllerMessageStr.length)];
    [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    return alert;
}


+ (instancetype)vt_alertWithTitle:(NSString *)title titleColor:(UIColor *)color message:(NSString *)message messageColor:(UIColor *)messageColor{
    UIAlertController *ac = [[super class] alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *alertControllerTitleStr = [[NSMutableAttributedString alloc] initWithString:title];
    [alertControllerTitleStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, title.length)];
    [alertControllerTitleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, title.length)];
    [ac setValue:alertControllerTitleStr forKey:@"attributedTitle"];
    
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
    [alertControllerMessageStr setAttributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:14],
        NSForegroundColorAttributeName:(messageColor?messageColor: [UIColor darkTextColor])
    }range:NSMakeRange(0, alertControllerMessageStr.length)];
//    [ac setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    return ac;
}

+ (instancetype)vt_alertWithAttributeTitle:(NSAttributedString *)attributeTitle attributeMessage:(NSAttributedString *)attributeMessage{
    UIAlertController *ac = [[super class] alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    [ac setValue:attributeTitle forKey:@"attributedTitle"];
    [ac setValue:attributeMessage forKey:@"attributedMessage"];
    return ac;
}


- (void)resetTitleColor:(UIColor *)color{
    if (self.title.length != 0 && self.preferredStyle == UIAlertControllerStyleAlert) {
        NSMutableAttributedString *alertControllerTitleStr = [[NSMutableAttributedString alloc] initWithString:self.title];
        [alertControllerTitleStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.title.length)];
        [self setValue:alertControllerTitleStr forKey:@"attributedTitle"];
    }
}


@end

@implementation UIAlertAction (VTAlert)

+ (instancetype)vt_actionWithTitle:(nullable NSString *)title
                        titleColor:(nullable UIColor *)titleColor
                    titleAlignment:(NSTextAlignment)alignment
                             style:(UIAlertActionStyle)style
                           handler:(void (^ __nullable)(UIAlertAction *action))handler{
    UIAlertAction *aa = [[super class] actionWithTitle:title style:style handler:handler];
    if (titleColor) {
        [aa setValue:titleColor forKey:@"_titleTextColor"];
    }
    [aa setValue:@(alignment) forKey:@"_titleTextAlignment"];
    return aa;
}

+ (instancetype)vt_defaultActionWithTitle:(nullable NSString *)title
                               titleColor:(nullable UIColor *)titleColor
                                  handler:(void (^ __nullable)(UIAlertAction *action))handler{
    UIAlertAction *aa = [[super class] actionWithTitle:title style:UIAlertActionStyleDefault handler:handler];
    if (titleColor) {
        [aa setValue:titleColor forKey:@"_titleTextColor"];
    }
    return aa;
}

@end
