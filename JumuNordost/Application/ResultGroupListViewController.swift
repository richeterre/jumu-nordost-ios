//
//  ResultGroupListViewController.swift
//  JumuNordost
//
//  Created by Martin Richter on 07/01/2017.
//  Copyright © 2017 Martin Richter. All rights reserved.
//

import UIKit

class ResultGroupListViewController: UITableViewController {

    // MARK: - Private Properties

    private let mediator: ResultGroupListMediator
    private let cellIdentifier = "ContestCategoryCell"

    // MARK: - Lifecycle

    init(mediator: ResultGroupListMediator) {
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
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: localize("BACK_TITLE.RESULT_GROUP_LIST"),
            style: .Plain,
            target: nil,
            action: nil
        )

        tableView.registerClass(ContestCategoryCell.self, forCellReuseIdentifier: cellIdentifier)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediator.numberOfContestCategories()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ContestCategoryCell

        cell.configure(mediator.contestCategoryForIndexPath(indexPath))
        cell.accessoryType = .DisclosureIndicator

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let resultListMediator = mediator.resultListMediatorFotIndexPath(indexPath)
        let resultListVC = ResultListViewController(mediator: resultListMediator)
        navigationController?.pushViewController(resultListVC, animated: true)
    }
}
