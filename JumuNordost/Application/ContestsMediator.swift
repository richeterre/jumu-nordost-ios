//
//  ContestsMediator.swift
//  JumuNordost
//
//  Created by Martin Richter on 13/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa
import Result

class ContestsMediator: Mediator {

    // MARK: - Private Properties

    private var contests = [Contest]()
    private lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        formatter.timeStyle = .NoStyle
        formatter.locale = NSLocale.autoupdatingCurrentLocale()
        return formatter
    }()

    // MARK: - Lifecycle

    override init(store: StoreType) {
        super.init(store: store)

        let isLoading = self.isLoading

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
        return contestAtIndexPath(indexPath).name
    }

    func datesForContestAtIndexPath(indexPath: NSIndexPath) -> String {
        let contest = contestAtIndexPath(indexPath)
        dateFormatter.timeZone = contest.timeZone

        let (startDate, endDate) = (contest.startDate, contest.endDate)

        if startDate == endDate {
            return dateFormatter.stringFromDate(startDate)
        } else {
            return "\(dateFormatter.stringFromDate(startDate)) – \(dateFormatter.stringFromDate(endDate))"
        }
    }

    // MARK: - Mediators

    func performancesMediatorForContestAtIndexPath(indexPath: NSIndexPath) -> PerformancesMediator {
        let contest = contestAtIndexPath(indexPath)
        return PerformancesMediator(store: self.store, contest: contest)
    }

    // MARK: - Private Helpers

    private func contestAtIndexPath(indexPath: NSIndexPath) -> Contest {
        return contests[indexPath.row]
    }
}
