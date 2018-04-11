//
//  AppDelegate.swift
//  Homesnap
//
//  Created by Justin Wells on 3/23/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import Firebase

var db = Firestore.firestore()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //Setup Firebase
        FirebaseApp.configure()
        //Set FireStore Settings
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        
        // User is signed in.
        self.setAppControllers(viewController: self.setupAppControllers())
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setupAppControllers() -> UIViewController{
        //Setup NavigationControllers for each tab
        let feedVC = FeedController()
        feedVC.tabBarItem = UITabBarItem(title: "feedTabTitle".localized(), image: UIImage(named: "feed"), selectedImage: UIImage(named: "feedFilled"))
        let navVC1 = NavigationController.init(rootViewController: feedVC)
        
        let searchVC = SearchController()
        searchVC.tabBarItem = UITabBarItem(title: "searchTabTitle".localized(), image: UIImage(named: "search"), selectedImage: UIImage(named: "searchFilled"))
        let navVC2 = NavigationController.init(rootViewController: searchVC)
        
        let savesVC = SavesController()
        savesVC.tabBarItem = UITabBarItem(title: "savesTabTitle".localized(), image: UIImage(named: "saves"), selectedImage: UIImage(named: "savesFilled"))
        let navVC3 = NavigationController.init(rootViewController: savesVC)
        
        let messagesVC = MessagesController()
        messagesVC.tabBarItem = UITabBarItem(title: "messagesTabTitle".localized(), image: UIImage(named: "messages"), selectedImage: UIImage(named: "messagesFilled"))
        let navVC4 = NavigationController.init(rootViewController: messagesVC)
        
        let moreVC = MoreController()
        moreVC.tabBarItem = UITabBarItem(title: "moreTabTitle".localized(), image: UIImage(named: "more"), selectedImage: UIImage(named: "moreFilled"))
        let navVC5 = NavigationController.init(rootViewController: moreVC)
        
        //Setup TabBarController
        let tabVC = TabBarController()
        tabVC.viewControllers = [navVC1, navVC2, navVC3, navVC4, navVC5]
        
        return tabVC
    }
    
    func setAppControllers(viewController: UIViewController){
        //Set TabBarController as Window
        window?.rootViewController = viewController
    }
}

