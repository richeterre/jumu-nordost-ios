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

        if mediator.currentContestMediators.value == nil {
            presentContestList(animated: false)
        }
    }

    // MARK: - Bindings

    private func makeBindings() {
        mediator.currentContestMediators.producer
            .observeOn(UIScheduler())
            .startWithNext { [weak self] contestMediators in
                self?.updateViewWithContestMediators(contestMediators)
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

    private func updateViewWithContestMediators(mediators: ContestMediators?) {
        // Dismiss contest picker if shown
        if (presentedViewController != nil) {
            dismissViewControllerAnimated(true, completion: nil)
        }

        guard let (performanceListMediator, resultListMediator) = mediators else {
            viewControllers = []
            return
        }

        let performanceListVC = PerformanceListViewController(mediator: performanceListMediator)
        performanceListVC.navigationItem.leftBarButtonItem = switchContestBarButtonItem()
        let performanceListNC = UINavigationController(rootViewController: performanceListVC)

        performanceListNC.tabBarItem = UITabBarItem(
            title: localize("TAB_TITLE.PERFORMANCE_LIST"),
            image: UIImage(named: "IconTimetable"),
            selectedImage: UIImage(named: "IconTimetableFilled")
        )

        let resultListVC = ResultListViewController(mediator: resultListMediator)
        resultListVC.navigationItem.leftBarButtonItem = switchContestBarButtonItem()
        let resultListNC = UINavigationController(rootViewController: resultListVC)
        resultListNC.tabBarItem = UITabBarItem(
            title: localize("TAB_TITLE.RESULT_LIST"),
            image: UIImage(named: "IconDiploma"),
            selectedImage: UIImage(named: "IconDiplomaFilled")
        )

        viewControllers = [performanceListNC, resultListNC]
    }

    private func switchContestBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(
            image: UIImage(named: "IconList"),
            style: .Plain,
            target: self,
            action: #selector(switchContestButtonTapped)
        )
    }
}

