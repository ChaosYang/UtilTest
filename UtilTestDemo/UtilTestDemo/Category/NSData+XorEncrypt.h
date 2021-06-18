//
//  NSData+XorEncrypt.h
//  iwown
//
//  Created by viatom on 2020/6/4.
//  Copyright © 2020 LP. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (XorEncrypt)
// 解密
- (NSData *)xor_decryptWithKey:(NSString *)key;
// 加密
- (NSData *)xor_encryptWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
