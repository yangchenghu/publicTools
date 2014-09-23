//
//  NSString+Additions.h
//  
//
//  Created by yangchenghu on 13-8-20.
//  Copyright (c) 2013年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)


/**
 * @description 判断字符串是否符合email格式，使用正则
 * @param
 * @return
 */
- (BOOL)isValidateEmail;

/**
 * @description 判断字符串是否符合email格式，使用字符串分割
 * @param
 * @return
 */
- (BOOL)validateEmail;

/**
 * @description 判断字符串是否符合手机号格式
 * @param
 * @return
 */
- (BOOL)isMobileNumber;

/**
 * @description 判断是否都是数字
 * @param
 * @return
 */
- (BOOL)isAllNumberCharacters;

/**
 * @description 判断是否都是英文字母
 * @param
 * @return
 */
- (BOOL)isEnglishCharacters;

/**
 * @description 判断已经输入的字符是否符合email的字符
 * @param
 * @return
 */
- (BOOL)isEmailCharacters;


@end
