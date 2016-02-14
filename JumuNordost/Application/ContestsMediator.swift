//
//  ContestsMediator.swift
//  JumuNordost
//
//  Created by Martin Richter on 13/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa
import Result

class ContestsMediator {

    // MARK: - Inputs

    let active = MutableProperty<Bool>(false)

    // MARK: - Outputs

    let contentChanged: Signal<Void, NoError>

    // MARK: - Private Properties

    private let store: StoreType
    private let contentChangedObserver: Observer<Void, NoError>
    private var contests = [Contest]()

    // MARK: - Lifecycle

    init(store: StoreType) {
        self.store = store

        (contentChanged, contentChangedObserver) = Signal<Void, NoError>.pipe()

        // Refresh content when becoming active
        let refreshTrigger = active.producer.filter { $0 }.map { _ in () }
        refreshTrigger
            .flatMap(.Latest) { _ in
                return store.fetchContests()
                    .flatMapError { error in
                        return SignalProducer(value: [])
                    }
            }
            .startWithNext { [weak self] contests in
                self?.contests = contests
                self?.contentChangedObserver.sendNext(())
            }
    }

    // MARK: - Data Source

    func numberOfContests() -> Int {
        return contests.count
    }

    func nameForContestAtIndexPath(indexPath: NSIndexPath) -> String {
        return contests[indexPath.row].name
    }
}
