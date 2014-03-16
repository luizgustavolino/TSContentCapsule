//
//  TSAppDelegate.m
//  TSContentCapsule
//
//  Created by Labs on 3/15/14.
//  Copyright (c) 2014 Tsubasa. All rights reserved.
//

#import "TSAppDelegate.h"
#import "TSContentCapsuleManager.h"
#import "TSImageGridViewController.h"

@implementation TSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    // make a new window
    CGRect bounds   = [[UIScreen mainScreen] bounds];
    self.window     = [[[UIWindow alloc] initWithFrame:bounds] autorelease];
    
    // bootstrap content capsule with a pool of 10 threads
    [TSContentCapsuleManager bootstrapWithThreadCount:10];
    
    // make a grid view controller and set it as the root view controller for this window
    TSImageGridViewController *gridViewController = [[[TSImageGridViewController alloc] initWithNibName:@"TSImageGridViewController" bundle:nil] autorelease];
    [self.window setRootViewController:gridViewController];
    [self.window makeKeyAndVisible];
    
    // yes! it's done
    return YES;
    
}

- (void)dealloc{
    self.window = nil;
    [super dealloc];
}

@end
