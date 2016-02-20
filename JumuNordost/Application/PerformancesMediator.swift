//
//  PerformancesMediator.swift
//  JumuNordost
//
//  Created by Martin Richter on 14/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa

class PerformancesMediator: Mediator {

    // MARK: - Inputs

    var selectedDayIndex: MutableProperty<Int?>

    // MARK: - Outputs

    var title: String {
        get {
            return contest.name
        }
    }

    // MARK: - Private Properties

    private let contest: Contest
    private let contestDays: [ContestDay]
    private let selectedDay = MutableProperty<ContestDay?>(nil)

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

        let calendar = calendarForContest(contest)
        let contestDays = datesForContest(contest).map { date in
            calendar.components([.Day, .Month, .Year], fromDate: date)
        }
        self.contestDays = contestDays

        selectedDayIndex = MutableProperty(contestDays.isEmpty ? nil : 0)

        selectedDay <~ selectedDayIndex.producer.map { index in
            guard let index = index else { return nil }
            return contestDays[index]
        }

        super.init(store: store)

        // Dates are shown in contest's, not user's time zone
        dateFormatter.timeZone = contest.timeZone

        let isLoading = self.isLoading

        let daySelection = selectedDay.producer.ignoreNil()
        let venue = contest.venues.first! // TODO: Handle nil case
        let combinedRefreshTriggers = combineLatest(refreshTrigger, daySelection)

        combinedRefreshTriggers
            .on(next: { _ in isLoading.value = true })
            .flatMap(.Latest) { _, day in
                return store.fetchPerformances(contest: contest, venue: venue, day: day)
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

    func formattedContestDays() -> [String] {
        let calendar = calendarForContest(contest)
        return contestDays.map { day in
            let date = calendar.dateFromComponents(day)!
            return dateFormatter.stringFromDate(date)
        }
    }

    // MARK: - Performances

    func numberOfPerformances() -> Int {
        return performances.count
    }

    func categoryNameForPerformanceAtIndexPath(indexPath: NSIndexPath) -> String {
        return performances[indexPath.row].categoryName
    }
}

/// Returns an array of dates representing all calendar days between (and including) the given dates.
func datesForContest(contest: Contest) -> [NSDate] {
    let calendar = calendarForContest(contest)

    let normalizedStartDate = calendar.startOfDayForDate(contest.startDate)
    let normalizedEndDate = calendar.startOfDayForDate(contest.endDate)

    var dates = [normalizedStartDate]
    var currentDate = normalizedStartDate
    while !calendar.isDate(currentDate, inSameDayAsDate: normalizedEndDate)
        && currentDate.compare(normalizedEndDate) == .OrderedAscending {
            currentDate = calendar.dateByAddingUnit(.Day, value: 1, toDate: currentDate, options: .MatchNextTime)!
            dates.append(currentDate)
    }

    return dates
}

/// Returns a calendar configured with the contest's time zone.
func calendarForContest(contest: Contest) -> NSCalendar {
    let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
    calendar.timeZone = contest.timeZone
    return calendar
}
