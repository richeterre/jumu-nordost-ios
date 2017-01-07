//
//  RootViewController.swift
//  JumuNordost
//
//  Created by Martin Richter on 07/01/2017.
//  Copyright © 2017 Martin Richter. All rights reserved.
//

import ReactiveCocoa

class RootViewController: UITabBarController {

    // MARK: - Private Properties

    private let mediator: RootMediator

    // MARK: - Lifecycle

    init(mediator: RootMediator) {
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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if mediator.currentContestMediator.value == nil {
            presentContestList(animated: false)
        }
    }

    // MARK: - Bindings

    private func makeBindings() {
        mediator.currentContestMediator.producer
            .observeOn(UIScheduler())
            .startWithNext { [weak self] contestMediator in
                self?.updateViewWithNewMediator(contestMediator)
            }
    }

    // MARK: - User Interaction

    func switchContestButtonTapped() {
        presentContestList(animated: true)
    }

    // MARK: - Private Helpers

    private func presentContestList(animated animated: Bool) {
        let contestListMediator = mediator.mediatorForContestList()
        let contestListViewController = ContestListViewController(mediator: contestListMediator)

        presentViewController(
            UINavigationController(rootViewController: contestListViewController),
            animated: animated,
            completion: nil
        )
    }

    private func updateViewWithNewMediator(mediator: PerformanceListMediator?) {
        // Dismiss contest picker if shown
        if (presentedViewController != nil) {
            dismissViewControllerAnimated(true, completion: nil)
        }

        guard let mediator = mediator else {
            viewControllers = []
            return
        }

        let performanceListVC = PerformanceListViewController(mediator: mediator)
        performanceListVC.navigationItem.leftBarButtonItem = switchContestBarButtonItem()
        let performanceListNC = UINavigationController(rootViewController: performanceListVC)
        performanceListNC.tabBarItem = UITabBarItem(
            title: localize("TAB_TITLE.PERFORMANCE_LIST"),
            image: nil,
            selectedImage: nil
        )

        let resultListVC = UITableViewController()
        resultListVC.navigationItem.leftBarButtonItem = switchContestBarButtonItem()
        let resultListNC = UINavigationController(rootViewController: resultListVC)
        resultListNC.tabBarItem = UITabBarItem(
            title: localize("TAB_TITLE.RESULT_LIST"),
            image: nil,
            selectedImage: nil
        )

        viewControllers = [performanceListNC, resultListNC]
    }

    private func switchContestBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(
            barButtonSystemItem: .Bookmarks,
            target: self,
            action: #selector(switchContestButtonTapped)
        )
    }
}

