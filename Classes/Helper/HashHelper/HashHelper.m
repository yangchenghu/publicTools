//
//  HashHelper.m
//  Yoda
//
//  Created by yangchenghu on 12/6/14.
//  Copyright (c) 2014 BotPy. All rights reserved.
//

#import "HashHelper.h"


#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonCryptor.h>

@implementation HashHelper


+ (NSString *)hmacWithAlgo:(CCHmacAlgorithm)algo string:(NSString *)string key:(NSString *)strKey
{
    const char *cKey  = [strKey cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [string cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned int digest_len = 0;
    
    switch (algo) {
        case kCCHmacAlgSHA1:
            digest_len = CC_SHA1_DIGEST_LENGTH;
            break;
        case kCCHmacAlgMD5:
            digest_len = CC_MD5_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA256:
            digest_len = CC_SHA256_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA384:
            digest_len = CC_SHA384_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA512:
            digest_len = CC_SHA512_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA224:
            digest_len = CC_SHA224_DIGEST_LENGTH;
            break;
    }
    unsigned char cHMAC[digest_len];
    CCHmac(algo, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    char hash[2 * sizeof(cHMAC) + 1];
    for (size_t i = 0; i < sizeof(cHMAC); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(cHMAC[i]));
    }
    return [NSString stringWithUTF8String:hash];
}

@end
