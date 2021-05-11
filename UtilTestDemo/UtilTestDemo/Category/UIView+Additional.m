//
//  UIView+Additional.m
//  UtilTestDemo
//
//  Created by yangweichao on 2021/5/11.
//

#import "UIView+Additional.h"

#define VTSetValue(param, value) \
({\
CGRect frame = self.frame;\
frame.param = value;\
self.frame = frame;\
})

@implementation UIView (Additional)

- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)nOrigin{
    VTSetValue(origin, nOrigin);
}

- (CGSize)size{
    return self.frame.size;
}

- (void)setSize:(CGSize)nSize{
    VTSetValue(size, nSize);
}

- (CGFloat)top{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)nTop{
    VTSetValue(origin.y, nTop);
}

- (CGFloat)left{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)nLeft{
    VTSetValue(origin.x, nLeft);
}

- (CGFloat)right{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)nRight{
    CGFloat diff = nRight - self.frame.size.width; // 计算得到新的x起点
    VTSetValue(origin.x, diff);
}

- (CGFloat)bottom{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)nBottom{
    CGFloat diff = nBottom - self.frame.size.height; // 计算得到新的y起点
    VTSetValue(origin.y, diff);
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)nWidth{
    VTSetValue(size.width, nWidth);
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)nHeight{
    VTSetValue(size.height, nHeight);
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)topLeft{
    return self.frame.origin;
}

- (CGPoint)topRight{
    return CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y);
}

- (CGPoint)bottomLeft{
    return CGPointMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height);
}

- (CGPoint)bottomRight{
    return CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y + self.frame.size.height);
}

@end
