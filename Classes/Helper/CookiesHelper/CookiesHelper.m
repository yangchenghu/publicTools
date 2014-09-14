//
//  CookiesHelper.m
//  
//
//  Created by yangchenghu on 13-11-11.
//  Copyright (c) 2013年 Sina. All rights reserved.
//

#import "CookiesHelper.h"
#import "GlobalDefine.h"

@implementation CookiesHelper

+ (void)showAllCookies
{
    NSHTTPCookieStorage *cookiestorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [cookiestorage cookies];
    
    NSHTTPCookie * cookie;
    
    for ( id c in cookies)
    {
        if ([c isKindOfClass:[NSHTTPCookie class]])
        {
            cookie = (NSHTTPCookie *)c;
            //if([cookie.name isEqualToString:@"CustomerID"])
            {
                DLog(@"cookie is:%@", [cookie properties]);
                
//                DLog(@"Cookiename = %@, Cookievalue = %@, url = %@", cookie.name, cookie.value, cookie.domain);
            }
        }
    }
}

+ (NSString *)getCookiesValueWithName:(NSString *)strName domain:(NSString *)strDomain
{
    NSHTTPCookieStorage *cookiestorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [cookiestorage cookies];
    
    NSHTTPCookie * cookie;
    
    NSString * strValue = nil;
    
    for ( id c in cookies)
    {
        if ([c isKindOfClass:[NSHTTPCookie class]])
        {
            cookie = (NSHTTPCookie *)c;
            if([strName isEqualToString:cookie.name] && [strDomain isEqualToString:cookie.domain])
            {
                strValue = [cookie.value copy];
                DLog(@"Cookiename = %@, Cookievalue = %@, url = %@", cookie.name, cookie.value, cookie.domain);
            }
        }
    }
    
    return strValue;
}

+ (NSArray *)getCookiesDictioarysnWithName:(NSString *)strName domain:(NSString *)strDomain
{
    NSHTTPCookieStorage *cookiestorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [cookiestorage cookies];
    
    NSMutableArray * mArrCookies = [[NSMutableArray alloc] init];
    
    NSHTTPCookie * cookie;
    
    for ( id c in cookies)
    {
        if ([c isKindOfClass:[NSHTTPCookie class]])
        {
            cookie = (NSHTTPCookie *)c;
            if([strName isEqualToString:cookie.name] && [strDomain isEqualToString:cookie.domain])
            {
                DLog(@"Cookiename = %@, Cookievalue = %@, url = %@", cookie.name, cookie.value, cookie.domain);
                
                [mArrCookies addObject:[cookie properties]];
            }
        }
    }
    
    return mArrCookies;
}


+ (void)clearCookiesWithURL:(NSString *)strURL
{
    NSHTTPCookieStorage *cookiestorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = nil;
    
    if (strURL)
    {
        NSURL * url = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        cookies = [cookiestorage cookiesForURL:url];
    }
    else
    {
        cookies = [cookiestorage cookies];
    }
    
    for ( id c in cookies)
    {
        NSHTTPCookie * cookie = (NSHTTPCookie *)c;
        
        [cookiestorage deleteCookie:cookie];
    }
}

+ (void)deleteCookieWithURL:(NSString *)strURL name:(NSString *)strName
{
    NSHTTPCookieStorage *cookiestorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = nil;
    
    if (strURL)
    {
        NSURL * url = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        cookies = [cookiestorage cookiesForURL:url];
    }
    else
    {
        cookies = [cookiestorage cookies];
    }
    
    for ( id c in cookies)
    {
        NSHTTPCookie * cookie = (NSHTTPCookie *)c;
        
        if ([strName isEqualToString:cookie.name])
        {
            [cookiestorage deleteCookie:cookie];
        }
    }
}


+ (void)deleteCookieWithDomain:(NSString *)strDomain name:(NSString *)strName
{
    NSHTTPCookieStorage *cookiestorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [cookiestorage cookies];
    
    for ( id c in cookies)
    {
        NSHTTPCookie * cookie = (NSHTTPCookie *)c;
        
        if ([strName isEqualToString:cookie.name] && [strDomain isEqualToString:cookie.domain])
        {
            [cookiestorage deleteCookie:cookie];
        }
    }
}

+ (void)clearCookiesWithDomain:(NSString *)strDomain
{
    if (nil == strDomain)
    {
        return;
    }
    
    NSHTTPCookieStorage *cookiestorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [cookiestorage cookies];
    
    for ( id c in cookies)
    {
        NSHTTPCookie * cookie = (NSHTTPCookie *)c;
        
        if ([strDomain isEqualToString:cookie.domain])
        {
            [cookiestorage deleteCookie:cookie];
        }
    }
}

+ (void)addCookies:(NSArray *)arrCookies
{
    for (NSDictionary * dicCookies in arrCookies)
    {
        NSHTTPCookie * cookie = [NSHTTPCookie cookieWithProperties:dicCookies];
        
        NSHTTPCookieStorage * cookiestorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

        [cookiestorage setCookie:cookie];
    }
}

@end
