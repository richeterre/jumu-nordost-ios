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

        func formattedAppearances(appearances: [Appearance], roles: [ParticipantRole]) -> String {

            func formattedAppearance(appearance: Appearance) -> String {
                var text = "\(appearance.participantName), \(appearance.instrument)"
                // Append age group if it differs from performance's age group
                if appearance.ageGroup != performance.ageGroup {
                    text += " (\(String(format: localize("FORMAT.AGE_GROUP_SHORT"), appearance.ageGroup)))"
                }
                return text
            }

            return appearances.filter { roles.contains($0.participantRole) }
                .map(formattedAppearance)
                .joinWithSeparator("\n")
        }

        return FormattedPerformance(
            category: performance.categoryName,
            ageGroup: String(format: localize("FORMAT.AGE_GROUP"), performance.ageGroup),
            stageTime: stageTimeFormatter.stringFromDate(performance.stageTime),
            venue: venue.name,
            mainAppearances: formattedAppearances(performance.appearances, roles: [.Soloist, .Ensemblist]),
            accompanists: formattedAppearances(performance.appearances, roles: [.Accompanist]),
            pieces: performance.pieces.map(PieceFormatter.formattedPiece)
        )
    }
}
