// PHYExtendedAppDelegate.m
//
// Copyright (c) 2014 Phyre Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PHYExtendedAppDelegate.h"

@interface PHYExtendedAppDelegate ()
@property (nonatomic, copy) PHYRemoteNotificationRegistrationSuccesshandler remoteNotificationRegistrationSuccessHandler;
@property (nonatomic, copy) PHYRemoteNotificationRegistrationFailurehandler remoteNotificationRegistrationFailureHandler;
@end

@implementation PHYExtendedAppDelegate

#pragma mark - Shared Instance

+ (instancetype)sharedDelegate
{
	return [[UIApplication sharedApplication] delegate];
}


#pragma mark - Remote Notifications

- (void)registerForRemoteNotifications:(PHYRemoteNotificationRegistrationSuccesshandler)success
							   failure:(PHYRemoteNotificationRegistrationFailurehandler)failure
{
	[self registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)
									 success:success
									 failure:failure];
}

- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types
								   success:(PHYRemoteNotificationRegistrationSuccesshandler)success
								   failure:(PHYRemoteNotificationRegistrationFailurehandler)failure
{
	self.remoteNotificationRegistrationSuccessHandler = success;
	self.remoteNotificationRegistrationFailureHandler = failure;
	
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	if (self.remoteNotificationRegistrationSuccessHandler) {
		self.remoteNotificationRegistrationSuccessHandler(deviceToken);
	}
	
	self.remoteNotificationRegistrationSuccessHandler = nil;
	self.remoteNotificationRegistrationFailureHandler = nil;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	if (self.remoteNotificationRegistrationFailureHandler) {
		self.remoteNotificationRegistrationFailureHandler(error);
	}
	
	self.remoteNotificationRegistrationSuccessHandler = nil;
	self.remoteNotificationRegistrationFailureHandler = nil;
}


#pragma mark - Open URLs

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	NSDictionary *userInfo = @{
							   PHYExtendedAppDelegateURLSourceApplicationKey:	sourceApplication,
							   PHYExtendedAppDelegateURLAnnotationKey:          annotation,
							   PHYExtendedAppDelegateURLKey:                    url,
							   PHYExtendedAppDelegateURLQueryDataKey:           PHYURLQueryDictionaryRepresentation(url)
							   };
	
	[[NSNotificationCenter defaultCenter] postNotificationName:PHYExtendedAppDelegateDidOpenURLNotification object:application userInfo:userInfo];
	
	return YES;
}

@end



#pragma mark - Notifications

NSString * const PHYExtendedAppDelegateDidOpenURLNotification   = @"PHYExtendedAppDelegateDidOpenURLNotification";
NSString * const PHYExtendedAppDelegateURLSourceApplicationKey  = @"PHYExtendedAppDelegateURLSourceApplicationKey";
NSString * const PHYExtendedAppDelegateURLAnnotationKey         = @"PHYExtendedAppDelegateURLAnnotationKey";
NSString * const PHYExtendedAppDelegateURLKey                   = @"PHYExtendedAppDelegateURLKey";
NSString * const PHYExtendedAppDelegateURLQueryDataKey          = @"PHYExtendedAppDelegateURLQueryDataKey";


#pragma mark - Utility Functions

BOOL PHYApplicationIsRunningTests(void)
{
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *injectBundle = environment[@"XCInjectBundle"];
	NSString *injectBundlePathExtension = [injectBundle pathExtension];
    return [injectBundlePathExtension isEqualToString:@"xctest"];
}

NSDictionary * PHYURLQueryDictionaryRepresentation(NSURL *url)
{
    NSMutableDictionary *queryData = [NSMutableDictionary dictionary];
    NSArray *pairs = [[url query] componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [elements[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [elements[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        queryData[key] = val;
    }
	
    return [queryData copy];
}

NSString * PHYStringFromUIApplicationState(UIApplicationState appState)
{
	switch (appState) {
		case UIApplicationStateActive:      return @"UIApplicationStateActive";
		case UIApplicationStateInactive:    return @"UIApplicationStateInactive";
		case UIApplicationStateBackground:  return @"UIApplicationStateBackground";
	}
}
