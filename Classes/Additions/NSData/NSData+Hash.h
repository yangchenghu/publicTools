//
//  NSData+Hash.h
//  
//
//  Created by yangchenghu on 13-10-23.
//  Copyright (c) 2013年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Hash)

- (NSData *) md2;
- (NSData *) md4;
- (NSData *) md5;

- (NSData *) sha1;
- (NSData *) sha224;
- (NSData *) sha256;
- (NSData *) sha384;
- (NSData *) sha512;


- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密

@end