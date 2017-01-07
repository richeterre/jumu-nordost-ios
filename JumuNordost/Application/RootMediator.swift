//
//  RootMediator.swift
//  JumuNordost
//
//  Created by Martin Richter on 07/01/2017.
//  Copyright © 2017 Martin Richter. All rights reserved.
//

import ReactiveCocoa

typealias ContestMediators = (PerformanceListMediator, ResultListMediator)

class RootMediator: Mediator {

    // MARK: - Outputs

    let currentContestMediators = MutableProperty<ContestMediators?>(nil)

    // MARK: - Private Properties

    private let contestListMediator: ContestListMediator

    // MARK: - Lifecycle

    override init(store: StoreType) {
        contestListMediator = ContestListMediator(store: store)
        currentContestMediators <~ contestListMediator.contestMediatorsSelected.map { .Some($0) }

        super.init(store: store)
    }

    // MARK: - Mediators

    func mediatorForContestList() -> ContestListMediator {
        return contestListMediator
    }
}
