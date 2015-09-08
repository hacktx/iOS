//
//  AppDelegate.swift
//  HackTX
//
//  Created by Rohit Datta on 7/11/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit
import Parse


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        UserPrefs.shared().registerDefaults()
        Fabric.with([Twitter()])
        setNavTabBarLayout()
		
        setupGoogleAnalytics()
		initParse(application, launchOptions: launchOptions)
		UIApplication.sharedApplication().applicationIconBadgeNumber = 0

		return true
	}
    
    func setupGoogleAnalytics() {
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        var gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
    }
	
	func initParse(application: UIApplication, launchOptions: [NSObject: AnyObject]?) {
		
		
		let parseAppID = getParseAppID()
		let parseClientID = getParseClientID()
		Parse.setApplicationId(parseAppID,
			clientKey: parseClientID)
		
		if application.applicationState != UIApplicationState.Background {
			// Track an app open here if we launch with a push, unless
			// "content_available" was used to trigger a background push (introduced in iOS 7).
			// In that case, we skip tracking here to avoid double counting the app-open.
			
			let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
			let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
			var pushPayload = false
			if let options = launchOptions {
				pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
			}
			if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
				PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
			}
		}
		if application.respondsToSelector("registerUserNotificationSettings:") {
			let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
			let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
			application.registerUserNotificationSettings(settings)
			application.registerForRemoteNotifications()
		} else {
			let types = UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound
			application.registerForRemoteNotificationTypes(types)
		}
		
		let currentInstallation = PFInstallation.currentInstallation()
		currentInstallation.addUniqueObject("announcements", forKey: "channels")
		currentInstallation.saveInBackground()
	}
	
	func getParseKeyDict() -> NSDictionary {
		var parseDict : NSDictionary?
		if let path = NSBundle.mainBundle().pathForResource("ApiKeys", ofType: "plist") {
			parseDict = NSDictionary(contentsOfFile: path)
		}
		return parseDict!
	}
	
	func getParseAppID() -> String {
		let parseDict = getParseKeyDict()
		return parseDict["ApplicationID"] as! String
	}
	
	func getParseClientID() -> String {
		let parseDict = getParseKeyDict()
		return parseDict["ClientID"] as! String
	}
    
    func setNavTabBarLayout() {
//        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
//        UINavigationBar.appearance().barTintColor = UIColor(red: 10/255.0, green: 166/255.0, blue: 182/255.0, alpha: 1.0)
//        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
//        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
//        
//        UITabBar.appearance().barTintColor = UIColor(red: 10/255.0, green: 166/255.0, blue: 182/255.0, alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor(red: 125/255.0, green: 211/255.0, blue: 244/255.0, alpha: 1.0) //UIColor.whiteColor()
        
        
    }
	
	func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
		let installation = PFInstallation.currentInstallation()
		installation.setDeviceTokenFromData(deviceToken)
		installation.saveInBackground()
	}
 
	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		if error.code == 3010 {
			println("Push notifications are not supported in the iOS Simulator.")
		} else {
			println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
		}
	}
 
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
		PFPush.handlePush(userInfo)
		if application.applicationState == UIApplicationState.Inactive {
			PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
		}
		
		self.window?.makeKeyAndVisible()
		let rootController = window?.rootViewController as! UITabBarController
		rootController.selectedIndex = 1;
		NSNotificationCenter.defaultCenter().postNotificationName("reloadTheTable", object: nil)
		
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
		UIApplication.sharedApplication().applicationIconBadgeNumber = 0

	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

