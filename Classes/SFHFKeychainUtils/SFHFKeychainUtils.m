//
//  SFHFKeychainUtils.m
//
//  Created by Buzz Andersen on 10/20/08.
//  Based partly on code by Jonathan Wight, Jon Crosby, and Mike Malone.
//  Copyright 2008 Sci-Fi Hi-Fi. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC.
#endif

#import "SFHFKeychainUtils.h"
#import <Security/Security.h>

static NSString *SFHFKeychainUtilsErrorDomain = @"SFHFKeychainUtilsErrorDomain";

@implementation SFHFKeychainUtils

+ (NSString *) getPasswordForUsername: (NSString *) username
                       andServiceName: (NSString *) serviceName
                          accessGroup: (NSString *) accessGroup
                                error: (NSError **) error
{
	if (!username || !serviceName) {
		if (error != nil) {
			*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
		}
		return nil;
	}
	
	if (error != nil) {
		*error = nil;
	}
    
	// Set up a query dictionary with the base query attributes: item type (generic), username, and service
	
	NSArray *keys = [[NSArray alloc] initWithObjects: (__bridge NSString *) kSecClass, kSecAttrAccount, kSecAttrService, nil];
	NSArray *objects = [[NSArray alloc] initWithObjects: (__bridge NSString *) kSecClassGenericPassword, username, serviceName, nil];
	
	NSMutableDictionary *query = [[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys];
	
	// First do a query for attributes, in case we already have a Keychain item with no password data set.
	// One likely way such an incorrect item could have come about is due to the previous (incorrect)
	// version of this code (which set the password as a generic attribute instead of password data).
	
	NSMutableDictionary *attributeQuery = [query mutableCopy];
	[attributeQuery setObject: (id) kCFBooleanTrue forKey:(__bridge id) kSecReturnAttributes];
    
#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    if (accessGroup) {
        [attributeQuery setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    }
#endif
    
    CFTypeRef attrResult = NULL;
	OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef) attributeQuery, &attrResult);
	//NSDictionary *attributeResult = (__bridge_transfer NSDictionary *)attrResult;
    
	if (status != noErr) {
		// No existing item found--simply return nil for the password
		if (error != nil && status != errSecItemNotFound) {
			//Only return an error if a real exception happened--not simply for "not found."
			*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
		}
		
		return nil;
	}
	
	// We have an existing item, now query for the password data associated with it.
	
	NSMutableDictionary *passwordQuery = [query mutableCopy];
	[passwordQuery setObject: (id) kCFBooleanTrue forKey: (__bridge id) kSecReturnData];
    CFTypeRef resData = NULL;
	status = SecItemCopyMatching((__bridge CFDictionaryRef) passwordQuery, (CFTypeRef *) &resData);
	NSData *resultData = (__bridge NSData *)resData;
	
	if (status != noErr) {
		if (status == errSecItemNotFound) {
			// We found attributes for the item previously, but no password now, so return a special error.
			// Users of this API will probably want to detect this error and prompt the user to
			// re-enter their credentials.  When you attempt to store the re-entered credentials
			// using storeUsername:andPassword:forServiceName:updateExisting:error
			// the old, incorrect entry will be deleted and a new one with a properly encrypted
			// password will be added.
			if (error != nil) {
				*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -1999 userInfo: nil];
			}
		}
		else {
			// Something else went wrong. Simply return the normal Keychain API error code.
			if (error != nil) {
				*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
			}
		}
		
		return nil;
	}
    
	NSString *password = nil;	
    
	if (resultData) {
		password = [[NSString alloc] initWithData: resultData encoding: NSUTF8StringEncoding];
	}
	else {
		// There is an existing item, but we weren't able to get password data for it for some reason,
		// Possibly as a result of an item being incorrectly entered by the previous code.
		// Set the -1999 error so the code above us can prompt the user again.
		if (error != nil) {
			*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -1999 userInfo: nil];
		}
	}
    
	return password;
}

+ (BOOL) storeUsername: (NSString *) username
           andPassword: (NSString *) password
        forServiceName: (NSString *) serviceName
        updateExisting: (BOOL) updateExisting
           accessGroup: (NSString *) accessGroup
                 error: (NSError **) error
{
	if (!username || !password || !serviceName) 
    {
		if (error != nil) 
        {
			*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
		}
		return NO;
	}
	
	// See if we already have a password entered for these credentials.
	NSError *getError = nil;
	NSString *existingPassword = [SFHFKeychainUtils getPasswordForUsername: username andServiceName: serviceName accessGroup:nil error:&getError];
    
	if ([getError code] == -1999) 
    {
		// There is an existing entry without a password properly stored (possibly as a result of the previous incorrect version of this code.
		// Delete the existing item before moving on entering a correct one.
        
		getError = nil;
		
		[self deleteItemForUsername: username andServiceName: serviceName accessGroup:accessGroup  error: &getError];
        
		if ([getError code] != noErr) 
        {
			if (error != nil) 
            {
				*error = getError;
			}
			return NO;
		}
	}
	else if ([getError code] != noErr) 
    {
		if (error != nil) 
        {
			*error = getError;
		}
		return NO;
	}
	
	if (error != nil) 
    {
		*error = nil;
	}
	
	OSStatus status = noErr;
    
	if (existingPassword) 
    {
		// We have an existing, properly entered item with a password.
		// Update the existing item.
		
		if (![existingPassword isEqualToString:password] && updateExisting) 
        {
			//Only update if we're allowed to update existing.  If not, simply do nothing.
			
			NSArray *keys = [[NSArray alloc] initWithObjects: (__bridge NSString *) kSecClass,
                             kSecAttrService, 
                             kSecAttrLabel, 
                             kSecAttrAccount, 
                             nil];
			
			NSArray *objects = [[NSArray alloc] initWithObjects: (__bridge NSString *) kSecClassGenericPassword,
                                serviceName,
                                serviceName,
                                username,
                                nil];
			
			NSMutableDictionary *query = [[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys];
            
#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
            if (accessGroup) {
                [query setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
            }
#endif

			status = SecItemUpdate((__bridge CFDictionaryRef) query, (__bridge CFDictionaryRef) [NSDictionary dictionaryWithObject: [password dataUsingEncoding: NSUTF8StringEncoding] forKey: (__bridge NSString *) kSecValueData]);
		}
	}
	else 
    {
		// No existing entry (or an existing, improperly entered, and therefore now
		// deleted, entry).  Create a new entry.
		
		NSArray *keys = [[NSArray alloc] initWithObjects: (__bridge NSString *) kSecClass,
                         kSecAttrService, 
                         kSecAttrLabel, 
                         kSecAttrAccount, 
                         kSecValueData, 
                         nil];
		
		NSArray *objects = [[NSArray alloc] initWithObjects: (__bridge NSString *) kSecClassGenericPassword,
                            serviceName,
                            serviceName,
                            username,
                            [password dataUsingEncoding: NSUTF8StringEncoding],
                            nil];
		
		NSMutableDictionary *query = [[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys];
        
#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
        if (accessGroup) {
            [query setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
        }
#endif
        
		status = SecItemAdd((__bridge CFDictionaryRef) query, NULL);
	}
	
	if (error != nil && status != noErr) 
    {
		// Something went wrong with adding the new item. Return the Keychain error code.
		*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
        
        return NO;
	}
    
    return YES;
}

+ (BOOL) deleteItemForUsername: (NSString *) username
                andServiceName: (NSString *) serviceName
                   accessGroup: (NSString *) accessGroup
                         error: (NSError **) error
{
	if (!username || !serviceName) 
    {
		if (error != nil) 
        {
			*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
		}
		return NO;
	}
	
	if (error != nil) 
    {
		*error = nil;
	}
    
	NSArray *keys = [[NSArray alloc] initWithObjects: (__bridge NSString *) kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnAttributes, nil];
	NSArray *objects = [[NSArray alloc] initWithObjects: (__bridge NSString *) kSecClassGenericPassword, username, serviceName, kCFBooleanTrue, nil];
	
	NSMutableDictionary *query = [[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys];

#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    if (accessGroup) {
        [query setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    }
#endif
    
	OSStatus status = SecItemDelete((__bridge CFDictionaryRef) query);
	
	if (error != nil && status != noErr) 
    {
		*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];		
        
        return NO;
	}
    
    return YES;
}

+ (BOOL) clearItemsForServiceName: (NSString *) serviceName
                      accessGroup: (NSString *) accessGroup
                            error: (NSError **) error
{
    if (!serviceName) 
    {
		if (error != nil) 
        {
			*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
		}
		return NO;
	}
	
	if (error != nil) 
    {
		*error = nil;
	}
    
    NSMutableDictionary *searchData = [NSMutableDictionary new];
    [searchData setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [searchData setObject:serviceName forKey:(__bridge id)kSecAttrService];

#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    if (accessGroup) {
        [searchData setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    }
#endif
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)searchData);

	if (error != nil && status != noErr) 
    {
		*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];		
        
        return NO;
	}
    
    return YES;
}

+ (NSArray *) getAllUserNamesFromServiceName: (NSString *) serviceName error: (NSError **) error
{
    if (!serviceName)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
        }
        return nil;
    }
    
    if (error != nil)
    {
        *error = nil;
    }
    
    // Set up a query dictionary with the base query attributes: item type (generic), username, and service
    
    NSArray *keys = [[NSArray alloc] initWithObjects: (__bridge NSString *) kSecClass, kSecAttrService, nil];
    NSArray *objects = [[NSArray alloc] initWithObjects: (__bridge NSString *) kSecClassGenericPassword, serviceName, nil];
    
    NSMutableDictionary *query = [[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys];
    
    // First do a query for attributes, in case we already have a Keychain item with no password data set.
    // One likely way such an incorrect item could have come about is due to the previous (incorrect)
    // version of this code (which set the password as a generic attribute instead of password data).
    
    CFTypeRef attributeResult = NULL;
    NSMutableDictionary *attributeQuery = [query mutableCopy];
    [attributeQuery setObject: (id) kCFBooleanTrue forKey:(__bridge id) kSecReturnAttributes];
    [attributeQuery setObject: (__bridge id) kSecMatchLimitAll forKey: (__bridge id)kSecMatchLimit];
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef) attributeQuery, (CFTypeRef *) &attributeResult);
    
    //    NSLog(@"attributeResult is:%@", attributeResult);
    
    if (status != noErr)
    {
        // No existing item found--simply return nil for the password
        if (error != nil && status != errSecItemNotFound)
        {
            //Only return an error if a real exception happened--not simply for "not found."
            *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
        }
        
        return nil;
    }
    
    if (!attributeResult)
    {
        return @[];
    }
    
    NSArray * arrlist = [(__bridge NSArray *)attributeResult copy];
    
    NSMutableArray * mArrCountList = [[NSMutableArray alloc] initWithCapacity:[arrlist count]];
    
    for (NSDictionary * dicItem in arrlist)
    {
        [mArrCountList addObject:dicItem[@"acct"]];
    }
    
    return mArrCountList;
}

+ (NSArray *) getAllServerNameserror: (NSError **) error
{
    if (error != nil)
    {
        *error = nil;
    }
    
    // Set up a query dictionary with the base query attributes: item type (generic), username, and service
    
    NSArray *keys = [[NSArray alloc] initWithObjects: (__bridge NSString *) kSecClass, nil];
    NSArray *objects = [[NSArray alloc] initWithObjects: (__bridge  NSString *) kSecClassGenericPassword, nil];
    
    NSMutableDictionary *query = [[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys];
    
    // First do a query for attributes, in case we already have a Keychain item with no password data set.
    // One likely way such an incorrect item could have come about is due to the previous (incorrect)
    // version of this code (which set the password as a generic attribute instead of password data).
    
    CFTypeRef attributeResult = NULL;
    NSMutableDictionary *attributeQuery = [query mutableCopy];
    [attributeQuery setObject: (id) kCFBooleanTrue forKey:(__bridge id) kSecReturnAttributes];
    [attributeQuery setObject: (__bridge id) kSecMatchLimitAll forKey: (__bridge id)kSecMatchLimit];
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef) attributeQuery, (CFTypeRef *) &attributeResult);
    
    //    NSLog(@"attributeResult is:%@", attributeResult);
    
    if (status != noErr)
    {
        // No existing item found--simply return nil for the password
        if (error != nil && status != errSecItemNotFound) {
            //Only return an error if a real exception happened--not simply for "not found."
            *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
        }
        
        return nil;
    }
    
    if (!attributeResult)
    {
        return @[];
    }
    
    NSArray * arrlist = [(__bridge NSArray *)attributeResult copy];
    
    NSMutableSet * mSetServerNames = [[NSMutableSet alloc] init];
    
    
    for (NSDictionary * dicItem in arrlist)
    {
        if ([mSetServerNames containsObject:dicItem[@"svce"]] )
        {
            
        }
        
        [mSetServerNames addObject:dicItem[@"svce"]];
    }
    
    return [mSetServerNames allObjects];
}


// returns your bundle seed ID.
// This is the Apple generated ID that all your apps get prefixed with. e.g. 12345ABCDE.MyApp
// For newly created apps this is most likely your Team ID; for old apps it will probably be something else.
// This can be checked in the developer center under App Identifiers; it's the _Prefix_ of your App ID,
// _not_ any part of your Bundle ID.
// Your Bundle ID is irrelevant to shared keychain access.
+ (NSString *) bundleSeedID
{
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)(kSecClassGenericPassword), kSecClass,
                           @"bundleSeedID", kSecAttrAccount,
                           @"", kSecAttrService,
                           (id)kCFBooleanTrue, kSecReturnAttributes,
                           nil];
    CFDictionaryRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecItemNotFound)
        status = SecItemAdd((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status != errSecSuccess)
        return nil;
    NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge id)(kSecAttrAccessGroup)];
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    NSString *bundleSeedID = [[components objectEnumerator] nextObject];
    CFRelease(result);
    return bundleSeedID;
}


@end