//
//  UIView+Additional.h
//  UtilTestDemo
//
//  Created by yangweichao on 2021/5/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Additional)

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign, readonly) CGPoint topLeft;
@property (nonatomic, assign, readonly) CGPoint topRight;
@property (nonatomic, assign, readonly) CGPoint bottomLeft;
@property (nonatomic, assign, readonly) CGPoint bottomRight;

@end

NS_ASSUME_NONNULL_END
