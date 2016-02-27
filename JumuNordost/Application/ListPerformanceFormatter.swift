//
//  ListPerformanceFormatter.swift
//  JumuNordost
//
//  Created by Martin Richter on 24/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Foundation

struct FormattedListPerformance {
    let stageTime: String
    let category: String
    let ageGroup: String
    let appearances: String
    let predecessorInfo: String?
}

class ListPerformanceFormatter {

    private static let stageTimeFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.autoupdatingCurrentLocale()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }()

    // MARK: - Formatting

    static func formattedListPerformance(performance: Performance) -> FormattedListPerformance {
        let appearances = performance.appearances.map { appearance in
            return "\(appearance.participantName), \(appearance.instrument)"
        }.joinWithSeparator("\n")

        return FormattedListPerformance(
            stageTime: stageTimeFormatter.stringFromDate(performance.stageTime),
            category: performance.categoryName,
            ageGroup: String(format: localize("FORMAT.AGE_GROUP_SHORT"), performance.ageGroup),
            appearances: appearances,
            predecessorInfo: predecessorInfoForPerformance(performance)
        )
    }

    // MARK: - Private Helpers

    private static func predecessorInfoForPerformance(performance: Performance) -> String? {
        let name = performance.predecessorHostName
        let flag = performance.predecessorHostCountry?.toCountryFlag()

        switch (name, flag) {
        case let (name?, flag?):
            return "\(flag) \(name)"
        default:
            return name
        }
    }
}
