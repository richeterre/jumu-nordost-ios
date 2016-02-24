//
//  ContestListViewController.swift
//  JumuNordost
//
//  Created by Martin Richter on 13/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Cartography
import ReactiveCocoa
import Result

class ContestListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Private Properties

    private let mediator: ContestListMediator
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let contestCellIdentifier = "ContestCell"

    // MARK: - Lifecycle

    init(mediator: ContestListMediator) {
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

        tableView.rowHeight = ContestCell.height

        tableView.registerClass(ContestCell.self, forCellReuseIdentifier: contestCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self

        refreshControl.addTarget(self, action: Selector("refreshControlFired"), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        view.addSubview(tableView)

        makeConstraints()
        makeBindings()
    }

    // MARK: - Layout

    private func makeConstraints() {
        constrain(view, tableView) { superview, tableView in
            tableView.edges == superview.edges
        }
    }

    // MARK: - Bindings

    private func makeBindings() {
        mediator.active <~ isActive

        mediator.isLoading.producer
            .observeOn(UIScheduler())
            .startWithNext({ [weak self] isLoading in
                if !isLoading {
                    self?.refreshControl.endRefreshing()
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediator.numberOfContests()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(contestCellIdentifier, forIndexPath: indexPath) as! ContestCell

        cell.configure(mediator.formattedContestForIndexPath(indexPath))
        cell.accessoryType = .DisclosureIndicator

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let performanceListMediator = mediator.performanceListMediatorForContestAtIndexPath(indexPath)
        let performanceListViewController = PerformanceListViewController(mediator: performanceListMediator)
        self.navigationController?.pushViewController(performanceListViewController, animated: true)
    }
}
