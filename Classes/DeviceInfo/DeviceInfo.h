//
//  DeviceInfo.h
//  SinaToken
//
//  Created by yangchenghu on 11/21/14.
//  Copyright (c) 2014 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>


@interface DeviceInfo : NSObject


/**
 * @description 获取设备model
 * @param
 * @return
 */
+ (NSString *)getDeviceModel;

/**
 * @description 获取设备的model名称
 * @param
 * @return
 */
+ (NSString *)getDeviceModelName;

/**
 * @description 获取设备系统版本
 * @param
 * @return
 */
+ (NSString *)getDeviceSystem;

/**
 * @description 获取设备序列号
 * @param
 * @return
 */
+ (NSString *)getDeviceOpenUdid;

/**
 * @description 获取Wifi的SSID信息
 * @param
 * @return
 */
+ (NSDictionary *)getWifiSSIDInfo;



@end
