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

    typealias ContestChangeset = Changeset<Contest>

    // MARK: - Inputs

    let showCurrentOnly = MutableProperty<Bool>(true)

    // MARK: - Outputs

    let contentChanges: Signal<ContestChangeset, NoError>

    // MARK: - Private Properties

    private let contentChangesObserver: Observer<ContestChangeset, NoError>
    private var contests = [Contest]()

    // MARK: - Lifecycle

    override init(store: StoreType) {
        (contentChanges, contentChangesObserver) = Signal<ContestChangeset, NoError>.pipe()

        super.init(store: store)

        let isLoading = self.isLoading

        let combinedRefreshTriggers = combineLatest(refreshTrigger, showCurrentOnly.producer)

        func displayedContentMatches(lhs: Contest, rhs: Contest) -> Bool {
            return lhs.name == rhs.name
                && lhs.timeZone == rhs.timeZone
                && lhs.startDate == rhs.startDate
                && lhs.endDate == rhs.endDate
        }

        combinedRefreshTriggers
            .on(next: { _ in isLoading.value = true })
            .flatMap(.Latest) { (_, currentOnly) in
                return store.fetchContests(currentOnly: currentOnly, timetablesPublic: true)
                    .flatMapError { error in
                        return SignalProducer(value: [])
                }
            }
            .on(next: { _ in isLoading.value = false })
            .combinePrevious([]) // needed to calculate changeset
            .startWithNext { [weak self] (oldContests, newContests) in
                self?.contests = newContests
                if let observer = self?.contentChangesObserver {
                    let changeset = Changeset(
                        oldItems: oldContests,
                        newItems: newContests,
                        contentMatches: displayedContentMatches
                    )
                    observer.sendNext(changeset)
                }
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
