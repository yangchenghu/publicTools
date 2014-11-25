//
//  NSString+RC4.m
//  SinaToken
//
//  Created by yangchenghu on 11/13/14.
//  Copyright (c) 2014 Sina. All rights reserved.
//

#import "NSString+RC4.h"
#import "NSString+hash.h"
#import "NSString+Base64.h"

@implementation NSString(RC4)

- (NSString *)RC4WithKey:(NSString *)strKey
{
    NSMutableArray *box = [NSMutableArray arrayWithCapacity:256];
    NSMutableArray *rndkey = [NSMutableArray arrayWithCapacity:256];
    
    for (int i = 0; i < 256; i++)
    {
        UniChar c = [strKey characterAtIndex:(i % strKey.length)];
        [rndkey addObject:@(c)];
        
        [box addObject:@(i)];
    }
    
    for (int i = 0 , j = 0; i < 256; i++)
    {
        j = (j + [box[i] intValue] + [rndkey[i] intValue]) % 256;
        NSNumber *temp = box[i];
        [box replaceObjectAtIndex:i withObject:box[j]];
        [box replaceObjectAtIndex:j withObject:temp];
    }
    
    NSMutableString *result = [NSMutableString string];
    
    for (int i = 0, a = 0 , j = 0; i < self.length; i++)
    {
        a = (a + 1) % 256;
        j = (j + [box[a] intValue]) % 256;//$j = ($j + $box [$a]) % 256;
        
        NSNumber * temp = box[a];
        box[a] = box[j];
        box[j] = temp;
        
        int iY = [box[([box[a] intValue] + [box[j] intValue]) % 256] intValue];
        
        UniChar ch = (UniChar)[self characterAtIndex:i];
        UniChar ch_y = ch^iY;
        
        [result appendString:[NSString stringWithCharacters:&ch_y length:1]];
    }    
    return result;
}

- (NSString *)extEncodeRC4Key:(NSString *)strKey expireTime:(NSInteger)iTime
{
    if (0 != iTime) {
        iTime = [[NSDate date] timeIntervalSince1970] + iTime;
    }
    
    strKey = [strKey getMd5_32Bit_String];
    NSString * strExpireTime = [NSString stringWithFormat:@"%010ld", (long)iTime];
    NSString * strTemp = [NSString stringWithFormat:@"%@%@%@", self, strKey, strExpireTime];
    
    strTemp = [strTemp getMd5_32Bit_String];
    strTemp = [strTemp substringToIndex:8];
    strTemp = [NSString stringWithFormat:@"%@%@%@", strTemp, strExpireTime, self];
    strTemp = [strTemp RC4WithKey:strKey];
    
    NSString * strEncodeBase64 = [strTemp encodeBase64StringEncoding:NSISOLatin1StringEncoding];
    NSMutableString * mStrEncode = [strEncodeBase64 mutableCopy];
    
    [mStrEncode replaceOccurrencesOfString:@"=" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, mStrEncode.length)];
    
    [mStrEncode replaceOccurrencesOfString:@"+" withString:@"_" options:NSLiteralSearch range:NSMakeRange(0, mStrEncode.length)];
    
    [mStrEncode replaceOccurrencesOfString:@"/" withString:@"-" options:NSLiteralSearch range:NSMakeRange(0, mStrEncode.length)];
    
    return [mStrEncode copy];
}

- (NSString *)extDecodeRC4Key:(NSString *)strKey expireTime:(NSInteger)iTime
{
    strKey = [strKey getMd5_32Bit_String];
    
    NSMutableString * mStrEncode = [self mutableCopy];
    
    [mStrEncode replaceOccurrencesOfString:@"_" withString:@"+" options:NSLiteralSearch range:NSMakeRange(0, mStrEncode.length)];
    
    [mStrEncode replaceOccurrencesOfString:@"-" withString:@"/" options:NSLiteralSearch range:NSMakeRange(0, mStrEncode.length)];
    
    int iNeedFill = ((mStrEncode.length * 3) % 4);
    
    for (int i = 0; i < iNeedFill; i++) {
        [mStrEncode appendString:@"="];
    }
    
    //NSISOLatin1StringEncoding
    NSString * strDecodeBase64 = [mStrEncode decodeBase64StringEncoding:NSISOLatin1StringEncoding];
    NSString * result = [strDecodeBase64 RC4WithKey:strKey];
    
    if (result.length < 8) {
        return @"";
    }
    
    NSString * strSig = [result substringToIndex:8];
    
    if (result.length < 18) {
        return @"";
    }
    
    NSString * strExpire = [result substringWithRange:NSMakeRange(8, 10)];
    
    NSTimeInterval fTime = [[NSDate date] timeIntervalSince1970];
    if ([strExpire integerValue] < fTime) {
        return @"";
    }
    
    NSString * strContent = [result substringFromIndex:18];
    
    NSString * strTemp = [NSString stringWithFormat:@"%@%@%@", strContent, strKey, strExpire];
    strTemp = [strTemp getMd5_32Bit_String];
    strTemp = [strTemp substringToIndex:8];
    if ([strTemp isEqual:strSig]) {
        return strContent;
    }
    
    return @"";
}




@end
