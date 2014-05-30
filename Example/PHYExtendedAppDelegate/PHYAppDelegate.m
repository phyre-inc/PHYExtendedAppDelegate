//
//  PHYAppDelegate.m
//  PHYExtendedAppDelegate
//
//  Created by Matt Ricketson on 4/9/14.
//  Copyright (c) 2014 Phyre Inc. All rights reserved.
//

#import "PHYAppDelegate.h"

@implementation PHYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /// Check if the app is running unit tests. If YES, return preemptively.
    if (PHYApplicationIsRunningTests()) {
        return YES;
    }
    
    /// If not running unit tests, perform normal app setup...
    
    return YES;
}

@end
