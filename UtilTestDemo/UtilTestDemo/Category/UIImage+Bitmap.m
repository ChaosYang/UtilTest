//
//  UIImage+Bitmap.m
//  UtilTestDemo
//
//  Created by 杨伟超 on 2022/1/20.
//

#import "UIImage+Bitmap.h"

@implementation UIImage (Bitmap)


+ (instancetype)grayBitmapFromText:(NSString *)text{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Microsoft YaHei" size:16], NSForegroundColorAttributeName: [UIColor whiteColor]};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesDeviceMetrics
                                      attributes:attributes
                                         context:nil].size;
    CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef contextRef = CGBitmapContextCreate(NULL, textSize.width, textSize.height, 8, 0, colorRef, kCGImageAlphaPremultipliedFirst);
    UIImage *image = [UIImage imageWithColor:[UIColor blackColor] size:textSize textAttributes:attributes text:text];
    CGContextDrawImage(contextRef, CGRectMake(0, 0, textSize.width, textSize.height), image.CGImage);
    unsigned char *data = CGBitmapContextGetData(contextRef);
    
    return image;
}


+ (instancetype)imageWithColor:(UIColor *)color
                          size:(CGSize)size
                textAttributes:(NSDictionary *)textAttributes
                          text:(NSString *)text {
    if (!color || size.width < 0 || size.height < 0) {
        return nil;
    }
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctr, color.CGColor);
    CGContextFillRect(ctr, rect);
    
    CGSize textSize = [text sizeWithAttributes:textAttributes];
    [text drawInRect:CGRectMake((size.width - textSize.width)* 0.5, (size.height - textSize.height) * 0.5, textSize.width, textSize.height) withAttributes:textAttributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
