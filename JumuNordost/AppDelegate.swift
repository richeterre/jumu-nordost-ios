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

        customizeAppAppearance()

        let store = Store(baseURL: Constant.localBaseURL)
        let contestListMediator = ContestListMediator(store: store)
        let contestListViewController = ContestListViewController(mediator: contestListMediator)
        window?.rootViewController = UINavigationController(rootViewController: contestListViewController)

        window?.makeKeyAndVisible()

        return true
    }

    // MARK: - Private Helpers

    private func customizeAppAppearance() {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UINavigationBar.appearance().barTintColor = Color.barTintColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: Font.fontWithWeight(.Bold, style: .Normal, size: .Large),
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSFontAttributeName: Font.fontWithWeight(.Regular, style: .Normal, size: .Medium)
        ], forState: .Normal)
        UISegmentedControl.appearance().setTitleTextAttributes([
            NSFontAttributeName: Font.fontWithWeight(.Regular, style: .Normal, size: .Small)
        ], forState: .Normal)
    }
}
