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
    private let contestCategoryCellIdentifier = "ContestCategoryCell"

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

        tableView.registerClass(ContestCategoryCell.self, forCellReuseIdentifier: contestCategoryCellIdentifier)

        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediator.numberOfContestCategories()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(contestCategoryCellIdentifier, forIndexPath: indexPath) as! ContestCategoryCell

        cell.configure(mediator.contestCategoryForIndexPath(indexPath))

        return cell
    }
}
