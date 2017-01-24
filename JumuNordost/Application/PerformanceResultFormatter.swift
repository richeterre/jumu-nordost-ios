//
//  PerformanceResultFormatter.swift
//  JumuNordost
//
//  Created by Martin Richter on 15/01/2017.
//  Copyright © 2017 Martin Richter. All rights reserved.
//

import Foundation

struct FormattedPerformanceResult {
    let category: String
    let ageGroup: String
    let mainAppearances: String
    let accompanists: String
    let predecessorInfo: String?
}

class PerformanceResultFormatter {

    // MARK: - Formatting

    static func formattedPerformanceResult(performance: Performance, contest: Contest) -> FormattedPerformanceResult {

        return FormattedPerformanceResult(
            category: performance.categoryName,
            ageGroup: String(format: localize("FORMAT.AGE_GROUP_SHORT"), performance.ageGroup),
            mainAppearances: AppearanceFormatter.formattedMainAppearances(performance: performance),
            accompanists: AppearanceFormatter.formattedAccompanists(performance: performance, highlightAgeGroup: false),
            predecessorInfo: PerformanceFormatter.predecessorInfoForPerformance(performance)
        )
    }
}

