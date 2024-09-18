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
//    UIImage *image = [self grayScaleMapFromText:text font:[UIFont fontWithName:@"Microsoft YaHei" size:16]];
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

+ (UIImage *)grayScaleMapFromText:(NSString *)text font:(UIFont *)font {
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    NSMutableString *strM = [NSMutableString stringWithString:text];
    while ([strM sizeWithAttributes:attributes].width > 92) {
        [strM deleteCharactersInRange:NSMakeRange(strM.length - 1, 1)];
    }
    text = strM.copy;
    
    CGSize textSize = [text sizeWithAttributes:attributes];
    textSize = CGSizeMake(ceil(textSize.width), ceil(textSize.height));
    // 分配内存
    const int imageWidth = ceil(textSize.width);
    const int imageHeight = ceil(textSize.height);
//    size_t bytesPerRow = imageWidth * 4;
    //初始化一个RGB图像流
//    uint32_t *imageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);

    // 创建context，设置RGB图像流
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 imageWidth,
                                                 imageHeight,
                                                 8,
                                                 0,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    UIGraphicsPushContext(context);
    
    CGContextTranslateCTM(context, 0, imageHeight);
    CGContextScaleCTM(context, 1, -1);
    
    CGRect rect = CGRectMake(0, 0, CGBitmapContextGetWidth(context), CGBitmapContextGetHeight(context));
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, rect);
    
//    CGContextSetTextDrawingMode(context, kCGTextFillClip);
//    CGContextSetAllowsAntialiasing(context, NO);
    CGContextSetShouldAntialias(context, NO);
    [text drawInRect:CGRectMake((imageWidth - textSize.width)* 0.5, (imageHeight - textSize.height) * 0.5, textSize.width, textSize.height) withAttributes:attributes];
    
    CGImageRef grayImgRef = CGBitmapContextCreateImage(context);
    UIImage *grayImg = [UIImage imageWithCGImage:grayImgRef];

    UIGraphicsPopContext();
    
    return grayImg;
}

- (NSData *)binarization {
    
    CGDataProviderRef pr = CGImageGetDataProvider(self.CGImage);
    NSData *data = (id)CFBridgingRelease(CGDataProviderCopyData(pr));
    uint32_t *imageBuffer = (uint32_t *)data.bytes;
    
    uint8_t *tempBuff = malloc(data.length/4);
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i < data.length/4; i++) {
        
        uint32_t pixel = imageBuffer[i];
        NSData *dr = [NSData dataWithBytes:&pixel length:sizeof(uint32_t)];
        
        uint8_t *pixelBuff = (uint8_t *)dr.bytes;
        
        uint8_t b = pixelBuff[1];
        uint8_t g = pixelBuff[2];
        uint8_t r = pixelBuff[3];
        
        uint8_t gray = 0.299 * r + 0.587 * g + 0.114 * b;
        if (gray < 128) {
            tempBuff[i] = 0;
        } else {
            tempBuff[i] = 1;
        }
        [tempArr addObject:@(tempBuff[i])];
    }
    
//    for (int i = 0; i < data.length; i++) {
//        Byte first = imageBuffer[i];
//        if (first < 128) {
//            *(imageBuffer+i) = 0;
//        } else {
//            *(imageBuffer+i) = 1;
//        }
//    }

    uint8_t *d = (uint8_t *)malloc(data.length/4/8);
    int l = 0;
    for (int i =  0; i < data.length/4; i += 8) {
        Byte first = tempBuff[i];
        for (int j = 0; j < 7; j++) {
            Byte second = ((first << 1) | tempBuff[i + j]);
            first = second;
        }
        *(d+l) = first;
        l++;
    }
    NSData *da = [NSData dataWithBytes:d length:data.length/4/8];
    free(d);
    free(tempBuff);
    return da;
}

- (NSData *)binaryTest {
    CGDataProviderRef pr = CGImageGetDataProvider(self.CGImage);
    NSData *data = (id)CFBridgingRelease(CGDataProviderCopyData(pr));
    uint32_t *imageBuffer = (uint32_t *)data.bytes;
    
    uint8_t *tempBuff = malloc(data.length/sizeof(uint8_t));
    
    for (int i = 0; i < data.length/sizeof(uint32_t); i++) {
        
        uint32_t pixel = imageBuffer[i];
        NSData *dr = [NSData dataWithBytes:&pixel length:sizeof(uint32_t)];
        
        uint8_t *pixelBuff = (uint8_t *)dr.bytes;
        
        uint8_t b = pixelBuff[1];
        uint8_t g = pixelBuff[2];
        uint8_t r = pixelBuff[3];
        
        uint8_t gray = 0.299 * r + 0.587 * g + 0.114 * b;
        if (gray < 128) {
            tempBuff[i] = 0;
        } else {
            tempBuff[i] = 1;
        }
    }
    
//    for (int i = 0; i < data.length; i++) {
//        Byte first = imageBuffer[i];
//        if (first < 128) {
//            *(imageBuffer+i) = 0;
//        } else {
//            *(imageBuffer+i) = 1;
//        }
//    }

    uint8_t *d = (uint8_t *)malloc(data.length/sizeof(uint32_t)/8);
    int l = 0;
    for (int i =  0; i < data.length/4; i += 8) {
        Byte first = tempBuff[i];
        for (int j = 0; j < 7; j++) {
            Byte second = ((first << 1) | tempBuff[i + j]);
            first = second;
        }
        *(d+l) = first;
        l++;
    }
    NSData *da = [NSData dataWithBytes:d length:data.length/4/8];
    free(d);
    free(tempBuff);
    return da;
}


@end
