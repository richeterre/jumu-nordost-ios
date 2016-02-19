//
//  AppDelegate.swift
//  JumuNordost
//
//  Created by Martin Richter on 13/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        window = UIWindow()
        window?.tintColor = Color.primaryColor

        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UINavigationBar.appearance().barTintColor = Color.primaryColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]

        let store = Store()
        let contestsMediator = ContestsMediator(store: store)
        let contestsViewController = ContestsViewController(mediator: contestsMediator)
        window?.rootViewController = UINavigationController(rootViewController: contestsViewController)

        window?.makeKeyAndVisible()

        return true
    }
}
