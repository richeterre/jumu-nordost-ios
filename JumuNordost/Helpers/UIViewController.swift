//
//  UIViewController.swift
//  JumuNordost
//
//  Created by Martin Richter on 05/03/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa
import Result

extension UIViewController {
    func isActive() -> SignalProducer<Bool, NoError> {

        // Track view appearance

        let viewWillAppear = rac_signalForSelector(Selector("viewWillAppear:")).toSignalProducer()
        let viewWillDisappear = rac_signalForSelector(Selector("viewWillDisappear:")).toSignalProducer()

        let presented = SignalProducer(values: [
            viewWillAppear.map { _ in true },
            viewWillDisappear.map { _ in false }
        ]).flatten(.Merge)

        // Track app state

        let notificationCenter = NSNotificationCenter.defaultCenter()

        let didBecomeActive = notificationCenter
            .rac_addObserverForName(UIApplicationDidBecomeActiveNotification, object: nil)
            .toSignalProducer()

        let didBecomeInactive = notificationCenter
            .rac_addObserverForName(UIApplicationWillResignActiveNotification, object: nil)
            .toSignalProducer()

        let appActive = SignalProducer(values: [
            SignalProducer(value: true), // App is initially active (without notification)
            didBecomeActive.map { _ in true },
            didBecomeInactive.map { _ in false }
        ]).flatten(.Merge)

        // Combine everything

        return combineLatest(presented, appActive)
            .map { $0 && $1 }
            .flatMapError { _ in SignalProducer<Bool, NoError>.empty }
    }
}
