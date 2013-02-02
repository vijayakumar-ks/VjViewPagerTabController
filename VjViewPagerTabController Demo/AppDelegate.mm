//
//  AppDelegate.m
//  VjActionBarViewController Demo
//
//  Created by  on 28/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "VjViewPagerTabController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     
    self.viewController = [[VjViewPagerTabController alloc] init];
    
    FirstViewController *viewController1    = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    SecondViewController *viewController2   = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    ThirdViewController *viewController3    = [[ThirdViewController alloc] initWithNibName:@"ThirdViewController" bundle:nil];
    FourthViewController *viewController4   = [[FourthViewController alloc] initWithNibName:@"FourthViewController" bundle:nil];
    
    [self.viewController setActionBarImage:[UIImage imageNamed:@"ball.png"] withTitle:@"Tab 1" forViewController:viewController1];
    [self.viewController setActionBarImage:[UIImage imageNamed:@"book.png"] withTitle:@"Tab 2" forViewController:viewController2];
    [self.viewController setActionBarImage:[UIImage imageNamed:@"musicplayer.png"] withTitle:@"Tab 3" forViewController:viewController3];
    [self.viewController setActionBarImage:[UIImage imageNamed:@"tip.png"] withTitle:@"Tab 4" forViewController:viewController4];
    
    self.window.rootViewController          = self.viewController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
   // ApplicationWillTerminate
}

@end
