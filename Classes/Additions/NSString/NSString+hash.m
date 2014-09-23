//
//  NSString+hash.m
//  
//
//  Created by yangchenghu on 13-12-17.
//  Copyright (c) 2013年 Sina. All rights reserved.
//

#import "NSString+hash.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"

@implementation NSString (hash)

NSString * shaSign(const char *string, const NSUInteger length);
NSString * sha1(const char *string);


static inline void hexString(unsigned char *from, char *to, NSUInteger length)
{
    for (NSUInteger i = 0; i < length; ++i) {
        unsigned char c = from[i];
        unsigned char cHigh = c >> 4;
        unsigned char cLow = c & 0xf;
        to[2 * i] = hexChar(cHigh);
        to[2 * i + 1] = hexChar(cLow);
    }
    to[2 * length] = '\0';
}

static inline char hexChar(unsigned char c)
{
    return c < 10 ? '0' + c : 'a' + c - 10;
}

NSString * sha1(const char *string)
{
    static const NSUInteger LENGTH = CC_SHA1_DIGEST_LENGTH;
    unsigned char result[LENGTH];
    CC_SHA1(string, (CC_LONG)strlen(string), result);
    
    char hexResult[2 * LENGTH + 1];
    hexString(result, hexResult, LENGTH);
    
    return [NSString stringWithUTF8String:hexResult];
}

- (NSString *)getMd5_16Bit_String
{
    //提取32位MD5散列的中间16位
    NSString *md5_32Bit_String = [self getMd5_32Bit_String];
    NSString *result = [[md5_32Bit_String substringToIndex:24] substringFromIndex:8];//即9～25位
    
    return result;
}

//32位MD5加密方式
- (NSString *)getMd5_32Bit_String
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}


- (NSString *)getSha1String
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

- (NSString *)getSha256String
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

//sha384加密方式
- (NSString *)getSha384String
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA384_DIGEST_LENGTH];
    
    CC_SHA384(data.bytes, data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++)
    {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

//sha512加密方式
- (NSString*)getSha512String
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512(data.bytes, data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
    {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

- (NSString*)encodeBase64
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

- (NSString*)decodeBase64
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}




@end
