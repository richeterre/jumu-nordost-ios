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
    private let spinner = UIActivityIndicatorView(activityIndicatorStyle: .White)
    private let contestCellIdentifier = "ContestCell"
    private var filterToggleButton: UIBarButtonItem?

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

        filterToggleButton = UIBarButtonItem(
            title: nil,
            style: .Plain,
            target: self,
            action: Selector("filterToggleButtonTapped")
        )

        navigationItem.leftBarButtonItem = filterToggleButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        view.backgroundColor = UIColor.whiteColor()

        tableView.tableHeaderView = configuredTableHeaderView()
        tableView.tableFooterView = UIView()
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
                if isLoading {
                    self?.spinner.startAnimating()
                } else {
                    self?.refreshControl.endRefreshing()
                    self?.spinner.stopAnimating()
                }
            })

        mediator.contentChanged
            .observeOn(UIScheduler())
            .observeNext { [weak self] in
                self?.tableView.reloadData()
            }

        mediator.showCurrentOnly.producer
            .observeOn(UIScheduler())
            .startWithNext { [weak self] currentOnly in
                self?.filterToggleButton?.title = currentOnly
                    ? localize("BUTTON.SHOW_ALL")
                    : localize("BUTTON.SHOW_CURRENT")
            }
    }

    // MARK: - User Interaction

    func refreshControlFired() {
        mediator.refreshObserver.sendNext(())
    }

    func filterToggleButtonTapped() {
        mediator.toggleFilterState()
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
        navigateToContestAtIndexPath(indexPath)
    }

    // MARK: - Private Helpers

    private func configuredTableHeaderView() -> ContestListHeaderView {
        let headerView = ContestListHeaderView(text: localize("LABEL.PICK_CONTEST"))
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        let height = headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height

        var headerViewFrame = headerView.frame
        headerViewFrame.size.height = height
        headerView.frame = headerViewFrame

        return headerView
    }

    private func navigateToContestAtIndexPath(indexPath: NSIndexPath) {
        let performanceListMediator = mediator.performanceListMediatorForContestAtIndexPath(indexPath)
        let performanceListViewController = PerformanceListViewController(mediator: performanceListMediator)
        self.navigationController?.pushViewController(performanceListViewController, animated: true)
    }
}
