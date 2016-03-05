//
//  PerformanceListMediator.swift
//  JumuNordost
//
//  Created by Martin Richter on 14/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa
import Result

class PerformanceListMediator: Mediator {

    typealias PerformanceChangeset = Changeset<Performance>

    // MARK: - Inputs

    var selectedDayIndex: MutableProperty<Int?>
    var selectedVenueIndex: MutableProperty<Int?>

    // MARK: - Outputs

    let contentChanges: Signal<PerformanceChangeset, NoError>

    var hasError: Bool = false
    var hasEmptyPerformanceList: Bool {
        return performances?.isEmpty ?? false
    }

    var title: String {
        return contest.name
    }

    // MARK: - Private Properties

    private let contest: Contest
    private let contestDays: [ContestDay]
    private let selectedDay = MutableProperty<ContestDay?>(nil)
    private let selectedVenue = MutableProperty<Venue?>(nil)
    private let contentChangesObserver: Observer<PerformanceChangeset, NoError>

    private var performances: [Performance]? = nil // nil means nothing was fetched, [] no results

    private lazy var contestDayFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.autoupdatingCurrentLocale()
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

        (contentChanges, contentChangesObserver) = Signal<PerformanceChangeset, NoError>.pipe()

        super.init(store: store)

        // Dates are shown in contest's, not user's time zone
        contestDayFormatter.timeZone = contest.timeZone

        // Set contest day format according to amount of days
        let template: String = {
            switch contestDays.count {
              case 0...2:
                return "EEEEMMMMd"
              case 3:
                return "EEEEMd"
              default:
                return "EEEMd"
            }
        }()
        let locale = NSLocale.autoupdatingCurrentLocale()
        contestDayFormatter.dateFormat = NSDateFormatter.dateFormatFromTemplate(template, options: 0, locale: locale)

        let isLoading = self.isLoading

        let daySelection = selectedDay.producer.ignoreNil()
        let venueSelection = selectedVenue.producer.ignoreNil()
        let combinedRefreshTriggers = combineLatest(refreshTrigger, daySelection, venueSelection)

        func displayedContentMatches(lhs: Performance, rhs: Performance) -> Bool {
            return false // TODO: Compare performance content
        }

        combinedRefreshTriggers
            .on(next: { _ in isLoading.value = true })
            .flatMap(.Latest) { (_, day, venue) -> SignalProducer<[Performance]?, NoError> in
                return store.fetchPerformances(contest: contest, venue: venue, day: day)
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
        return performances?.count ?? 0
    }

    func numberOfAppearancesForPerformanceAtIndexPath(indexPath: NSIndexPath) -> Int {
        return performanceAtIndexPath(indexPath).appearances.count
    }

    func predecessorInfoPresentForPerformanceAtIndexPath(indexPath: NSIndexPath) -> Bool {
        return performanceAtIndexPath(indexPath).predecessorHostName != nil
    }

    func formattedListPerformanceForIndexPath(indexPath: NSIndexPath) -> FormattedListPerformance {
        let performance = performanceAtIndexPath(indexPath)
        return ListPerformanceFormatter.formattedListPerformance(performance, contest: contest)
    }

    // MARK: - Mediators

    func mediatorForPerformanceAtIndexPath(indexPath: NSIndexPath) -> PerformanceMediator {
        let performance = performanceAtIndexPath(indexPath)
        let venue = selectedVenue.value! // This being nil here is a programming error

        return PerformanceMediator(store: store, performance: performance, contest: contest, venue: venue)
    }

    // MARK: - Private Helpers

    private func performanceAtIndexPath(indexPath: NSIndexPath) -> Performance {
        return performances![indexPath.row]
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
