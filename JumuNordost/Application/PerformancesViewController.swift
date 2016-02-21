//
//  PerformancesViewController.swift
//  JumuNordost
//
//  Created by Martin Richter on 14/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Cartography
import ReactiveCocoa
import Result

class PerformancesViewController: BaseViewController, UITableViewDataSource {

    // MARK: - Private Properties

    private let mediator: PerformancesMediator
    private let filterView: PerformanceFilterView
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let performanceCellIdentifier = "PerformanceCell"

    // MARK: - Lifecycle

    init(mediator: PerformancesMediator) {
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

        tableView.allowsSelection = false
        tableView.registerClass(ContestCell.self, forCellReuseIdentifier: performanceCellIdentifier)
        tableView.dataSource = self

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

        filterView.selectedDateIndex.value = mediator.selectedDayIndex.value // Set initial value
        mediator.selectedDayIndex <~ filterView.selectedDateIndex // Create binding for future values

        filterView.selectedVenueIndex.value = mediator.selectedVenueIndex.value // Set initial value
        mediator.selectedVenueIndex <~ filterView.selectedVenueIndex // Create binding for future values
    }

    // MARK: - User Interaction

    func refreshControlFired() {
        mediator.refreshObserver.sendNext(())
    }

    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediator.numberOfPerformances()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(performanceCellIdentifier, forIndexPath: indexPath)

        cell.textLabel?.text = mediator.categoryNameForPerformanceAtIndexPath(indexPath)

        return cell
    }
}
