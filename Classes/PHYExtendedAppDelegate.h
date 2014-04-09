//
//  PHStandardAppDelegate.h
//  Rally
//
//  Created by Matt Ricketson on 11/25/13.
//  Copyright (c) 2013 Phyre. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const PHYAppDelegateDidOpenURLNotification;
extern NSString * const PHYAppDelegateDidOpenURLSourceApplicationKey;
extern NSString * const PHYAppDelegateDidOpenURLAnnotationKey;
extern NSString * const PHYAppDelegateDidOpenURLURLKey;
extern NSString * const PHYAppDelegateDidOpenURLQueryDataKey;

extern BOOL phy_isRunningTests(void) __attribute__((const));

typedef void(^PHYRemoteNotificationRegistrationSuccesshandler)(NSData *deviceToken);
typedef void(^PHYRemoteNotificationRegistrationFailurehandler)(NSError *error);



#pragma mark -

/**
 `PHAppDelegate` is an app delegate superclass designed to improve the convenience of common app delegate tasks such as remote notification registration.
 */
@interface PHYExtendedAppDelegate : UIResponder <UIApplicationDelegate>

///----------------------
/// @name Shared Instance
///----------------------

/// The delegate for the current application.
+ (instancetype)sharedDelegate;


///--------------------------
/// @name App Characteristics
///--------------------------

/// The application window.
@property (nonatomic, strong) UIWindow *window;


///------------------------------------
/// @name Handling Remote Notifications
///------------------------------------

- (void)registerForRemoteNotifications:(PHYRemoteNotificationRegistrationSuccesshandler)success
							   failure:(PHYRemoteNotificationRegistrationFailurehandler)failure;

- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types
								   success:(PHYRemoteNotificationRegistrationSuccesshandler)success
								   failure:(PHYRemoteNotificationRegistrationFailurehandler)failure;


///-------------------------
/// @name Handling Open URLs
///-------------------------

- (NSDictionary *)dictionaryForParsedQueryString:(NSString *)query;

@end



#pragma mark - UIApplication Extensions

extern NSString * NSStringFromUIApplicationState(UIApplicationState appState);
