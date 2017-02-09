//
//  ResultListMediator.swift
//  JumuNordost
//
//  Created by Martin Richter on 14/01/2017.
//  Copyright © 2017 Martin Richter. All rights reserved.
//

import ReactiveCocoa
import Result

class ResultListMediator: Mediator {

    typealias PerformanceChangeset = Changeset<Performance>

    // MARK: - Outputs

    let contentChanges: Signal<PerformanceChangeset, NoError>

    var hasError: Bool = false
    var hasEmptyResultList: Bool {
        return performances?.isEmpty ?? false
    }

    var title: String {
        return contestCategory.name
    }

    // MARK: - Private Properties

    private let contest: Contest
    private let contestCategory: ContestCategory
    private let contentChangesObserver: Observer<PerformanceChangeset, NoError>

    private var performances: [Performance]? = nil // nil means nothing was fetched, [] no results

    // MARK: - Lifecycle

    init(store: StoreType, contest: Contest, contestCategory: ContestCategory) {
        self.contest = contest
        self.contestCategory = contestCategory

        (contentChanges, contentChangesObserver) = Signal<PerformanceChangeset, NoError>.pipe()

        super.init(store: store)

        let isLoading = self.isLoading

        func displayedContentMatches(lhs: Performance, rhs: Performance) -> Bool {
            return false // TODO: Compare performance content
        }

        refreshTrigger
            .on(next: { _ in isLoading.value = true })
            .flatMap(.Latest) { (_) -> SignalProducer<[Performance]?, NoError> in
                return store.fetchPerformances(
                    contest: contest,
                    contestCategory: contestCategory,
                    resultsPublic: true
                )
                .map { .Some($0) }
                .flatMapError { error in
                    return SignalProducer(value: nil)
                }
            }
            .on(next: { [weak self] performances in
                isLoading.value = false
                self?.hasError = (performances == nil)
            })
            .combinePrevious(nil) // needed to calculate changeset
            .startWithNext { [weak self] (oldPerformances, newPerformances) in
                self?.performances = newPerformances
                if let observer = self?.contentChangesObserver {
                    let changeset = Changeset(
                        oldItems: oldPerformances ?? [],
                        newItems: newPerformances ?? [],
                        contentMatches: displayedContentMatches
                    )
                    observer.sendNext(changeset)
                }
            }
    }

    // MARK: - Performances

    func numberOfPerformances() -> Int {
        return performances?.count ?? 0
    }

    func numberOfAppearancesForPerformanceAtIndexPath(indexPath: NSIndexPath) -> Int {
        return performanceAtIndexPath(indexPath).appearances.count
    }

    func predecessorInfoPresentForPerformanceAtIndexPath(indexPath: NSIndexPath) -> Bool {
        return performanceAtIndexPath(indexPath).predecessorHostName != nil
    }

    func formattedResultPerformanceForIndexPath(indexPath: NSIndexPath) -> FormattedResultPerformance {
        let performance = performanceAtIndexPath(indexPath)
        return ResultPerformanceFormatter.formattedResultPerformance(performance, contest: contest)
    }

    // MARK: - Private Helpers

    private func performanceAtIndexPath(indexPath: NSIndexPath) -> Performance {
        return performances![indexPath.row]
    }
}
