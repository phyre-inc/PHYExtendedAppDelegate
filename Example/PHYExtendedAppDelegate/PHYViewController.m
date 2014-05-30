//
//  PHYViewController.m
//  PHYExtendedAppDelegate
//
//  Created by Matt Ricketson on 4/9/14.
//  Copyright (c) 2014 Phyre Inc. All rights reserved.
//

#import "PHYViewController.h"
#import "PHYAppDelegate.h"

@implementation PHYViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /// Attempt to register for push notifications
    UIRemoteNotificationType types = UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge;
    
    [[PHYAppDelegate sharedDelegate] registerForRemoteNotificationTypes:types success:^(NSData *deviceToken) {
        NSLog(@"Successfully registered for push notifications with deviceToken %@", deviceToken);
    } failure:^(NSError *error) {
        NSLog(@"Failed to register for push notifications. Error: %@", error);
    }];
}

@end
