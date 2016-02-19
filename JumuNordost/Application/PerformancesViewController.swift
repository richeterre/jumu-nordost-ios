//
//  PerformancesViewController.swift
//  JumuNordost
//
//  Created by Martin Richter on 14/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa
import Result

class PerformancesViewController: ListViewController {

    // MARK: - Private Properties

    private let mediator: PerformancesMediator
    private let performanceCellIdentifier = "PerformanceCell"

    // MARK: - Lifecycle

    init(mediator: PerformancesMediator) {
        self.mediator = mediator
        super.init(style: .Plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(ContestCell.self, forCellReuseIdentifier: performanceCellIdentifier)

        makeBindings()
    }

    // MARK: - Bindings

    private func makeBindings() {
        mediator.active <~ isActive

        mediator.isLoading.producer
            .observeOn(UIScheduler())
            .startWithNext({ [weak self] isLoading in
                if !isLoading {
                    self?.refreshControl?.endRefreshing()
                }
            })

        mediator.contentChanged
            .observeOn(UIScheduler())
            .observeNext { [weak self] in
                self?.tableView.reloadData()
        }
    }

    // MARK: - User Interaction

    override func refreshControlFired() {
        mediator.refreshObserver.sendNext(())
    }

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediator.numberOfPerformances()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(performanceCellIdentifier, forIndexPath: indexPath)

        cell.textLabel?.text = mediator.categoryNameForPerformanceAtIndexPath(indexPath)

        return cell
    }
}
