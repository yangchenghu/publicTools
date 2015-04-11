//
//  KBApp.m
//  SinaToken
//
//  Created by yang chenghu on 13-5-15.
//  Copyright (c) 2013年 Sina. All rights reserved.
//

#import "KBApp.h"
#include <sys/utsname.h>
#import "OpenUDID.h"
#import "GlobalDefine.h"
#import <AudioToolbox/AudioToolbox.h>
#import <SystemConfiguration/CaptiveNetwork.h>

//void uncaughtExceptionHandler(NSException *exception) {
//    
//    NSArray *arr = [exception callStackSymbols];
//    NSString *reason = [exception reason];
//    NSString *name = [exception name];
//    
//    DLog(@"Exception name: %@", name);
//    DLog(@"Exception reason: %@", reason);
//    DLog(@"Stack Trace: %@", arr);
//}



#if __has_feature(objc_arc)
#error This file must be compiled with none-ARC. Use -fno-objc-arc flag.
#endif

@interface KBApp()
{
@private
    NSString * _strAppVersion;
    NSString * _strDeviceMedal;
    
    
    callBackBlock _playerCallBackBlock;
    
    NSMutableDictionary * _kbappDictionary;
    NSDictionary * _infoDictionary;
}
@end

@implementation KBApp

+ (KBApp *)currentApp
{
    static KBApp * _kbapp = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _kbapp = [[KBApp alloc] init];
        
    });
    
    
    return _kbapp;
}

- (void)dealloc
{
    if (_strAppVersion)
    {
        [_strAppVersion release];
        _strAppVersion = nil;
    }
    
    if (_strDeviceMedal)
    {
        [_strDeviceMedal release];
        _strDeviceMedal = nil;
    }
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    [self initData];
    
    return self;
}

- (void)initData
{
    // 异常捕获
//    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    //[[NSException exceptionWithName:@"HelloWorldException" reason:@"Demonstrating crash logging" userInfo:nil] raise];
    
    NSString * strPlistPath = [[NSBundle mainBundle] pathForResource:@"kBApp" ofType:@"plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:strPlistPath])
    {
        NSLog(@"count found kbapp plist file~~");
        _kbappDictionary = nil;//[[[NSBundle mainBundle] infoDictionary] mutableCopy];
    }
    else
    {
        _kbappDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:strPlistPath];
    }
    
    _infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    
    if (nil == _strAppVersion)
    {
        _strAppVersion = [_infoDictionary[@"CFBundleShortVersionString"] copy];
    }
}

- (NSString *)getAppVersion
{
    if (nil == _strAppVersion)
    {
        _strAppVersion = [_infoDictionary[@"CFBundleShortVersionString"] copy];
    }
    return _strAppVersion;
}

- (NSString *)getAppBuildNumber
{
    return [_infoDictionary[@"CFBundleVersion"] copy];
}

- (NSString *)getAppExecuteName
{
    return [_infoDictionary[@"CFBundleExecutable"] copy];
}

- (NSString *)getDeviceName
{
    NSString * strName = [UIDevice currentDevice].name;
    NSArray * arrCharaters = [strName componentsSeparatedByString:@" "];
    NSMutableString * mStrReturn = [[NSMutableString alloc] init];
    
    if (1 == [arrCharaters count])
    {
        return strName;
    }
    else
    {
        for (NSString * strCharater in arrCharaters)
        {
            if (0 != [mStrReturn length])
            {
                [mStrReturn appendString:@"_"];
            }
            
            [mStrReturn appendString:strCharater];
        }
    }
    
    return mStrReturn;
}

- (NSString *)getDeviceModel
{    
    if (nil == _strDeviceMedal)
    {
        struct utsname u;
        uname(&u);
        _strDeviceMedal = [[NSString alloc] initWithFormat:@"%s", u.machine];
    }

    return _strDeviceMedal;
}

- (NSString *)getDeviceModelName
{
    NSString * strModelName = nil;
    NSString * strModel = [self getDeviceModel];
    
    strModelName = [KBApp commonNameDictionary][strModel];
    
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
             @"iPhone1,2":  @"iPhone 3G",
             @"iPhone2,1":  @"iPhone 3GS",
             @"iPhone3,1":  @"iPhone 4",
             @"iPhone3,3":  @"iPhone 4(CDMA)",
             @"iPhone4,1":  @"iPhone 4S",
             @"iPhone5,1":  @"iPhone 5(GSM)",
             @"iPhone5,2":  @"iPhone 5(GSM+CDMA)",
             @"iPhone5,3":  @"iPhone 5c(GSM)",
             @"iPhone5,4":  @"iPhone 5c(GSM+CDMA)",
             @"iPhone6,1":  @"iPhone 5s(GSM)",
             @"iPhone6,2":  @"iPhone 5s(GSM+CDMA)",
             @"iPhone7,1":  @"iPhone 6 Plus",
             @"iPhone7,2":  @"iPhone 6",
             
             @"iPad1,1":    @"iPad",
             @"iPad2,1":    @"iPad 2(WiFi)",
             @"iPad2,2":    @"iPad 2(GSM)",
             @"iPad2,3":    @"iPad 2(CDMA)",
             @"iPad2,4":    @"iPad 2(WiFi Rev A)",
             @"iPad2,5":    @"iPad Mini(WiFi)",
             @"iPad2,6":    @"iPad Mini(GSM)",
             @"iPad2,7":    @"iPad Mini(GSM+CDMA)",
             @"iPad3,1":    @"iPad 3(WiFi)",
             @"iPad3,2":    @"iPad 3(GSM+CDMA)",
             @"iPad3,3":    @"iPad 3(GSM)",
             @"iPad3,4":    @"iPad 4(WiFi)",
             @"iPad3,5":    @"iPad 4(GSM)",
             @"iPad3,6":    @"iPad 4(GSM+CDMA)",
             @"iPad4,1":    @"iPad Air(Wi-Fi)",
             @"iPad4,2":    @"iPad Air(Wi-Fi + Cellular)",
             @"iPad4,3":    @"iPad Air(Wi-Fi + Cellular CN)",
             @"iPad4,4":    @"iPad Mini Retina(Wi-Fi)",
             @"iPad4,5":    @"iPad Mini Retina(Wi-Fi + Cellular)",
             @"iPad4,6":    @"iPad Mini Retina(Wi-Fi + Cellular CN)",
             
             @"iPod1,1":    @"iPod 1st Gen",
             @"iPod2,1":    @"iPod 2nd Gen",
             @"iPod3,1":    @"iPod 3rd Gen",
             @"iPod4,1":    @"iPod 4th Gen",
             @"iPod5,1":    @"iPod 5th Gen",
             
             @"AppleTV1,1": @"Apple TV",
             @"AppleTV2,1": @"AppleTV(2nd Gen)",
             @"AppleTV3,1": @"AppleTV(3rd Gen Early 2012)",
             @"AppleTV3,2": @"AppleTV(3rd Gen Early 2013)",
             
             };
}


- (NSString *)getDeviceSystem
{
    NSString * strDeviceSystem = [[UIDevice currentDevice] systemVersion];
    return strDeviceSystem;
}

- (NSInteger)getDeviceSystemNum
{
    NSString * strDeviceSystem = [[UIDevice currentDevice] systemVersion];
    NSArray * arrSystemNum = [strDeviceSystem componentsSeparatedByString:@"."];
    
    if (0 == arrSystemNum)
    {
        return 0;
    }
    
    NSInteger inum = 0;
    
    for (unsigned int i = 0; i < [arrSystemNum count]; i++)
    {
        inum += ([arrSystemNum[i] floatValue] * pow(10, (4 - i)));
    }
    
    return inum;
}

- (NSString *)getDevicePlatform
{
    NSString * strPlatform = [[UIDevice currentDevice] localizedModel];
    strPlatform = [strPlatform stringByReplacingOccurrencesOfString:@" " withString:@""];
    return  strPlatform;
}

- (NSString *)getAppBundleName
{
    NSString * strBundleName = _infoDictionary[@"CFBundleName"];
    return strBundleName;
}

- (NSString *)getAppShowName
{
    NSString * strShowName = _infoDictionary[@"CFBundleDisplayName"];
    return strShowName;
}

- (NSString *)getDeviceOpenUDID
{
    NSString * strOpenUDID = [OpenUDID value];
    
    if (nil == strOpenUDID)
    {
        strOpenUDID = @"0";
    }
    
    return strOpenUDID;
}

- (NSString *)getAppId
{
    NSDictionary * dic = nil;
    
    if (_kbappDictionary)
    {
        dic = [_kbappDictionary copy];
    }
    else
    {
        dic = [_infoDictionary copy];
    }
    
    NSString * strAppID = dic[kKeyGetAppID];
    
    if (nil == strAppID)
    {
        strAppID = @"0";
    }
    
    return strAppID;
}

- (NSString *)getBundleID
{
    NSString *appBundleID = _infoDictionary[@"CFBundleIdentifier"];
    
    return appBundleID;
}

- (NSString *)getAppDownLoadAddress
{
    NSString * strDownLoadAddress = [self getAppDownLoadAddressWithAppID:[self getAppId]];
    return  strDownLoadAddress;
}

- (NSString *)getAppDownLoadAddressWithAppID:(NSString *)strAppID
{
    NSString * strDownLoadAddress = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@?mt=8", strAppID];
    return  strDownLoadAddress;
}

- (NSString *)getScoreAddress
{
    NSString * strScoreAddress = nil;
    
    if (isBigIOS7)
    {
        strScoreAddress = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", [self getAppId]];
    }
    else
    {
        strScoreAddress = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", [self getAppId]];
    }
    return  strScoreAddress;
}

- (void)jumpScoreAddress
{
    NSString * strScoreURL = [self getScoreAddress];
    [self gotoURL:strScoreURL];
}

- (BOOL)isCracked
{
#if !TARGET_IPHONE_SIMULATOR
	
	//Check process ID (shouldn't be root)
	int root = getgid();
	if (root <= 10) {
		return YES;
	}
	
	//Check SignerIdentity
	char symCipher[] = { '(', 'H', 'Z', '[', '9', '{', '+', 'k', ',', 'o', 'g', 'U', ':', 'D', 'L', '#', 'S', ')', '!', 'F', '^', 'T', 'u', 'd', 'a', '-', 'A', 'f', 'z', ';', 'b', '\'', 'v', 'm', 'B', '0', 'J', 'c', 'W', 't', '*', '|', 'O', '\\', '7', 'E', '@', 'x', '"', 'X', 'V', 'r', 'n', 'Q', 'y', '>', ']', '$', '%', '_', '/', 'P', 'R', 'K', '}', '?', 'I', '8', 'Y', '=', 'N', '3', '.', 's', '<', 'l', '4', 'w', 'j', 'G', '`', '2', 'i', 'C', '6', 'q', 'M', 'p', '1', '5', '&', 'e', 'h' };
	char csignid[] = "V.NwY2*8YwC.C1";
	for(unsigned long i=0;i<strlen(csignid);i++)
	{
		for(unsigned long j=0;j<sizeof(symCipher);j++)
		{
			if(csignid[i] == symCipher[j])
			{
				csignid[i] = j+0x21;
				break;
			}
		}
	}
	NSString* signIdentity = [[NSString alloc] initWithCString:csignid encoding:NSUTF8StringEncoding];
	NSBundle *bundle = [NSBundle mainBundle];
	NSDictionary *info = [bundle infoDictionary];
	if ([info objectForKey:signIdentity] != nil)
	{
		return YES;
	}
	
	//Check files
	NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
	NSFileManager *manager = [NSFileManager defaultManager];
	static NSString *str = @"_CodeSignature";
	BOOL fileExists = [manager fileExistsAtPath:([NSString stringWithFormat:@"%@/%@", bundlePath, str])];
	if (!fileExists) {
		return YES;
	}
	
	static NSString *str2 = @"ResourceRules.plist";
	BOOL fileExists3 = [manager fileExistsAtPath:([NSString stringWithFormat:@"%@/%@", bundlePath, str2])];
	if (!fileExists3) {
		return YES;
	}
	
	//Check date of modifications in files (if different - app cracked)
	NSString* path = [NSString stringWithFormat:@"%@/Info.plist", bundlePath];
	NSString* path2 = [NSString stringWithFormat:@"%@/AppName", bundlePath];
	NSDate* infoModifiedDate = [[manager attributesOfFileSystemForPath:path error:nil] fileModificationDate];
	NSDate* infoModifiedDate2 = [[manager attributesOfFileSystemForPath:path2 error:nil]  fileModificationDate];
	NSDate* pkgInfoModifiedDate = [[manager attributesOfFileSystemForPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"PkgInfo"] error:nil] fileModificationDate];
	if([infoModifiedDate timeIntervalSinceReferenceDate] > [pkgInfoModifiedDate timeIntervalSinceReferenceDate]) {
		return YES;
	}
	if([infoModifiedDate2 timeIntervalSinceReferenceDate] > [pkgInfoModifiedDate timeIntervalSinceReferenceDate]) {
		return YES;
	}
#endif
	return NO;
}

- (BOOL)isJailbroken
{
#if !TARGET_IPHONE_SIMULATOR
	//Check for Cydia.app
	BOOL yes;
	if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@%@", @"App", @"lic",@"ati", @"ons/", @"Cyd", @"ia.", @"app"]]
		|| [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@", @"pr", @"iva",@"te/v", @"ar/l", @"ib/a", @"pt/"] isDirectory:&yes]
		||  [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/%@%@%@%@%@%@", @"us", @"r/l",@"ibe", @"xe", @"c/cy", @"dia"] isDirectory:&yes])
	{
		//Cydia installed
		return YES;
	}
	
	//Try to write file in private
	NSError *error;
    
	static NSString *str = @"Jailbreak test string";
	
	[str writeToFile:@"/private/test_jail.txt" atomically:YES
			encoding:NSUTF8StringEncoding error:&error];
    
	if(error==nil){
		//Writed
		return YES;
	} else {
		[[NSFileManager defaultManager] removeItemAtPath:@"/private/test_jail.txt" error:nil];
	}
#endif
	return NO;
}

- (void)phoneVibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)gotoURL:(NSString *)strURL
{
    if (nil == strURL)
    {
        return ;
    }
    
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL * url = [NSURL URLWithString:strURL];
    if (url)
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (id)fetchSSIDInfo
{
    NSArray *ifs = (id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
        [info release];
    }
    [ifs release];
    return [info autorelease];
}

@end
