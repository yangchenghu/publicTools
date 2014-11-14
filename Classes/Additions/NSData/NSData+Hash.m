//
//  NSData+Hash.m
//
//
//  Created by yangchenghu on 13-10-23.
//  Copyright (c) 2013年 Sina. All rights reserved.
//

#import "NSData+Hash.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


@implementation NSData (Hsah)

static NSData* digest(NSData *data, unsigned char* (*cc_digest)(const void*, CC_LONG, unsigned char*), CC_LONG digestLength)
{
	unsigned char md[digestLength];
	(void)cc_digest([data bytes], (CC_LONG)[data length], md);
	return [NSData dataWithBytes:md length:digestLength];
}

// MARK: Message-Digest Algorithm

- (NSData *) md2
{
	return digest(self, CC_MD2, CC_MD2_DIGEST_LENGTH);
}

- (NSData *) md4
{
	return digest(self, CC_MD4, CC_MD4_DIGEST_LENGTH);
}

- (NSData *) md5
{
	return digest(self, CC_MD5, CC_MD5_DIGEST_LENGTH);
}

// MARK: Secure Hash Algorithm

- (NSData *) sha1
{
	return digest(self, CC_SHA1, CC_SHA1_DIGEST_LENGTH);
}

- (NSData *) sha224
{
	return digest(self, CC_SHA224, CC_SHA224_DIGEST_LENGTH);
}

- (NSData *) sha256
{
	return digest(self, CC_SHA256, CC_SHA256_DIGEST_LENGTH);
}

- (NSData *) sha384
{
	return digest(self, CC_SHA384, CC_SHA384_DIGEST_LENGTH);
}

- (NSData *) sha512
{
	return digest(self, CC_SHA512, CC_SHA512_DIGEST_LENGTH);
}


- (NSData *)AES256EncryptWithKey:(NSString *)key   //加密
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}


- (NSData *)AES256DecryptWithKey:(NSString *)key   //解密
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

@end
