//
//  NSString+codec.m
//  HNZYiPad
//
//  Created by lilin on 13-6-14.
//  Copyright (c) 2013年 袁树峰. All rights reserved.
//

#import "NSString+codec.h"
#import "NSData+AES256.h"
#import "NSData+Base64.h"
@implementation NSString (codec)

- (NSString*)encryptedWithKey:(NSString*)key
{
    NSParameterAssert(key != nil && key.length > 0);
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData* e_aes256_data = [data AES256EncryptWithKey:key];
    return  [e_aes256_data base64EncodedString];
}

- (NSString*)decryptedWithKey:(NSString*)key
{
    NSParameterAssert(key != nil && key.length > 0);
    NSData* d_base64_data = [NSData dataFromBase64String:self];
    NSData* d_aes256_data = [d_base64_data AES256DecryptWithKey:key];
    return [[NSString alloc] initWithData:d_aes256_data encoding:NSUTF8StringEncoding];
}

- (NSString*)encrypted
{
    return [self encryptedWithKey:@"hngy"];
}

- (NSString*)decrypted
{
    return [self decryptedWithKey:@"hngy"];
}

- (NSString *)md5Encrypt
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (unsigned int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}
@end
