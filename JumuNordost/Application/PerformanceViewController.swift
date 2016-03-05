//
//  PerformanceViewController.swift
//  JumuNordost
//
//  Created by Martin Richter on 21/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa
import Cartography

class PerformanceViewController: UIViewController {

    private let mediator: PerformanceMediator
    private let scrollView = UIScrollView()
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

        scrollView.layoutMargins = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)

        scrollView.addSubview(performanceView)
        view.addSubview(scrollView)

        makeConstraints()
        makeBindings()
    }

    // MARK: - Layout

    private func makeConstraints() {
        constrain(view, scrollView, performanceView) { superview, scrollView, performanceView in
            scrollView.edges == superview.edges

            performanceView.top == scrollView.topMargin
            performanceView.left == superview.leftMargin
            performanceView.right == superview.rightMargin
            performanceView.bottom == scrollView.bottomMargin
        }
    }

    // MARK: - Bindings

    private func makeBindings() {
        self.title = mediator.title

        mediator.active <~ isActive()
    }
}
