//
//  NSString+Base64.m
//  SinaToken
//
//  Created by yangchenghu on 11/13/14.
//  Copyright (c) 2014 Sina. All rights reserved.
//

#import "NSString+Base64.h"
#import "GTMBase64.h"

@implementation NSString(Base64)

- (NSString*)encodeBase64
{
    return [self encodeBase64StringEncoding:0];
}

- (NSString*)decodeBase64
{
    return [self decodeBase64StringEncoding:0];
}

//NSISOLatin1StringEncoding
- (NSString*)encodeBase64StringEncoding:(NSStringEncoding)encoding
{
    if (0 == encoding) {
        encoding = NSUTF8StringEncoding;
    }
    
    NSString *base64String = nil;
    NSData *data = [self dataUsingEncoding:encoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    if (data) {
        base64String = [[NSString alloc] initWithData:data encoding:encoding];
    }
    return base64String;
}

- (NSString*)decodeBase64StringEncoding:(NSStringEncoding)encoding
{
    if (0 == encoding) {
        encoding = NSUTF8StringEncoding;
    }
    NSString *base64String = nil;
    NSData *data = [self dataUsingEncoding:encoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    if (data) {
        base64String = [[NSString alloc] initWithData:data encoding:encoding];
    }
    
    return base64String;
}



@end
