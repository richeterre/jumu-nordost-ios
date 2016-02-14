//
//  ContestsViewController.swift
//  JumuNordost
//
//  Created by Martin Richter on 13/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa
import Result

class ContestsViewController: UITableViewController {

    // MARK: - Private Properties

    private let mediator: ContestsMediator
    private let (isActive, isActiveObserver) = Signal<Bool, NoError>.pipe()
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

        view.backgroundColor = UIColor.whiteColor()

        configureTableView()
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

    func refreshControlFired() {
        mediator.refreshObserver.sendNext(())
    }

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediator.numberOfContests()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(contestCellIdentifier, forIndexPath: indexPath)

        cell.textLabel?.text = mediator.nameForContestAtIndexPath(indexPath)
        cell.detailTextLabel?.text = mediator.dateForContestAtIndexPath(indexPath)

        return cell
    }

    // MARK: - Private Helpers

    private func configureTableView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
            action: Selector("refreshControlFired"),
            forControlEvents: .ValueChanged
        )
        self.refreshControl = refreshControl

        tableView.allowsSelection = false
        tableView.registerClass(ContestCell.self, forCellReuseIdentifier: contestCellIdentifier)
    }
}
