//
//  AFNetworkingHelper.h
//
//
//  Created by yang chenghu on 13-5-30.
//  Copyright (c) 2013年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "AFNetworking.h"


typedef void (^successBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^failBlock)(AFHTTPRequestOperation *operation, NSError *error);

typedef void (^downloadProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);

@interface AFNetworkingHelper : NSObject
{
@private
    NSOperationQueue * _netOperationQueue;
    
}

//接收到的数据
@property (nonatomic, strong) NSMutableData * receivedData;
//添加到头部的字典
@property (nonatomic, strong) NSMutableDictionary * mDicHTTPRequestHeaders;
//在UA后面附加的字段
@property (nonatomic, strong) NSString * strAttachUA;
//ssl证书文件
@property (nonatomic, strong) NSData * sslCertificateData;
//ssl证书的ca证书文件
@property (nonatomic, strong) NSData * sslCACertificatieData;
//一组ssl证书的ca证书文件
@property (nonatomic, strong) NSArray * sslCACertificatieDatas;
//Basic Authentication(keys:username,password)
@property (nonatomic, strong) NSDictionary * dicBasicAuthentication;


/**
 * @description 监测网络连接状态
 * @param
 * @return YES - 有网络连接 NO - 无网络连接
 */
+ (BOOL)isNetworkReachable;

/**
 * @description 获取AFNetworkingHelper类单例
 * @param
 * @return
 */
+ (instancetype)sharedInstance;

/**
 * @description imageView获取图片
 * @param
 * @return
 */
- (void)getImageFromURL:(NSString *)strURL imageView:(UIImageView *)imageView;

/**
 * @description 通过url获取image
 * @param
 * @return
 */
- (void)getImageFromURL:(NSString *)strURL successBlock:(successBlock)success failBlock:(failBlock)fail;

/**
 * @description 通过POST的方法form
 * @param strRoot 接受请求的域名
 * @param strPath 接受请求的路径
 * @param arrCookies cookies
 * @param strUserAgent UserAgent
 * @param dicUserInfo UserInfo
 * @param success 发送成功后的回调block
 * @param fail 发送失败的回调block
 * @return
 */
- (NSUInteger)postData:(NSDictionary *)dicParamenters toRootURL:(NSString *)strRoot toPath:(NSString *)strPath cookies:(NSArray *)arrCookies userAgent:(NSString *)strUserAgent userInfo:(NSDictionary *)dicUserInfo successBlock:(successBlock)success failBlock:(failBlock)fail;

/**
 * @description 通过POST的方法form
 * @param strRoot 接受请求的域名
 * @param strPath 接受请求的路径
 * @param arrCookies cookies
 * @param strUserAgent UserAgent
 * @param dicUserInfo UserInfo
 * @param success 发送成功后的回调block
 * @param fail 发送失败的回调block
 * @return
 */
- (NSUInteger)postData:(NSDictionary *)dicParamenters toRootURL:(NSString *)strRoot toPath:(NSString *)strPath cookies:(NSArray *)dicCookies userInfo:(NSDictionary *)dicUserInfo successBlock:(successBlock)success failBlock:(failBlock)fail;

/**
 * @description post form 到URL
 * @param dicParamenters 要post的form
 * @param strRoot 接受请求的域名
 * @param strPath 接受请求的路径
 * @param dicUserInfo 连接的UserInfo
 * @param success 发送成功后的回调block
 * @param fail 发送失败的回调block
 * @return
 */
- (NSUInteger)postData:(NSDictionary *)dicParamenters toRootURL:(NSString *)strRoot toPath:(NSString *)strPath userInfo:(NSDictionary *)dicUserInfo successBlock:(successBlock)success failBlock:(failBlock)fail;

/**
 * @description 通过POST的方法form
 * @param strUrl 接受请求的域名
 * @param arrCookies cookies
 * @param strUserAgent UserAgent
 * @param dicUserInfo UserInfo
 * @param success 发送成功后的回调block
 * @param fail 发送失败的回调block
 * @return
 */
- (NSUInteger)postData:(NSDictionary *)dicParamenters toURL:(NSString *)strUrl cookies:(NSArray *)arrCookies userAgent:(NSString *)strUserAgent userInfo:(NSDictionary *)dicUserInfo successBlock:(successBlock)success failBlock:(failBlock)fail;

/**
 * @description 通过POST的方法form
 * @param strUrl 接受请求的域名
 * @param dicUserInfo UserInfo
 * @param success 发送成功后的回调block
 * @param fail 发送失败的回调block
 * @return
 */
- (NSUInteger)postData:(NSDictionary *)dicParamenters toURL:(NSString *)strUrl userInfo:(NSDictionary *)dicUserInfo  successBlock:(successBlock)success failBlock:(failBlock)fail;

/**
 * @description 通过GET的方法请求数据
 * @param strRoot 接受请求的域名
 * @param strPath 接受请求的路径
 * @param dicUserInfo 连接的UserInfo
 * @param success 发送成功后的回调block
 * @param fail 发送失败的回调block
 * @return
 */
- (NSUInteger)getRootURL:(NSString *)strRoot toPath:(NSString *)strPath userInfo:(NSDictionary *)dicUserInfo successBlock:(successBlock)success failBlock:(failBlock)fail;

/**
 * @description 通过GET的方法请求数据
 * @param strUrl 接受请求的URL
 * @param dicUserInfo 连接的UserInfo
 * @param success 发送成功后的回调block
 * @param fail 发送失败的回调block
 * @return
 */
- (NSUInteger)getURL:(NSString *)strUrl parameters:(NSDictionary *)dicParas userInfo:(NSDictionary *)dicUserInfo successBlock:(successBlock)success failBlock:(failBlock)fail;

/**
 * @description 同步访问URL
 * @param
 * @return
 */
- (void)synCallURL:(NSString *)urlString;

/**
 * @description 异步访问URL
 * @param
 * @return
 */
- (void)asynCallURL:(NSString *)urlString;

/**
 * @description 带进度回调的异步下载请求
 * @param
 * @return
 */
- (NSUInteger)downloadFileUrl:(NSString *)strUrl writefilePath:(NSString *)strPath userinfo:(NSDictionary *)dicUserInfo downloadProgressBlock:(downloadProgressBlock)progressblock completionBlock:(void(^)(void))completionBlock;

/**
 * @description 通过hash取消连接任务
 * @param
 * @return
 */
- (BOOL)cancelTaskWithConnectHash:(NSUInteger)iHash;

/**
 * @description 通过下载地址取消连接任务
 * @param
 * @return
 */
- (BOOL)cancelTaskWithConnectUrl:(NSString *)strUrl;


@end
