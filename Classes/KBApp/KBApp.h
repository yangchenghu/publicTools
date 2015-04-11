//
//  KBApp.h
//  SinaToken
//
//  Created by yang chenghu on 13-5-15.
//  Copyright (c) 2013年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>

#define isBigIOS7 ([[KBApp currentApp] getDeviceSystemNum] >= __IPHONE_7_0)

#define kKeyGetAppID     @"appIdInAppStore"

typedef void(^callBackBlock)(BOOL finish);


@interface KBApp : NSObject



+ (KBApp *)currentApp;

/**
 * @description 初始化
 * @param
 * @return
 */
- (void)initData;

/**
 * @description 获取应用的版本
 * @param
 * @return @"1.2.0"
 */
- (NSString *)getAppVersion;

/**
 * @description 获取build号
 * @param
 * @return
 */
- (NSString *)getAppBuildNumber;

/**
 * @description 获取执行文件的名称
 * @param
 * @return
 */
- (NSString *)getAppExecuteName;

/**
 * @description 获取设备名称
 * @param
 * @return
 */
- (NSString *)getDeviceName;

/**
 * @description 获取手机的model
 * @param
 * @return  @"iPhone5,1"
 */
- (NSString *)getDeviceModel;

/**
 * @description 获取DeviceModel 的名称
 * @param
 * @return
 */
- (NSString *)getDeviceModelName;

/**
 * @description 获取系统版本
 * @param
 * @return @"5.1.1"
 */
- (NSString *)getDeviceSystem;

/**
 * @description 获取系统版本
 * @param
 * @return 70000 可以跟 __IPHONE_5_0 进行比较
 */
- (NSInteger)getDeviceSystemNum;

/**
 * @description 获取设备平台信息
 * @param
 * @return @"iPod touch"
 */
- (NSString *)getDevicePlatform;

/**
 * @description 获取bundleName
 * @param
 * @return
 */
- (NSString *)getAppBundleName;

/**
 * @description 获取应用显示名称
 * @param
 * @return
 */

- (NSString *)getAppShowName;

/**
 * @description 获取系统唯一标示OpenUDID
 * @param
 * @return
 */
- (NSString *)getDeviceOpenUDID;

/**
 * @description 获取应用在app store 上的app id 需要手动添加到plist，key:appIdInAppStore
 * @param
 * @return
 */
- (NSString *)getAppId;

/**
 * @description 获取应用的Bundle ID
 * @param
 * @return
 */
- (NSString *)getBundleID;

/**
 * @description 获取下载地址，需要手动添加app id到plist
 * @param
 * @return
 */
- (NSString *)getAppDownLoadAddress;

/**
 * @description 获取下载地址
 * @param strAppID 输入app id
 * @return
 */
- (NSString *)getAppDownLoadAddressWithAppID:(NSString *)strAppID;

/**
 * @description 获取评论的地址，需要手动添加app id到plist
 * @param
 * @return
 */
- (NSString *)getScoreAddress;

/**
 * @description 跳转到应用的评分页面
 * @param
 * @return
 */
- (void)jumpScoreAddress;

/**
 * @description 检测应用是否被破解
 * @param
 * @return
 */
- (BOOL)isCracked;

/**
 * @description 检测设备是否越狱
 * @param
 * @return
 */
- (BOOL)isJailbroken;

/**
 * @description 手机震动
 * @param
 * @return
 */
- (void)phoneVibrate;

/**
 * @description 跳转URL
 * @param
 * @return
 */
- (void)gotoURL:(NSString *)strURL;

/**
 * @description 获取到wifi的ssid名称
 * @param
 * @return
 */
- (id)fetchSSIDInfo;

@end
