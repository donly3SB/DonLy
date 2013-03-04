//
//  AppDelegate.m
//  DonLy
//
//  Created by chen dianbo on 13-1-31.
//  Copyright (c) 2013年 chen dianbo. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "UIImageViewController.h"
#import <QuartzCore/CAAnimation.h>

@interface AppDelegate ()
@property(nonatomic, assign) UIViewId currViewId;
@property (strong, nonatomic) UINavigationController* naviController;

@property(strong, nonatomic) UIMainViewController*  mainViewController;
@property(strong, nonatomic) UIImageViewController* imageViewController;

- (void) switchViewByCoreAnimation;

@end

//--------------------------------------
@implementation AppDelegate
@synthesize currViewId;
@synthesize naviController;
@synthesize mainViewController;
@synthesize imageViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor clearColor];

    mainViewController = [[UIMainViewController alloc] init];
    self.naviController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    [naviController setNavigationBarHidden:YES];

    [self.window addSubview:naviController.view];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//
- (UIViewController*) viewById:(UIViewId) viewId
{
    if (EViewIdMain == viewId) {
        if (nil == mainViewController.view) {
            mainViewController = [[UIMainViewController alloc] init];
        }
        return mainViewController;
    }
    if (EViewIdImage == viewId) {
        if (nil == imageViewController.view) {
            imageViewController = [[UIImageViewController alloc] init];
        }
        return imageViewController;
    }
    return nil;
}

- (void) switchBackView
{
    [self switchViewByCoreAnimation];
    UIViewController* ctl = [naviController popViewControllerAnimated:NO];
    if (imageViewController == ctl) {
        [imageViewController release]; imageViewController = nil;
    }
    if (mainViewController == [naviController topViewController]) {
        [mainViewController refreshData];
    }
}

- (void) switchToView:(UIViewId) viewId
{
    UIViewController* desCtl = [self viewById:viewId];
    if (desCtl) {
        [self switchViewByCoreAnimation];
        [naviController pushViewController:desCtl animated:NO];
    }
}

#pragma mark Core Animation
- (void) switchViewByCoreAnimation
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.4;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    animation.removedOnCompletion = YES;

    [naviController.view.layer addAnimation:animation forKey:@"animation"];
}

@end
