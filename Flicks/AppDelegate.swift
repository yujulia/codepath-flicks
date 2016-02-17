//
//  AppDelegate.swift
//  Flicks
//
//  Created by Julia Yu on 2/15/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import UIKit

private let APIKEY = "229cf9c285d7dcc65abd26a73d9fa804"
private let NOW_PLAYING = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(APIKEY)"
private let TOP_RATED = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(APIKEY)"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let NowPlayingNavCtrl = storyboard.instantiateViewControllerWithIdentifier("moviesNavigationController") as! UINavigationController
        let NowPlayingViewCtrl = NowPlayingNavCtrl.topViewController as! FlicksViewController
        NowPlayingViewCtrl.endpoint = NOW_PLAYING
        NowPlayingNavCtrl.tabBarItem.title = "Now Playing"
        NowPlayingNavCtrl.tabBarItem.image = UIImage(named: "video")
        

        let TopRatedNavCtrl = storyboard.instantiateViewControllerWithIdentifier("moviesNavigationController") as! UINavigationController
        let TopRatedViewCtrl = TopRatedNavCtrl.topViewController as! FlicksViewController
        TopRatedViewCtrl.endpoint = TOP_RATED
        TopRatedNavCtrl.tabBarItem.title = "Top Rated"
        TopRatedNavCtrl.tabBarItem.image = UIImage(named: "star")
        
        let tabController = UITabBarController()
        tabController.viewControllers = [NowPlayingNavCtrl, TopRatedNavCtrl]
        
        tabController.tabBar.barTintColor = UIColor.whiteColor()
        tabController.tabBar.tintColor = UIColor.blackColor()
        
        
        
    
        
        window?.rootViewController = tabController
        window?.makeKeyAndVisible()
        
        
        
        
        // Override point for customization after application launch.
        
        return true
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
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

