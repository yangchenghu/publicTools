//
//  NSString+RC4.h
//  SinaToken
//
//  Created by yangchenghu on 11/13/14.
//  Copyright (c) 2014 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(RC4)

/**
 * @description 使用rc4进行加密/解密
 * @param
 * @return
 */
- (NSString *)RC4WithKey:(NSString *)strKey;


/**
 * @description 扩展的rc4，添加过期时间
 * @param
 * @return
 */
- (NSString *)extEncodeRC4Key:(NSString *)strKey expireTime:(NSInteger)iTime;

/**
 * @description 扩展的rc4解密，带过期时间
 * @param
 * @return
 */
- (NSString *)extDecodeRC4Key:(NSString *)strKey expireTime:(NSInteger)iTime;


@end
