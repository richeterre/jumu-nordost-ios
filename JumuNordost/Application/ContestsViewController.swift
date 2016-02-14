//
//  ContestsViewController.swift
//  JumuNordost
//
//  Created by Martin Richter on 13/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa
import Result

class ContestsViewController: UIViewController {

    // MARK: - Private Properties

    private let mediator: ContestsMediator
    private let (isActive, isActiveObserver) = Signal<Bool, NoError>.pipe()

    // MARK: - Lifecycle

    init(mediator: ContestsMediator) {
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
        isActiveObserver.sendNext(true)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        isActiveObserver.sendNext(false)
    }

    // MARK: - Bindings

    private func makeBindings() {
        mediator.active <~ isActive

        mediator.contentChanged
            .observeOn(UIScheduler())
            .observeNext { [weak self] in
                if let contestCount = self?.mediator.numberOfContests() {
                    print("\(contestCount) contest(s) fetched")
                }
            }
    }
}
