//
//  BaseViewController.swift
//  JumuNordost
//
//  Created by Martin Richter on 19/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa
import Result

class BaseViewController: UIViewController {

    // MARK: - Internal Properties

    let (isActive, isActiveObserver) = Signal<Bool, NoError>.pipe()

    // MARK: - View Lifecycle

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        isActiveObserver.sendNext(true)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        isActiveObserver.sendNext(false)
    }
}
