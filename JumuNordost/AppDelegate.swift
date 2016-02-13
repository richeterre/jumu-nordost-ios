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

        let store = Store()
        let contestsMediator = ContestsMediator(store: store)
        window?.rootViewController = ContestsViewController(mediator: contestsMediator)

        window?.makeKeyAndVisible()

        return true
    }
}
