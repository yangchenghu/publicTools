//
//  NSString+Base64.h
//  SinaToken
//
//  Created by yangchenghu on 11/13/14.
//  Copyright (c) 2014 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Base64)


/**
 * @description base64加密
 * @param
 * @return
 */
- (NSString*)encodeBase64;

/**
 * @description base64解密
 * @param
 * @return
 */
- (NSString*)decodeBase64;

/**
 * @description 解密base64，出入解密方式
 * @param
 * @return
 */
- (NSString*)encodeBase64StringEncoding:(NSStringEncoding)encoding;

/**
 * @description 解密base64，可以传入string的编码方式
 * @param
 * @return
 */
- (NSString*)decodeBase64StringEncoding:(NSStringEncoding)encoding;


@end
