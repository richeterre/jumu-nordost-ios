//
//  ContestListMediator.swift
//  JumuNordost
//
//  Created by Martin Richter on 13/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa
import Result

class ContestListMediator: Mediator {

    // MARK: - Inputs

    let showCurrentOnly = MutableProperty<Bool>(true)

    // MARK: - Private Properties

    private var contests = [Contest]()

    // MARK: - Lifecycle

    override init(store: StoreType) {
        super.init(store: store)

        let isLoading = self.isLoading

        let combinedRefreshTriggers = combineLatest(refreshTrigger, showCurrentOnly.producer)

        combinedRefreshTriggers
            .on(next: { _ in isLoading.value = true })
            .flatMap(.Latest) { (_, currentOnly) in
                return store.fetchContests(currentOnly: currentOnly, timetablesPublic: true)
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

    // MARK: - User Interaction

    func toggleFilterState() {
        showCurrentOnly.value = !showCurrentOnly.value
    }

    // MARK: - Contests

    func numberOfContests() -> Int {
        return contests.count
    }

    func formattedContestForIndexPath(indexPath: NSIndexPath) -> FormattedContest {
        let contest = contestAtIndexPath(indexPath)
        return ContestFormatter.formattedContest(contest)
    }

    // MARK: - Mediators

    func performanceListMediatorForContestAtIndexPath(indexPath: NSIndexPath) -> PerformanceListMediator {
        let contest = contestAtIndexPath(indexPath)
        return PerformanceListMediator(store: self.store, contest: contest)
    }

    // MARK: - Private Helpers

    private func contestAtIndexPath(indexPath: NSIndexPath) -> Contest {
        return contests[indexPath.row]
    }
}
