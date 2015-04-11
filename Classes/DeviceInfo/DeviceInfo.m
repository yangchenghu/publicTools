//
//  DeviceInfo.m
//  SinaToken
//
//  Created by yangchenghu on 11/21/14.
//  Copyright (c) 2014 Sina. All rights reserved.
//

#import "DeviceInfo.h"
#import "OpenUDID.h"
#include <sys/utsname.h>
#import "SFHFKeychainUtils.h"


static NSString * sDeviceOpenUdid = @"openudid";
static NSString * sDeviceInfoName = @"com.sina.device.info";


@implementation DeviceInfo

+ (NSString *)getDeviceModel
{
    struct utsname u;
    uname(&u);
    NSString * strDeviceMedal = [[NSString alloc] initWithFormat:@"%s", u.machine];
    
    return strDeviceMedal;
}

+ (NSString *)getDeviceModelName
{
    NSString * strModelName = nil;
    NSString * strModel = [[self class] getDeviceModel];
    
    strModelName = [self commonNameDictionary][strModel];
    
    if (nil == strModelName)
    {
        strModelName = strModel;
    }
    
    return strModelName;
}

+ (NSDictionary *)commonNameDictionary
{
    return @{@"i386":     @"Simulator",
             @"x86_64":   @"Simulator",
             
             @"iPhone1,1":  @"iPhone",
             @"iPhone1,2":  @"iPhone_3G",
             @"iPhone2,1":  @"iPhone_3GS",
             @"iPhone3,1":  @"iPhone_4",
             @"iPhone3,3":  @"iPhone_4(CDMA)",
             @"iPhone4,1":  @"iPhone_4S",
             @"iPhone5,1":  @"iPhone_5(GSM)",
             @"iPhone5,2":  @"iPhone_5(GSM+CDMA)",
             @"iPhone5,3":  @"iPhone_5c(GSM)",
             @"iPhone5,4":  @"iPhone_5c(GSM+CDMA)",
             @"iPhone6,1":  @"iPhone_5s(GSM)",
             @"iPhone6,2":  @"iPhone_5s(GSM+CDMA)",
             @"iPhone7,1":  @"iPhone_6_Plus",
             @"iPhone7,2":  @"iPhone_6",
             
             @"iPad1,1":    @"iPad",
             @"iPad2,1":    @"iPad_2(WiFi)",
             @"iPad2,2":    @"iPad_2(GSM)",
             @"iPad2,3":    @"iPad_2(CDMA)",
             @"iPad2,4":    @"iPad_2(WiFi Rev A)",
             @"iPad2,5":    @"iPad_Mini(WiFi)",
             @"iPad2,6":    @"iPad_Mini(GSM)",
             @"iPad2,7":    @"iPad_Mini(GSM+CDMA)",
             @"iPad3,1":    @"iPad_3(WiFi)",
             @"iPad3,2":    @"iPad_3(GSM+CDMA)",
             @"iPad3,3":    @"iPad_3(GSM)",
             @"iPad3,4":    @"iPad_4(WiFi)",
             @"iPad3,5":    @"iPad_4(GSM)",
             @"iPad3,6":    @"iPad_4(GSM+CDMA)",
             @"iPad4,1":    @"iPad_Air(Wi-Fi)",
             @"iPad4,2":    @"iPad_Air(Wi-Fi+Cellular)",
             @"iPad4,3":    @"iPad_Air(Wi-Fi+Cellular_CN)",
             @"iPad4,4":    @"iPad_Mini_Retina(Wi-Fi)",
             @"iPad4,5":    @"iPad_Mini_Retina(Wi-Fi+Cellular)",
             @"iPad4,6":    @"iPad_Mini_Retina(Wi-Fi+Cellular_CN)",
             
             @"iPod1,1":    @"iPod_1st_Gen",
             @"iPod2,1":    @"iPod_2nd_Gen",
             @"iPod3,1":    @"iPod_3rd_Gen",
             @"iPod4,1":    @"iPod_4th_Gen",
             @"iPod5,1":    @"iPod_5th_Gen",
             
             @"AppleTV1,1": @"AppleTV",
             @"AppleTV2,1": @"AppleTV(2nd_Gen)",
             @"AppleTV3,1": @"AppleTV(3rd_Gen_Early_2012)",
             @"AppleTV3,2": @"AppleTV(3rd_Gen_Early_2013)",
             
             };
}

+ (NSString *)getDeviceSystem
{
    NSString * strDeviceSystem = [[UIDevice currentDevice] systemVersion];
    return strDeviceSystem;
}

+ (NSString *)getDeviceOpenUdid
{
    NSString * strUdid = [SFHFKeychainUtils getPasswordForUsername:sDeviceOpenUdid
                                                    andServiceName:sDeviceInfoName
                                                       accessGroup:nil
                                                             error:nil];
    
    if (nil == strUdid)
    {
        strUdid = [OpenUDID value];
        [SFHFKeychainUtils storeUsername:sDeviceOpenUdid andPassword:strUdid forServiceName:sDeviceInfoName updateExisting:YES accessGroup:nil error:nil];
    }
    
    return strUdid;
}

+ (NSDictionary *)getWifiSSIDInfo
{
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    DLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    return info;
}


@end
