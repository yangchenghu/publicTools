//
//  NSString+hash.h
//
//
//  Created by yangchenghu on 13-12-17.
//  Copyright (c) 2013年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (hash)

/**
 * @description 16位的MD5加密方式
 * @param
 * @return
 */
- (NSString *)getMd5_16Bit_String;

/**
 * @description 32位的MD5加密
 * @param
 * @return
 */
- (NSString *)getMd5_32Bit_String;

/**
 * @description sha1加密
 * @param
 * @return
 */
- (NSString *)getSha1String;

/**
 * @description sha256加密
 * @param
 * @return
 */
- (NSString *)getSha256String;

/**
 * @description sha384加密
 * @param
 * @return
 */
- (NSString *)getSha384String;

/**
 * @description sha512加密
 * @param
 * @return
 */
- (NSString*)getSha512String;





@end
