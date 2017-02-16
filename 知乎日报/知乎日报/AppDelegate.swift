//
//  AppDelegate.swift
//  知乎日报
//
//  Created by 王小帅 on 2017/1/12.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        
        // 设置状态栏字体颜色
        // **** 注意：**** 
        // ** 设置这个属性的同时必须同时在info.list 中设置View controller-based status bar appearance: NO
        application.statusBarStyle = .lightContent
        
        // 主页是图
        let home = HomeViewController()
        // 左侧菜单栏是图
        let left = MenuViewController.instance()
        
        let rootVC = RootViewController.instance(m: home, l: left)
        
        // 加入导航控制器
        let nav = UINavigationController(rootViewController: rootVC)
        nav.navigationBar.isHidden = true
        nav.view.isUserInteractionEnabled = true
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
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


}

