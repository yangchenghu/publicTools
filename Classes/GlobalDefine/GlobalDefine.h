//
//  GlobalDefine.h
//
//
//  Created by yang chenghu on 13-5-9.
//  Copyright (c) 2013年  All rights reserved.
//



//__IPHONE_OS_VERSION_MIN_REQUIRED
//最小支持的系统版本号

//#import "iConsole.h"




//use ARC
//#if ! __has_feature(objc_arc)
//#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
//#endif

//user no-ARC
//#if __has_feature(objc_arc)
//#error This file must be compiled with none-ARC. Use -fno-objc-arc flag.
//#endif



//used
#define kAppDelegate  ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kUserDefault            [NSUserDefaults standardUserDefaults]
#define kNotificationCenter     [NSNotificationCenter defaultCenter]
#define kFileManeger            [NSFileManager defaultManager]
#define kApplication            [UIApplication sharedApplication]
#define kMainBundle             [NSBundle mainBundle]


#define IsEmpty(thing)  (thing == nil\
|| ([thing respondsToSelector:@selector(length)]\
    && [(NSData *)thing length] == 0)\
|| ([thing respondsToSelector:@selector(count)]\
    && [(NSArray *)thing count] == 0))


//
#define kBundleFilePath(name, type) [[NSBundle mainBundle] pathForResource:name ofType:type]

#ifndef MB_STRONG
#if __has_feature(objc_arc)
#define MB_STRONG strong
#else
#define MB_STRONG retain
#endif
#endif

#ifndef MB_WEAK
#if __has_feature(objc_arc_weak)
#define MB_WEAK weak
#elif __has_feature(objc_arc)
#define MB_WEAK unsafe_unretained
#else
#define MB_WEAK assign
#endif
#endif

//use dlog to print while in debug model

#ifdef DEBUG

#define DLog(fmt, ...)  NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)//;[iConsole log:fmt, ##__VA_ARGS__]
#define DELog(fmt, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String])

#define debug_pwd           printf("%s %d\n", __PRETTY_FUNCTION__, __LINE__)
#define debug_object( arg ) DLog( @"Object: %@", arg )
#define debug_int( arg )    DLog( @"integer: %i", arg )
#define debug_float( arg )  DLog( @"float: %f", arg )
#define debug_rect(arg)     DLog( @"CGRect ( %f, %f, %f, %f)", arg.origin.x, arg.origin.y, arg.size.width, arg.size.height )
#define debug_point( arg )  DLog( @"CGPoint ( %f, %f )", arg.x, arg.y )
#define debug_bool( arg )   DLog( @"Boolean: %@", ( arg == YES ? @"YES" : @"NO" ) )

#else

#ifdef SHOW_DEBUG

#define DLog(fmt, ...)  NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)//;[iConsole log:fmt, ##__VA_ARGS__]
#define DELog(fmt, ...) nil

#define debug_pwd           printf("%s %d\n", __PRETTY_FUNCTION__, __LINE__)
#define debug_object( arg ) DLog( @"Object: %@", arg )
#define debug_int( arg )    DLog( @"integer: %i", arg )
#define debug_float( arg )  DLog( @"float: %f", arg )
#define debug_rect(arg)     DLog( @"CGRect ( %f, %f, %f, %f)", arg.origin.x, arg.origin.y, arg.size.width, arg.size.height )
#define debug_point( arg )  DLog( @"CGPoint ( %f, %f )", arg.x, arg.y )
#define debug_bool( arg )   DLog( @"Boolean: %@", ( arg == YES ? @"YES" : @"NO" ) )

#else

#define DLog(...)  do { } while (0)
#define DELog(...) do { } while (0)

#define debug_pwd           nil
#define debug_object( arg ) nil
#define debug_int( arg )    nil
#define debug_float( arg )  nil
#define debug_rect(arg)     nil
#define debug_point( arg )  nil
#define debug_bool( arg )   nil

#endif

#endif


//change type
#define kBool2String(x) ( x ? @"YES" : @"NO" )



//color
#define kColorSameRGB(x) kColorRGB(x, x, x)
#define kColorRGB(R, G, B) [UIColor colorWithRed:(R / 255.0f) green:(G / 255.0f) blue:(B / 255.0f) alpha:1.0f]
#define kColorRGBA(R, G, B, A) [UIColor colorWithRed:(R / 255.0f) green:(G / 255.0f) blue:(B / 255.0f) alpha:A]


//iOS Device info

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)




//取消 ARC下 performselecter 的警告
//usage:
//    SuppressPerformSelectorLeakWarning(
//      [_target performSelector:_action withObject:self]
//    );
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


//view
#define kRoundViewRadius(v, c)  v.layer.cornerRadius = c;v.layer.masksToBounds = YES;

#define kViewChangeXYFromFrame(view, x, y) [view setFrame:CGRectMake((x), (y), CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))]

#define kViewChangeXFromFrame(view, x) [view setFrame:CGRectMake((x), view.frame.origin.y, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))]

#define kViewChangeYFromFrame(view, y) [view setFrame:CGRectMake(view.frame.origin.y, (y), CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))]

//string
#define kUTF8String(string) [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]


//math
#define kRadiansToAngle(x) ((x) * 180 / M_PI)
#define kAngleToRadians(x) ((x) * M_PI / 180)

#define kGetLeastIntBigerThanX(x)  ceil(x)
#define kGetBigestIntLessThanX(x)  floor(x)

//
#define NavigationBar_HEIGHT 44

#define TABBAR_HEIGHT        49

#define SCREEN_RECT  CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SAFE_RELEASE(x) if(nil != x){[x release];x=nil;}

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])

#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

#define BACKGROUND_COLOR [UIColor colorWithRed:(242.0/255.0f) green:(236.0/255.0f) blue:(231.0/255.0f) alpha:1.0f]





//file PATH

#define DOCUMENTS_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)objectAtIndex:0]

#define CACHES_PATH    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define LIBRARY_PATH   [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)  objectAtIndex:0]

#define TEMP_PATH      NSTemporaryDirectory()







#if TARGET_OS_IPHONE

//iPhone Device

#endif


#if TARGET_IPHONE_SIMULATOR

//iPhone Simulator

#endif



//ARC

#if __has_feature(objc_arc)

//compiling with ARC

#else

// compiling without ARC

#endif



//G－C－D

#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)



#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]


//load image with file eg. LOADIMAGE(@”backgournd”, @”png”);

#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

#define kUIImageStretchableImageInMiddle(Image) [Image stretchableImageWithLeftCapWidth:(Image.size.width / 2) topCapHeight:(Image.size.height / 2)]



//多语言

#define SelfLocal(x, ...) NSLocalizedString(x, nil)


#ifndef NS_ENUM

#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type

#endif


#pragma mark – common functions

#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }


//rgb颜色转换（16进制->10进制）
#define kUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#pragma mark – color functions

#define kRGBCOLOR(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]

#define kRGBACOLOR(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#pragma mark – degrees/radian functions

#define degreesToRadian(x) (M_PI * (x) / 180.0)

#define radianToDegrees(radian) (radian*180.0)/(M_PI)





#define ITTDEBUG

#define ITTLOGLEVEL_INFO     10

#define ITTLOGLEVEL_WARNING  3

#define ITTLOGLEVEL_ERROR    1



#ifndef ITTMAXLOGLEVEL


#ifdef DEBUG

#define ITTMAXLOGLEVEL ITTLOGLEVEL_INFO

#else

#define ITTMAXLOGLEVEL ITTLOGLEVEL_ERROR

#endif

#endif



// The general purpose logger. This ignores logging levels.

#ifdef ITTDEBUG

#define ITTDPRINT(xx, ...)  NSLog(@”%s(%d): ” xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#else

#define ITTDPRINT(xx, ...)  ((void)0)

#endif



// Prints the current method’s name.

#define ITTDPRINTMETHODNAME() ITTDPRINT(@”%s”, __PRETTY_FUNCTION__)



// Log-level based logging macros.

#if ITTLOGLEVEL_ERROR <= ITTMAXLOGLEVEL

#define ITTDERROR(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)

#else

#define ITTDERROR(xx, ...)  ((void)0)

#endif



#if ITTLOGLEVEL_WARNING <= ITTMAXLOGLEVEL

#define ITTDWARNING(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)

#else

#define ITTDWARNING(xx, ...)  ((void)0)

#endif



#if ITTLOGLEVEL_INFO <= ITTMAXLOGLEVEL

#define ITTDINFO(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)

#else

#define ITTDINFO(xx, ...)  ((void)0)

#endif



#ifdef ITTDEBUG

#define ITTDCONDITIONLOG(condition, xx, ...) { if ((condition)){ITTDPRINT(xx, ##__VA_ARGS__); }} ((void)0)

#else

#define ITTDCONDITIONLOG(condition, xx, ...) ((void)0)

#endif



#define ITTAssert(condition, ...)                                       \
do {                                                                     \
    if (!(condition)) {                                                     \
        [[NSAssertionHandler currentHandler]                                  \
         handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
         file:[NSString stringWithUTF8String:__FILE__]  \
         lineNumber:__LINE__                                  \
         description:__VA_ARGS__];                             \
