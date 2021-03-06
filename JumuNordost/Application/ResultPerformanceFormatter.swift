//
//  ResultPerformanceFormatter.swift
//  JumuNordost
//
//  Created by Martin Richter on 15/01/2017.
//  Copyright © 2017 Martin Richter. All rights reserved.
//

import Foundation

struct FormattedResultAppearance {
    let name: String
    let instrument: String
    let points: String?
    let prize: String?
    let rating: String?
    let advancesToNextRound: Bool?
}

struct FormattedResultPerformance {
    let ageGroup: String
    let appearances: [FormattedResultAppearance]
    let predecessorInfo: String?
}

class ResultPerformanceFormatter {

    // MARK: - Formatting

    static func formattedResultPerformance(performance: Performance, contest: Contest) -> FormattedResultPerformance {

        func formattedResultAppearance(appearance: Appearance) -> FormattedResultAppearance {
            return FormattedResultAppearance(
                name: appearance.participantName,
                instrument: appearance.instrument,
                points: pointsForAppearance(appearance),
                prize: appearance.result?.prize,
                rating: appearance.result?.rating,
                advancesToNextRound: appearance.result?.advancesToNextRound
            )
        }

        return FormattedResultPerformance(
            ageGroup: String(format: localize("FORMAT.AGE_GROUP_SHORT"), performance.ageGroup),
            appearances: performance.appearances.map(formattedResultAppearance),
            predecessorInfo: PerformanceFormatter.predecessorInfoForPerformance(performance)
        )
    }

    private static func pointsForAppearance(appearance: Appearance) -> String? {
        if let result = appearance.result {
            return String(result.points)
        } else {
            return nil
        }
    }
}

