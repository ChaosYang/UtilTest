//
//  NSData+XorEncrypt.m
//  iwown
//
//  Created by viatom on 2020/6/4.
//  Copyright © 2020 LP. All rights reserved.
//

#import "NSData+XorEncrypt.h"

@implementation NSData (XorEncrypt)

NSString *privateKey = @"efdjksg42oss24f3s";

- (NSData *)xor_decryptWithKey:(NSString *)key
{
    if (!key) {
        key = privateKey; // 默认值解密
    }
    return [self xor_encryptWithKey:key];
}

// 加密
- (NSData *)xor_encryptWithKey:(NSString *)key
{
    // 获取key的长度
    if (!key) {
        key = privateKey; // 赋予默认值加密
    }
    NSInteger length = key.length;
    // 将OC字符串转换为C字符串
    const char *keys = [key cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cKey[length];
    memcpy(cKey, keys, length);
    // 数据初始化，空间未分配 配合使用 appendBytes
    NSMutableData *encryptData = [[NSMutableData alloc] initWithCapacity:length];
    // 获取字节指针
    const Byte *point = self.bytes;
    for (int i = 0; i < self.length; i++) {
        int l = i % length;                     // 算出当前位置字节，要和密钥的异或运算的密钥字节
        char c = cKey[l];
        Byte b = (Byte) ((point[i]) ^ c);       // 异或运算
        [encryptData appendBytes:&b length:1];  // 追加字节
    }
    return encryptData.copy;
}

@end
