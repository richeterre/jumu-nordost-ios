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
    let refreshObserver: Observer<Void, NoError>

    // MARK: - Outputs

    let isLoading: MutableProperty<Bool>
    let contentChanged: Signal<Void, NoError>

    // MARK: - Private Properties

    private let store: StoreType
    private let contentChangedObserver: Observer<Void, NoError>
    private var contests = [Contest]()

    // MARK: - Lifecycle

    init(store: StoreType) {
        self.store = store

        let (refreshTrigger, refreshObserver) = SignalProducer<Void, NoError>.buffer(0)
        self.refreshObserver = refreshObserver

        let isLoading = MutableProperty<Bool>(false)
        self.isLoading = isLoading
        (contentChanged, contentChangedObserver) = Signal<Void, NoError>.pipe()

        active.producer
            .filter { $0 }
            .map { _ in () }
            .start(refreshObserver)

        refreshTrigger
            .on(next: { _ in isLoading.value = true })
            .flatMap(.Latest) { _ in
                return store.fetchContests()
                    .flatMapError { error in
                        return SignalProducer(value: [])
                    }
            }
            .on(next: { _ in isLoading.value = false })
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
