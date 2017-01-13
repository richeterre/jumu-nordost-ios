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

    let contestMediatorsSelected: Signal<ContestMediators, NoError>
    let contentChanges: Signal<ContestChangeset, NoError>

    var hasError: Bool = false
    var hasEmptyContestList: Bool {
        return contests?.isEmpty ?? false
    }

    // MARK: - Private Properties

    private let contestMediatorsSelectedObserver: Observer<ContestMediators, NoError>
    private let contentChangesObserver: Observer<ContestChangeset, NoError>
    private var contests: [Contest]? = nil

    // MARK: - Lifecycle

    override init(store: StoreType) {
        (contestMediatorsSelected, contestMediatorsSelectedObserver)
            = Signal<ContestMediators, NoError>.pipe()

        (contentChanges, contentChangesObserver) = Signal<ContestChangeset, NoError>.pipe()

        super.init(store: store)

        let isLoading = self.isLoading
        var hasError = self.hasError

        let combinedRefreshTriggers = combineLatest(refreshTrigger, showCurrentOnly.producer)

        func displayedContentMatches(lhs: Contest, rhs: Contest) -> Bool {
            return lhs.name == rhs.name
                && lhs.timeZone == rhs.timeZone
                && lhs.startDate == rhs.startDate
                && lhs.endDate == rhs.endDate
        }

        combinedRefreshTriggers
            .on(next: { _ in isLoading.value = true })
            .flatMap(.Latest) { (_, currentOnly) -> SignalProducer<[Contest]?, NoError> in
                return store.fetchContests(currentOnly: currentOnly, timetablesPublic: true)
                    .map { .Some($0) }
                    .flatMapError { error in
                        return SignalProducer(value: nil)
                }
            }
            .on(next: { [weak self] contests in
                isLoading.value = false
                self?.hasError = (contests == nil)
            })
            .combinePrevious(nil) // needed to calculate changeset
            .startWithNext { [weak self] (oldContests, newContests) in
                self?.contests = newContests
                if let observer = self?.contentChangesObserver {
                    let changeset = Changeset(
                        oldItems: oldContests ?? [],
                        newItems: newContests ?? [],
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
        return contests?.count ?? 0
    }

    func formattedContestForIndexPath(indexPath: NSIndexPath) -> FormattedContest {
        let contest = contestAtIndexPath(indexPath)
        return ContestFormatter.formattedContest(contest)
    }

    // MARK: - Contest Selection

    func selectContestAtIndexPath(indexPath: NSIndexPath) {
        let contest = contestAtIndexPath(indexPath)

        let performanceListMediator = PerformanceListMediator(store: self.store, contest: contest)
        let resultGroupListMediator = ResultGroupListMediator(store: self.store, contest: contest)

        let contestMediators = (performanceListMediator, resultGroupListMediator)
        contestMediatorsSelectedObserver.sendNext(contestMediators)
    }

    // MARK: - Private Helpers

    private func contestAtIndexPath(indexPath: NSIndexPath) -> Contest {
        return contests![indexPath.row]
    }
}
