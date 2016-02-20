//
//  PerformancesMediator.swift
//  JumuNordost
//
//  Created by Martin Richter on 14/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa

class PerformancesMediator: Mediator {

    // MARK: - Internal Properties

    var title: String {
        get {
            return contest.name
        }
    }

    // MARK: - Private Properties

    private let contest: Contest
    private var performances = [Performance]()
    private lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        let locale = NSLocale.autoupdatingCurrentLocale()
        formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("MMMMd", options: 0, locale: locale)
        formatter.locale = locale
        return formatter
    }()

    // MARK: - Lifecycle

    init(store: StoreType, contest: Contest) {
        self.contest = contest

        super.init(store: store)

        // Dates are shown in contest's, not user's time zone
        dateFormatter.timeZone = contest.timeZone

        let venue = contest.venues.first! // TODO: Handle nil case
        let calendar = calendarForContest(contest)
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

    // MARK: - Contest

    func contestDates() -> [String] {
        return daysBoundedBy(startDate: contest.startDate, endDate: contest.endDate)
            .map { dateFormatter.stringFromDate($0) }
    }

    // MARK: - Performances

    func numberOfPerformances() -> Int {
        return performances.count
    }

    func categoryNameForPerformanceAtIndexPath(indexPath: NSIndexPath) -> String {
        return performances[indexPath.row].categoryName
    }

    /// Returns an array of dates representing all calendar days between (and including) the given dates.
    private func daysBoundedBy(startDate startDate: NSDate, endDate: NSDate) -> [NSDate] {
        let calendar = calendarForContest(contest)

        let normalizedStartDate = calendar.startOfDayForDate(startDate)
        let normalizedEndDate = calendar.startOfDayForDate(endDate)

        var dates = [normalizedStartDate]
        var currentDate = normalizedStartDate
        repeat {
            currentDate = calendar.dateByAddingUnit(.Day, value: 1, toDate: currentDate, options: .MatchNextTime)!
            dates.append(currentDate)
        } while !calendar.isDate(currentDate, inSameDayAsDate: normalizedEndDate)

        return dates
    }

    /// Returns a calendar configured with the contest's time zone.
    private func calendarForContest(contest: Contest) -> NSCalendar {
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        calendar.timeZone = contest.timeZone
        return calendar
    }
}
