//
//  PerformanceViewController.swift
//  JumuNordost
//
//  Created by Martin Richter on 21/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa
import Cartography

class PerformanceViewController: BaseViewController {

    private let mediator: PerformanceMediator
    private let performanceView: PerformanceView

    // MARK: - Lifecycle

    init(mediator: PerformanceMediator) {
        self.mediator = mediator
        performanceView = PerformanceView(performance: mediator.formattedPerformance)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()

        view.addSubview(performanceView)

        makeConstraints()
        makeBindings()
    }

    // MARK: - Layout

    private func makeConstraints() {
        performanceView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: 16).active = true

        constrain(view, performanceView) { superview, performanceView in
            performanceView.left == superview.leftMargin
            performanceView.right == superview.rightMargin
            performanceView.bottom <= superview.bottomMargin
        }
    }

    // MARK: - Bindings

    private func makeBindings() {
        self.title = mediator.title

        mediator.active <~ isActive
    }
}
