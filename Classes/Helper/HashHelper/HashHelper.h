//
//  HashHelper.h
//  Yoda
//
//  Created by yangchenghu on 12/6/14.
//  Copyright (c) 2014 BotPy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>

@interface HashHelper : NSObject


/**
 * @description Hmac 加密
 * @param
 * @return
 */
+ (NSString *)hmacWithAlgo:(CCHmacAlgorithm)algo string:(NSString *)string key:(NSString *)strKey;


@end
