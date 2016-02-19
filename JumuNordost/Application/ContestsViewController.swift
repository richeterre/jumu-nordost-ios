//
//  ContestsViewController.swift
//  JumuNordost
//
//  Created by Martin Richter on 13/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa
import Result

class ContestsViewController: ListViewController {

    // MARK: - Private Properties

    private let mediator: ContestsMediator
    private let contestCellIdentifier = "ContestCell"

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

        self.title = localize("NAV_TITLE.CONTESTS")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        view.backgroundColor = UIColor.whiteColor()

        tableView.registerClass(ContestCell.self, forCellReuseIdentifier: contestCellIdentifier)

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
        return mediator.numberOfContests()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(contestCellIdentifier, forIndexPath: indexPath)

        cell.textLabel?.text = mediator.nameForContestAtIndexPath(indexPath)
        cell.detailTextLabel?.text = mediator.datesForContestAtIndexPath(indexPath)
        cell.accessoryType = .DisclosureIndicator

        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let performancesMediator = mediator.performancesMediatorForContestAtIndexPath(indexPath)
        let performancesViewController = PerformancesViewController(mediator: performancesMediator)
        self.navigationController?.pushViewController(performancesViewController, animated: true)
    }
}
