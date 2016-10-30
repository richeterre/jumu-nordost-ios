//
//  ContestListViewController.swift
//  JumuNordost
//
//  Created by Martin Richter on 13/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Cartography
import DZNEmptyDataSet
import ReactiveCocoa
import Result

class ContestListViewController: UIViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Private Properties

    private let mediator: ContestListMediator
    private let headerView = ContestListHeaderView(text: localize("LABEL.PICK_CONTEST"))
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
            action: #selector(filterToggleButtonTapped)
        )

        navigationItem.leftBarButtonItem = filterToggleButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        view.backgroundColor = UIColor.whiteColor()

        tableView.registerClass(ContestCell.self, forCellReuseIdentifier: contestCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self

        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = ContestCell.height

        refreshControl.addTarget(self, action: #selector(refreshControlFired), forControlEvents: .ValueChanged)

        tableView.addSubview(refreshControl)
        view.addSubview(headerView)
        view.addSubview(tableView)

        makeConstraints()
        makeBindings()
    }

    // MARK: - Layout

    private func makeConstraints() {
        headerView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true

        constrain(view, headerView, tableView) { superview, headerView, tableView in
            headerView.left == superview.left
            headerView.right == superview.right

            tableView.top == headerView.bottom

            align(left: headerView, tableView)
            align(right: headerView, tableView)

            tableView.bottom == superview.bottom
        }
    }

    // MARK: - Bindings

    private func makeBindings() {
        mediator.active <~ isActive()

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

        mediator.contentChanges
            .observeOn(UIScheduler())
            .observeNext { [weak self] changeset in
                self?.tableView.updateWithChangeset(changeset, animation: .Automatic)
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

    // MARK: - DZNEmptyDataSetDelegate

    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -headerView.frame.height / 2
    }

    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }

    // MARK: - DZNEmptyDataSetSource

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [
            NSFontAttributeName: Font.fontWithWeight(.Regular, style: .Italic, size: .Large),
            NSForegroundColorAttributeName: Color.secondaryTextColor
        ]

        if mediator.hasEmptyContestList {
            return NSAttributedString(string: localize("LABEL.NO_CONTESTS_FOUND"), attributes: attributes)
        } else if mediator.hasError {
            return NSAttributedString(string: localize("ERROR.NO_CONTESTS_FETCHED"), attributes: attributes)
        } else {
            return NSAttributedString(string: localize("LABEL.LOADING"), attributes: attributes)
        }
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

    private func navigateToContestAtIndexPath(indexPath: NSIndexPath) {
        let performanceListMediator = mediator.performanceListMediatorForContestAtIndexPath(indexPath)
        let performanceListViewController = PerformanceListViewController(mediator: performanceListMediator)
        self.navigationController?.pushViewController(performanceListViewController, animated: true)
    }
}
