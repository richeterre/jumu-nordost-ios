//
//  RootMediator.swift
//  JumuNordost
//
//  Created by Martin Richter on 07/01/2017.
//  Copyright © 2017 Martin Richter. All rights reserved.
//

import ReactiveCocoa

class RootMediator: Mediator {

    // MARK: - Outputs

    let currentContestMediator = MutableProperty<PerformanceListMediator?>(nil)

    // MARK: - Private Properties

    private let contestListMediator: ContestListMediator

    // MARK: - Lifecycle

    override init(store: StoreType) {
        contestListMediator = ContestListMediator(store: store)
        currentContestMediator <~ contestListMediator.contestMediatorSelected.map { .Some($0) }

        super.init(store: store)
    }

    // MARK: - Mediators

    func mediatorForContestList() -> ContestListMediator {
        return contestListMediator
    }
}
