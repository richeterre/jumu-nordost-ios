//
//  ResultGroupListMediator.swift
//  JumuNordost
//
//  Created by Martin Richter on 07/01/2017.
//  Copyright © 2017 Martin Richter. All rights reserved.
//

import ReactiveCocoa
import Result

class ResultGroupListMediator: Mediator {

    // MARK: - Outputs

    var title: String {
        return contest.name
    }

    // MARK: - Private Properties

    private let contest: Contest

    // MARK: - Lifecycle

    init(store: StoreType, contest: Contest) {
        self.contest = contest

        super.init(store: store)
    }

    // MARK: - Contest Categories

    func numberOfContestCategories() -> Int {
        return contest.contestCategories.count
    }

    func contestCategoryForIndexPath(indexPath: NSIndexPath) -> ContestCategory {
        return contest.contestCategories[indexPath.row]
    }
}
