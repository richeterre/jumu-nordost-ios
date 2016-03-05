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

    private static let dateIntervalFormatter: NSDateIntervalFormatter = {
        let formatter = NSDateIntervalFormatter()
        formatter.dateStyle = .LongStyle
        formatter.timeStyle = .NoStyle
        formatter.locale = NSLocale.localeMatchingAppLanguage()
        return formatter
    }()

    // MARK: - Formatting

    static func formattedContest(contest: Contest) -> FormattedContest {

        dateIntervalFormatter.timeZone = contest.timeZone // TODO: Eliminate this state

        return FormattedContest(
            name: contest.name,
            dates: dateIntervalFormatter.stringFromDate(contest.startDate, toDate: contest.endDate)
        )
    }
}
