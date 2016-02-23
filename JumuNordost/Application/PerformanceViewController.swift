//
//  PerformanceViewController.swift
//  JumuNordost
//
//  Created by Martin Richter on 21/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import UIKit

class PerformanceViewController: BaseViewController {

    private let mediator: PerformanceMediator

    // MARK: - Lifecycle

    init(mediator: PerformanceMediator) {
        self.mediator = mediator

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()

        makeBindings()
    }

    // MARK: - Bindings

    private func makeBindings() {
        self.title = mediator.title
    }
}
