//
//  CookiesHelper.h
//  
//
//  Created by yangchenghu on 13-11-11.
//  Copyright (c) 2013年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CookiesHelper : NSObject

/**
 * @description console输出所有cookies
 * @param
 * @return
 */
+ (void)showAllCookies;

/**
 * @description 读取cookies
 * @param
 * @return
 */
+ (NSString *)getCookiesValueWithName:(NSString *)strName domain:(NSString *)strDomain;

/**
 * @description 获取到name和domain的cookies的array
 * @param
 * @return
 */
+ (NSArray *)getCookiesDictioarysnWithName:(NSString *)strName domain:(NSString *)strDomain;

/**
 * @description 添加cookies到系统
 * @param
 * @return
 */
+ (void)addCookies:(NSArray *)arrCookies;

/**
 * @description 清理针对URL的所有cookies，如果url为nil，则清除所有
 * @param
 * @return
 */
+ (void)clearCookiesWithURL:(NSString *)strURL;

/**
 * @description 根据Domain来清除cookies
 * @param
 * @return
 */
+ (void)clearCookiesWithDomain:(NSString *)strDomain;

/**
 * @description 删除指定URL和name的cookie
 * @param
 * @return
 */
+ (void)deleteCookieWithURL:(NSString *)strURL name:(NSString *)strName;

/**
 * @description 根据domain和name来删除cookies
 * @param
 * @return
 */
+ (void)deleteCookieWithDomain:(NSString *)strDomain name:(NSString *)strName;

@end
