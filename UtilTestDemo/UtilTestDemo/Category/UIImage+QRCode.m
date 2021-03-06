//
//  QRCodeUtils.m
//  UtilTestDemo
//
//  Created by yangweichao on 2021/5/7.
//

#import "UIImage+QRCode.h"

static NSString *SMGInputCorrectionLevelL = @"L";//!< L: 7%
static NSString *SMGInputCorrectionLevelM = @"M";//!< M: 15%
static NSString *SMGInputCorrectionLevelQ = @"Q";//!< Q: 25%
static NSString *SMGInputCorrectionLevelH = @"H";//!< H: 30%

@implementation UIImage (QRCode)

// 生成二维码
+ (instancetype)generateQRCode:(NSString *)code size:(CGSize)size {
    
    NSData *codeData = [code dataUsingEncoding:NSUTF8StringEncoding];
    //  使用CIQRCodeGenerator创建filter
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator" withInputParameters:@{@"inputMessage": codeData, @"inputCorrectionLevel": SMGInputCorrectionLevelH}];
    // 由filter.outputImage直接转成的UIImage不太清楚，需要做高清处理
    UIImage *codeImage = [UIImage scaleImage:filter.outputImage toSize:size];
    
    return codeImage;
}

//! 生成二维码+logo
+ (instancetype)generateQRCode:(NSString *)code size:(CGSize)size logo:(nonnull UIImage *)logo {
    
    UIImage *codeImage = [UIImage generateQRCode:code size:size];
    codeImage = [UIImage combinateCodeImage:codeImage andLogo:logo];
    return codeImage;
}

// 缩放图片(生成高质量图片）
+ (instancetype)scaleImage:(CIImage *)image toSize:(CGSize)size {
    
    //! 将CIImage转成CGImageRef
    CGRect integralRect = image.extent;// CGRectIntegral(image.extent);// 将rect取整后返回，origin取舍，size取入
    CGImageRef imageRef = [[CIContext context] createCGImage:image fromRect:integralRect];
    
    //! 创建上下文
    CGFloat sideScale = fminf(size.width / integralRect.size.width, size.width / integralRect.size.height) * [UIScreen mainScreen].scale;// 计算需要缩放的比例
    size_t contextRefWidth = ceilf(integralRect.size.width * sideScale);
    size_t contextRefHeight = ceilf(integralRect.size.height * sideScale);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGContextRef contextRef = CGBitmapContextCreate(nil, contextRefWidth, contextRefHeight, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);// 灰度、不透明
    CGColorSpaceRelease(colorSpaceRef);
    
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationNone);// 设置上下文无插值
    CGContextScaleCTM(contextRef, sideScale, sideScale);// 设置上下文缩放
    CGContextDrawImage(contextRef, integralRect, imageRef);// 在上下文中的integralRect中绘制imageRef
    CGImageRelease(imageRef);
    
    //! 从上下文中获取CGImageRef
    CGImageRef scaledImageRef = CGBitmapContextCreateImage(contextRef);
    CGContextRelease(contextRef);
    
    //! 将CGImageRefc转成UIImage
    UIImage *scaledImage = [UIImage imageWithCGImage:scaledImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    CGImageRelease(scaledImageRef);
    
    return scaledImage;
}

// 合成图片（code+logo）
+ (UIImage *)combinateCodeImage:(UIImage *)codeImage andLogo:(UIImage *)logo {
    
    UIGraphicsBeginImageContextWithOptions(codeImage.size, YES, [UIScreen mainScreen].scale);
    
    // 将codeImage画到上下文中
    [codeImage drawInRect:(CGRect){.0, .0, codeImage.size.width, codeImage.size.height}];
    
    // 定义logo的绘制参数
    CGFloat logoSide = fminf(codeImage.size.width, codeImage.size.height) / 4;
    CGFloat logoX = (codeImage.size.width - logoSide) / 2;
    CGFloat logoY = (codeImage.size.height - logoSide) / 2;
    CGRect logoRect = (CGRect){logoX, logoY, logoSide, logoSide};
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:logoRect cornerRadius:logoSide / 5];
    [cornerPath setLineWidth:2.0];
    [[UIColor whiteColor] set];
    [cornerPath stroke];
    [cornerPath addClip];
    
    // 将logo画到上下文中
    [logo drawInRect:logoRect];
    
    // 从上下文中读取image
    codeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return codeImage;
}


@end
