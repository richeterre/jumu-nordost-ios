//
//  PerformanceListViewController.swift
//  JumuNordost
//
//  Created by Martin Richter on 14/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Cartography
import DZNEmptyDataSet
import ReactiveCocoa
import Result

class PerformanceListViewController: UIViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Private Properties

    private let mediator: PerformanceListMediator
    private let filterView: PerformanceFilterView
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let spinner = UIActivityIndicatorView(activityIndicatorStyle: .White)
    private let performanceCellIdentifier = "PerformanceCell"

    // MARK: - Lifecycle

    init(mediator: PerformanceListMediator) {
        self.mediator = mediator
        filterView = PerformanceFilterView(
            dateStrings: mediator.formattedContestDays(),
            venueNames: mediator.venueNames()
        )

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: localize("BACK_TITLE.PERFORMANCE_LIST"),
            style: .Plain,
            target: nil,
            action: nil
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)

        tableView.rowHeight = UITableViewAutomaticDimension

        tableView.registerClass(PerformanceCell.self, forCellReuseIdentifier: performanceCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self

        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()

        refreshControl.addTarget(self, action: Selector("refreshControlFired"), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)

        view.addSubview(filterView)
        view.addSubview(tableView)

        makeConstraints()
        makeBindings()
    }

    // MARK: - Layout

    private func makeConstraints() {
        filterView.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor).active = true

        constrain(view, filterView, tableView) { superview, filterView, tableView in
            filterView.left == superview.left
            filterView.right == superview.right

            tableView.top == filterView.bottom
            tableView.left == superview.left
            tableView.right == superview.right
        }

        tableView.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.topAnchor).active = true
    }

    // MARK: - Bindings

    private func makeBindings() {
        self.title = mediator.title

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
                self?.tableView.updateWithChangeset(changeset, animation: .Fade)

                // TODO: Detect venue/date changes in a better way
                if changeset.insertions.count > 0 || changeset.deletions.count > 0 {
                    self?.tableView.scrollToTop(animated: true)
                }
            }

        filterView.selectedDateIndex.value = mediator.selectedDayIndex.value // Set initial value
        mediator.selectedDayIndex <~ filterView.selectedDateIndex // Create binding for future values

        filterView.selectedVenueIndex.value = mediator.selectedVenueIndex.value // Set initial value
        mediator.selectedVenueIndex <~ filterView.selectedVenueIndex // Create binding for future values
    }

    // MARK: - User Interaction

    func refreshControlFired() {
        mediator.refreshObserver.sendNext(())
    }

    // MARK: - DZNEmptyDataSetDelegate

    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -filterView.frame.height / 2
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

        if mediator.hasEmptyPerformanceList {
            return NSAttributedString(string: localize("LABEL.NO_PERFORMANCES_FOUND"), attributes: attributes)
        } else if mediator.hasError {
            return NSAttributedString(string: localize("ERROR.NO_PERFORMANCES_FETCHED"), attributes: attributes)
        } else {
            return NSAttributedString(string: localize("LABEL.LOADING"), attributes: attributes)
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediator.numberOfPerformances()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(performanceCellIdentifier, forIndexPath: indexPath) as! PerformanceCell

        cell.configure(mediator.formattedListPerformanceForIndexPath(indexPath))
        cell.accessoryType = .DisclosureIndicator

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        // Calculate height based on number of appearances and predecessor info

        let number = mediator.numberOfAppearancesForPerformanceAtIndexPath(indexPath)
        let baseHeight: CGFloat = {
            switch number {
            case 1: return 77
            case 2: return 96
            case 3: return 115
            case 4: return 134
            default: return 77
            }
        }()

        let hasPredecessorInfo = mediator.predecessorInfoPresentForPerformanceAtIndexPath(indexPath)
        return hasPredecessorInfo ? baseHeight + 20 : baseHeight
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let performanceMediator = mediator.mediatorForPerformanceAtIndexPath(indexPath)
        let performanceViewController = PerformanceViewController(mediator: performanceMediator)
        self.navigationController?.pushViewController(performanceViewController, animated: true)
    }
}
