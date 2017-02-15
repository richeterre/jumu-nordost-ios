//
//  ResultListViewController.swift
//  JumuNordost
//
//  Created by Martin Richter on 14/01/2017.
//  Copyright © 2017 Martin Richter. All rights reserved.
//

import Cartography
import DZNEmptyDataSet
import ReactiveCocoa
import Result

class ResultListViewController: UITableViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

    // MARK: - Private Properties

    private let mediator: ResultListMediator
    private let spinner = UIActivityIndicatorView(activityIndicatorStyle: .White)
    private let cellIdentifier = "ResultPerformanceCell"

    // MARK: - Lifecycle

    init(mediator: ResultListMediator) {
        self.mediator = mediator

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = mediator.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)

        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension

        tableView.registerClass(ResultPerformanceCell.self, forCellReuseIdentifier: cellIdentifier)

        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()

        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self,
            action: #selector(refreshControlFired),
            forControlEvents: .ValueChanged
        )

        makeBindings()
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
                    self?.refreshControl?.endRefreshing()
                    self?.spinner.stopAnimating()
                }
            })

        mediator.contentChanges
            .observeOn(UIScheduler())
            .observeNext { [weak self] changeset in
                self?.tableView.updateWithChangeset(changeset, animation: .Fade)
            }
    }

    // MARK: - User Interaction

    func refreshControlFired() {
        mediator.refreshObserver.sendNext(())
    }

    // MARK: - DZNEmptyDataSetDelegate

    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }

    // MARK: - DZNEmptyDataSetSource

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [
            NSFontAttributeName: Font.fontWithWeight(.Regular, style: .Italic, size: .Large),
            NSForegroundColorAttributeName: Color.secondaryTextColor
        ]

        if mediator.hasEmptyResultList {
            return NSAttributedString(string: localize("LABEL.NO_RESULTS_FOUND"), attributes: attributes)
        } else if mediator.hasError {
            return NSAttributedString(string: localize("ERROR.NO_RESULTS_FETCHED"), attributes: attributes)
        } else {
            return NSAttributedString(string: localize("LABEL.LOADING"), attributes: attributes)
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediator.numberOfPerformances()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ResultPerformanceCell

        cell.configure(mediator.formattedResultPerformanceForIndexPath(indexPath))

        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        // Calculate height based on number of appearances and predecessor info
        let appearanceCount = mediator.numberOfAppearancesForPerformanceAtIndexPath(indexPath)
        let baseHeight = 49.5 + CGFloat((appearanceCount - 1)) * 19.0

        let hasPredecessorInfo = mediator.predecessorInfoPresentForPerformanceAtIndexPath(indexPath)
        return hasPredecessorInfo ? baseHeight + 20 : baseHeight
    }
}
