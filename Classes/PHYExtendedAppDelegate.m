//
//  PHStandardAppDelegate.m
//  Rally
//
//  Created by Matt Ricketson on 11/25/13.
//  Copyright (c) 2013 Phyre. All rights reserved.
//

#import "PHYExtendedAppDelegate.h"

NSString * const PHYAppDelegateDidOpenURLNotification			= @"PHYAppDelegateDidOpenURLNotification";
NSString * const PHYAppDelegateDidOpenURLSourceApplicationKey	= @"PHYAppDelegateDidOpenURLSourceApplicationKey";
NSString * const PHYAppDelegateDidOpenURLAnnotationKey			= @"PHYAppDelegateDidOpenURLAnnotationKey";
NSString * const PHYAppDelegateDidOpenURLURLKey					= @"PHYAppDelegateDidOpenURLURLKey";
NSString * const PHYAppDelegateDidOpenURLQueryDataKey			= @"PHYAppDelegateDidOpenURLQueryDataKey";

BOOL phy_isRunningTests(void)
{
	NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *injectBundle = environment[@"XCInjectBundle"];
	NSString *injectBundlePathExtension = [injectBundle pathExtension];
    return [injectBundlePathExtension isEqualToString:@"xctest"];
}


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
							   PHYAppDelegateDidOpenURLSourceApplicationKey:	sourceApplication,
							   PHYAppDelegateDidOpenURLAnnotationKey:			annotation,
							   PHYAppDelegateDidOpenURLURLKey:					url,
							   PHYAppDelegateDidOpenURLQueryDataKey:			[self dictionaryForParsedQueryString:[url query]]
							   };
	
	[[NSNotificationCenter defaultCenter] postNotificationName:PHYAppDelegateDidOpenURLNotification object:self userInfo:userInfo];
	
	return YES;
}

- (NSDictionary *)dictionaryForParsedQueryString:(NSString *)query
{
    NSMutableDictionary *queryData = [NSMutableDictionary dictionary];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [elements[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [elements[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        queryData[key] = val;
    }
	
    return queryData;
}

@end



#pragma mark - UIApplication Extensions

NSString * NSStringFromUIApplicationState(UIApplicationState appState)
{
	switch (appState) {
		case UIApplicationStateActive:		return @"UIApplicationStateActive";
		case UIApplicationStateInactive:	return @"UIApplicationStateInactive";
		case UIApplicationStateBackground:	return @"UIApplicationStateBackground";
	}
}
