//
//  PerformancesMediator.swift
//  JumuNordost
//
//  Created by Martin Richter on 14/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa

class PerformancesMediator: Mediator {

    // MARK: - Private Properties

    var performances = [Performance]()

    // MARK: - Lifecycle

    init(store: StoreType, contest: Contest) {
        super.init(store: store)

        let venue = contest.venues.first! // TODO: Handle nil case
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        calendar.timeZone = contest.timeZone
        let date = calendar.components([.Day, .Month, .Year], fromDate: contest.startDate)

        let isLoading = self.isLoading

        refreshTrigger
            .on(next: { _ in isLoading.value = true })
            .flatMap(.Latest) { _ in
                return store.fetchPerformances(contest: contest, venue: venue, date: date)
                    .flatMapError { error in
                        return SignalProducer(value: [])
                }
            }
            .on(next: { _ in isLoading.value = false })
            .startWithNext { [weak self] performances in
                self?.performances = performances
                self?.contentChangedObserver.sendNext(())
        }
    }

    // MARK: - Data Source

    func numberOfPerformances() -> Int {
        return performances.count
    }

    func categoryNameForPerformanceAtIndexPath(indexPath: NSIndexPath) -> String {
        return performances[indexPath.row].categoryName
    }
}
