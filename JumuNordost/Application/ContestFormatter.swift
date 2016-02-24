//
//  ContestFormatter.swift
//  JumuNordost
//
//  Created by Martin Richter on 24/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Foundation

struct FormattedContest {
    let name: String
    let dates: String
}

class ContestFormatter {

    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        formatter.timeStyle = .NoStyle
        formatter.locale = NSLocale.autoupdatingCurrentLocale()
        return formatter
    }()

    // MARK: - Formatting

    static func formattedContest(contest: Contest) -> FormattedContest {

        dateFormatter.timeZone = contest.timeZone // TODO: Eliminate this state

        let (startDate, endDate) = (contest.startDate, contest.endDate)

        let dates: String = {
            if startDate == endDate {
                return dateFormatter.stringFromDate(startDate)
            } else {
                return [startDate, endDate].map(dateFormatter.stringFromDate).joinWithSeparator(" – ")
            }
        }()

        return FormattedContest(
            name: contest.name,
            dates: dates
        )
    }
}
