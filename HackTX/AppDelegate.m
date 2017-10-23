//
//  AppDelegate.m
//  HackTX
//
//  Created by Jose Bethancourt on 8/31/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "AppDelegate.h"

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

@import Firebase;
@import FirebaseInstanceID;
@import FirebaseMessaging;
@import GoogleMaps;

#import "AnnouncementsViewController.h"
#import "CheckInViewController.h"
#import "MapViewController.h"
#import "ScheduleViewController.h"
#import "SponsorViewController.h"
#import "TwitterFeedViewController.h"
#import "HTXAPIKeyStore.h"
#import "UIColor+Palette.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate, FIRMessagingDelegate>
#endif

@property (nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Fabric with:@[[Crashlytics class]]];
    [GMSServices provideAPIKey:[[HTXAPIKeyStore sharedHTXAPIKeyStore] getGMSKey]];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
        #if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:authOptions
         completionHandler:^(BOOL granted, NSError * _Nullable error) {
         }
         ];
        
        // For iOS 10 display notification (sent via APNS)
        [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
//        [[FIRMessaging messaging] setRemoteMessageDelegate:self];
        #endif
    }
    
    [FIRApp configure];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    ScheduleViewController *vc1 = [[ScheduleViewController alloc] init];
    AnnouncementsViewController *vc2 = [[AnnouncementsViewController alloc] init];
    CheckInViewController *vc3 = [[CheckInViewController alloc] init];
    MapViewController *vc4 = [[MapViewController alloc] init];
    SponsorViewController *vc5 = [[SponsorViewController alloc] init];
    
    _tabBarController = [[UITabBarController alloc] init];
    _tabBarController.tabBar.translucent = NO;

    _tabBarController.viewControllers =  @[vc1, vc2, vc3, vc4, vc5];
    
    vc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Schedule" image:[UIImage imageNamed:@"icon_calendar"] selectedImage:nil];
    vc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Updates" image:[UIImage imageNamed:@"icon_bell"] selectedImage:nil];
    vc3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Check-In" image:[UIImage imageNamed:@"icon_profile"] selectedImage:nil];
    vc4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map" image:[UIImage imageNamed:@"icon_map"] selectedImage:nil];
    vc5.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Partners" image:[UIImage imageNamed:@"icon_heart"] selectedImage:nil];
    
    [[UITabBar appearance] setTintColor:[UIColor htx_red]];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:_tabBarController];
    
    UIImageView *headerImage = [[UIImageView alloc] init];
    headerImage.contentMode = UIViewContentModeScaleAspectFit;
    headerImage.frame = CGRectMake(0, 0, 38, 38);
    headerImage.image = [UIImage imageNamed:@"htx_logo"];
    
    navController.navigationBar.barTintColor = [UIColor htx17_darkBlue];
    navController.navigationBar.topItem.titleView = headerImage;
    navController.navigationBar.translucent = NO;
    
    _window.rootViewController = navController;
    [_window makeKeyAndVisible];
    
    if (launchOptions != nil) {
        // Launched from push notification
        NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if ([notification count] != 0) {
            [self.tabBarController setSelectedIndex:1];
        }
    }

    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //[AVOSCloud handleRemoteNotificationsWithDeviceToken:deviceToken];
    dispatch_queue_t myQueue = dispatch_queue_create("firebase_topics", NULL);
    
    dispatch_async(myQueue, ^{
        NSArray *topics = @[@"/topics/announcements", @"/topics/hacktx", @"/topics/ios", @"/topics/debug"];
        
        for (NSString *topic in topics) {
            [[FIRMessaging messaging] subscribeToTopic:topic];
            [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:4.0]];
        }

    });

}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    dispatch_queue_t myQueue = dispatch_queue_create("firebase_topics", NULL);
    
    dispatch_async(myQueue, ^{
        NSArray *topics = @[@"/topics/announcements", @"/topics/hacktx", @"/topics/ios", @"/topics/debug"];
        
        for (NSString *topic in topics) {
            [[FIRMessaging messaging] subscribeToTopic:topic];
            [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:4.0]];
        }
        
    });

}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
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
