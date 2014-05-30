// PHYExtendedAppDelegate.h
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

#import <UIKit/UIKit.h>

typedef void(^PHYRemoteNotificationRegistrationSuccesshandler)(NSData *deviceToken);
typedef void(^PHYRemoteNotificationRegistrationFailurehandler)(NSError *error);


/**
 `PHYExtendedAppDelegate` is an app delegate superclass designed to improve the convenience of common app delegate tasks such as 
 remote notification registration and handling open URLs.
 
 To use `PHYExtendedAppDelegate`, simply declare it as the superclass of your project's existing `UIApplicationDelegate` instance.
 */
@interface PHYExtendedAppDelegate : UIResponder <UIApplicationDelegate>

///----------------------
/// @name Shared Instance
///----------------------

/// The delegate for the current application.
+ (instancetype)sharedDelegate;


///--------------------------------
/// @name User Interface Management
///--------------------------------

/// The application window.
@property (nonatomic, strong) UIWindow *window;


///------------------------------------
/// @name Handling Remote Notifications
///------------------------------------

/**
 Register to receive notifications of the specified types from a provider via Apple Push Service.
 
 @param success A block that is executed if registration is successful. Returns the APNs device token.
 @param failure A block that is executed if registration is unsuccessful. Returns an error explaining the issue.
 
 @see -registerForRemoteNotificationTypes:success:failure:
 */
- (void)registerForRemoteNotifications:(PHYRemoteNotificationRegistrationSuccesshandler)success
							   failure:(PHYRemoteNotificationRegistrationFailurehandler)failure;

/**
 Register to receive notifications of the specified types from a provider via Apple Push Service.
 
 @param types The specific remote notification types to register for.
 @param success A block that is executed if registration is successful. Returns the APNs device token.
 @param failure A block that is executed if registration is unsuccessful. Returns an error explaining the issue.
 */
- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types
								   success:(PHYRemoteNotificationRegistrationSuccesshandler)success
								   failure:(PHYRemoteNotificationRegistrationFailurehandler)failure;

@end


#pragma mark -

///--------------------
/// @name Notifications
///--------------------

/// Posted when the app delegate receives a URL via -application:openURL:sourceApplication:annotation:
extern NSString * const PHYExtendedAppDelegateDidOpenURLNotification;

/// The corresponding value is the `sourceApplication` provided by -application:openURL:sourceApplication:annotation:
extern NSString * const PHYExtendedAppDelegateURLSourceApplicationKey;

/// The corresponding value is the `annotation` provided by -application:openURL:sourceApplication:annotation:
extern NSString * const PHYExtendedAppDelegateURLAnnotationKey;

/// The corresponding value is the `url` provided by -application:openURL:sourceApplication:annotation:
extern NSString * const PHYExtendedAppDelegateURLKey;

/// The corresponding value is the dictionary representation of `url` query provided by -application:openURL:sourceApplication:annotation:
extern NSString * const PHYExtendedAppDelegateURLQueryDataKey;


///------------------------
/// @name Utility Functions
///------------------------

/**
 Checks if the current run of the application is for unit tests.
 
 @discussion
 This function is useful for conditionally setting up an application depending on whether or not unit tests are 
 running. For example, it is sometimes not desirable to initialize an app's normal user interface when running 
 unit tests.
 
 @return YES if the app launched for the purpose of running unit tests, NO if otherwise.
 */
BOOL PHYApplicationIsRunningTests(void) __attribute__((const));

/**
 Parses a query string into a dictionary of key/value pairs.
 
 @param url A URL with a query string.
 
 @return A dictionary containing the key/value pairs of the query string. If `[URL query]` returns `nil`, then an empty dictionary is returned.
 */
NSDictionary * PHYURLQueryDictionaryRepresentation(NSURL *url);

/**
 Provides a string representation of a `UIApplicationState` enum value. Useful for debugging purposes.
 
 @param appState A `UIApplicationState` enum value.
 
 @return An `NSString` representing the `UIApplicationState` enum value.
 */
NSString * PHYStringFromUIApplicationState(UIApplicationState appState);
