//
//  ContestsViewController.swift
//  JumuNordost
//
//  Created by Martin Richter on 13/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa
import Result

class ContestsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Private Properties

    private let mediator: ContestsMediator
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
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
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor).active = true
        tableView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        tableView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        tableView.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.topAnchor).active = true
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
        let cell = tableView.dequeueReusableCellWithIdentifier(contestCellIdentifier, forIndexPath: indexPath)

        cell.textLabel?.text = mediator.nameForContestAtIndexPath(indexPath)
        cell.detailTextLabel?.text = mediator.datesForContestAtIndexPath(indexPath)
        cell.accessoryType = .DisclosureIndicator

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let performancesMediator = mediator.performancesMediatorForContestAtIndexPath(indexPath)
        let performancesViewController = PerformancesViewController(mediator: performancesMediator)
        self.navigationController?.pushViewController(performancesViewController, animated: true)
    }
}
