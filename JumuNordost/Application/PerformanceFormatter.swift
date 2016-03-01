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
    let pieces: [FormattedPiece]
}

class PerformanceFormatter {

    // MARK: - Formatting

    static func formattedPerformance(performance: Performance, contest: Contest, venue: Venue) -> FormattedPerformance {

        let stageTimeFormatter: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .FullStyle
            formatter.timeStyle = .ShortStyle
            formatter.locale = NSLocale.autoupdatingCurrentLocale()
            formatter.timeZone = contest.timeZone
            return formatter
        }()

        return FormattedPerformance(
            category: performance.categoryName,
            ageGroup: String(format: localize("FORMAT.AGE_GROUP"), performance.ageGroup),
            stageTime: stageTimeFormatter.stringFromDate(performance.stageTime),
            venue: venue.name,
            mainAppearances: AppearanceFormatter.formattedMainAppearances(performance: performance),
            accompanists: AppearanceFormatter.formattedAccompanists(performance: performance, highlightAgeGroup: true),
            pieces: performance.pieces.map(PieceFormatter.formattedPiece)
        )
    }
}
