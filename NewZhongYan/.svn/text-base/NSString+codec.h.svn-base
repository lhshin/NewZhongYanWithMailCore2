//
//  NSString+codec.h
//  HNZYiPad
//
//  Created by lilin on 13-6-14.
//  Copyright (c) 2013年 袁树峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
@interface NSString (codec)
/**
 * @return 经过md5 加密的字符串
 **/
- (NSString*)md5Encrypt;

/**
 * 将字符串进行AES256类型的解密
 * @param key  解密的钥匙
 * @return 加密后的字符串
 **/
- (NSString*)encryptedWithKey:(NSString*)key;

/**
 * 将字符串进行AES256类型的解密
 * @param key  解密的钥匙
 * @return 解密后的字符串
 **/
- (NSString*)decryptedWithKey:(NSString*)key;

/**
 * 将字符串进行AES256类型的解密
 * @return 加密后的字符串
 **/
- (NSString*)encrypted;

/**
 * 将字符串进行AES256类型的解密
 * @return 解密后的字符串
 **/
- (NSString*)decrypted;
@end
