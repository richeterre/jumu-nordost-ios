//
//  PerformanceListMediator.swift
//  JumuNordost
//
//  Created by Martin Richter on 14/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa

class PerformanceListMediator: Mediator {

    // MARK: - Inputs

    var selectedDayIndex: MutableProperty<Int?>
    var selectedVenueIndex: MutableProperty<Int?>

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
    private let selectedVenue = MutableProperty<Venue?>(nil)

    private var performances = [Performance]()

    private lazy var contestDayFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.autoupdatingCurrentLocale()
        return formatter
    }()
    private lazy var stageTimeFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.autoupdatingCurrentLocale()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
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
        selectedVenueIndex = MutableProperty(contest.venues.isEmpty ? nil : 0)

        selectedDay <~ selectedDayIndex.producer.map { index in
            guard let index = index else { return nil }
            return contestDays[index]
        }

        selectedVenue <~ selectedVenueIndex.producer.map { index in
            guard let index = index else { return nil }
            return contest.venues[index]
        }

        super.init(store: store)

        // Dates are shown in contest's, not user's time zone
        contestDayFormatter.timeZone = contest.timeZone

        // Set contest day format according to amount of days
        let template = contestDays.count > 2 ? "EEEMMMMd" : "EEEEMMMMd"
        let locale = NSLocale.autoupdatingCurrentLocale()
        contestDayFormatter.dateFormat = NSDateFormatter.dateFormatFromTemplate(template, options: 0, locale: locale)

        let isLoading = self.isLoading

        let daySelection = selectedDay.producer.ignoreNil()
        let venueSelection = selectedVenue.producer.ignoreNil()
        let combinedRefreshTriggers = combineLatest(refreshTrigger, daySelection, venueSelection)

        combinedRefreshTriggers
            .on(next: { _ in isLoading.value = true })
            .flatMap(.Latest) { _, day, venue in
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
            return contestDayFormatter.stringFromDate(date)
        }
    }

    func venueNames() -> [String] {
        return contest.venues.map { $0.name }
    }

    // MARK: - Performances

    func numberOfPerformances() -> Int {
        return performances.count
    }

    func timeForPerformanceAtIndexPath(indexPath: NSIndexPath) -> String {
        let time = performanceAtIndexPath(indexPath).stageTime
        return stageTimeFormatter.stringFromDate(time)
    }

    func categoryNameForPerformanceAtIndexPath(indexPath: NSIndexPath) -> String {
        return performanceAtIndexPath(indexPath).categoryName
    }

    func ageGroupForPerformanceAtIndexPath(indexPath: NSIndexPath) -> String {
        return "AG " + performanceAtIndexPath(indexPath).ageGroup
    }

    // MARK: - Private Helpers

    func performanceAtIndexPath(indexPath: NSIndexPath) -> Performance {
        return performances[indexPath.row]
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
