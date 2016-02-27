//
//  PerformanceFormatter.swift
//  JumuNordost
//
//  Created by Martin Richter on 27/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Foundation

struct FormattedPerformance {
    let category: String
    let ageGroup: String
    let stageTime: String
    let venue: String
    let mainAppearances: String
    let accompanists: String
}

class PerformanceFormatter {

    // MARK: - Formatting

    static func formattedPerformance(performance: Performance, contest: Contest, venue: Venue) -> FormattedPerformance {

        let category = performance.categoryName
        let ageGroup = String(format: localize("FORMAT.AGE_GROUP"), performance.ageGroup)

        let stageTimeFormatter: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .FullStyle
            formatter.timeStyle = .ShortStyle
            formatter.locale = NSLocale.autoupdatingCurrentLocale()
            formatter.timeZone = contest.timeZone
            return formatter
        }()
        let stageTime = stageTimeFormatter.stringFromDate(performance.stageTime)

        let venue = venue.name

        func formattedAppearances(appearances: [Appearance], roles: [ParticipantRole]) -> String {
            return appearances.filter { roles.contains($0.participantRole) }
                .map { "\($0.participantName), \($0.instrument)" }
                .joinWithSeparator("\n")
        }

        let mainAppearances = formattedAppearances(performance.appearances, roles: [.Soloist, .Ensemblist])
        let accompanists = formattedAppearances(performance.appearances, roles: [.Accompanist])

        return FormattedPerformance(
            category: category,
            ageGroup: ageGroup,
            stageTime: stageTime,
            venue: venue,
            mainAppearances: mainAppearances,
            accompanists: accompanists
        )
    }
}
