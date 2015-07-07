//
//  AppDelegate.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 16/6/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    var backgroundTaskIdentifier : UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var myTimer : NSTimer?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //Enable local data store
        Parse.enableLocalDatastore()
        // Override point for customization after application launch.
        Parse.setApplicationId("YwH5uZAZTNeun59PpcrL2Rk9qE4Oc1zl1dPjDr8x", clientKey: "pXj8wTsLjDHZta12STdVxEBJMxGZvi8vhjqSCuoG")

        return true
    }
    
    
//    func isMultiTaskingSupported() -> Bool {
//        return UIDevice.currentDevice().multitaskingSupported
//    }
//    
//
//    func timerMethod(sender: NSTimer) {
//        
        //Things we do in our timer
        
//        let backgroundTimeRemaining = UIApplication.sharedApplication().backgroundTimeRemaining
//        
//        if backgroundTimeRemaining == DBL_MAX{
//            println("Background Time Remaining = Undetermined")
//        } else {
//            println("Background Time Remaining \(backgroundTimeRemaining) Seconds")
//        }
//    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
//        if isMultiTaskingSupported() == false{
//            return
//        }
//        myTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerMethod:", userInfo: nil, repeats: true)
//        
//        backgroundTaskIdentifier = application.beginBackgroundTaskWithName("task1", expirationHandler: {[weak self] in self!.endBackgroundTask()})
    }

    
    func endBackgroundTask() {
//        let mainQueue = dispatch_get_main_queue()
//        
//        dispatch_async(mainQueue, {[weak self] in
//            if let timer = self!.myTimer{
//                timer.invalidate()
//                self?.myTimer = nil
//                UIApplication.sharedApplication().endBackgroundTask(self!.backgroundTaskIdentifier)
//                self!.backgroundTaskIdentifier = UIBackgroundTaskInvalid
//            }
//        })
    }
    
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//        if backgroundTaskIdentifier != UIBackgroundTaskInvalid {
//            endBackgroundTask()
//        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        println("I'm closed, but I will be back")
    }
}