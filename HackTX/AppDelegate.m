//
//  AppDelegate.m
//  HackTX
//
//  Created by Jose Bethancourt on 8/31/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "AppDelegate.h"

@import Firebase;

#import "AnnouncementsViewController.h"
#import "ProfileViewController.h"
#import "CountdownViewController.h"
#import "MapViewController.h"
#import "ScheduleViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [FIRApp configure];
    
    ScheduleViewController *vc1 = [[ScheduleViewController alloc] init];
    AnnouncementsViewController *vc2 = [[AnnouncementsViewController alloc] init];
    ProfileViewController *vc3 = [[ProfileViewController alloc] init];
    CountdownViewController *vc4 = [[CountdownViewController alloc] init];
    MapViewController *vc5 = [[MapViewController alloc] init];
    
    _tabBarController = [[UITabBarController alloc] init];
    _tabBarController.tabBar.translucent = NO;
    
    _tabBarController.viewControllers =  @[vc1, vc2, vc3, vc4, vc5];
    
    vc1.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Schedule" image:nil selectedImage:nil];
    vc2.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Announcements" image:nil selectedImage:nil];;
    vc3.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Profile" image:nil selectedImage:nil];;
    vc4.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Countdown" image:nil selectedImage:nil];;
    vc5.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Map" image:nil selectedImage:nil];;
    
    [[UITabBar appearance] setTintColor:[UIColor blueColor]];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController* navController = [[UINavigationController alloc]initWithRootViewController:_tabBarController];
    navController.navigationBar.tintColor = [UIColor greenColor];
//    navController.navigationBar.topItem.titleView = [[UIImageView alloc]initWithImage:
//                                                     [UIImage imageNamed:@"menlo_hacks_logo_blue_nav"]];
    navController.navigationBar.translucent = NO;
    _window.rootViewController = navController;
    [_window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
