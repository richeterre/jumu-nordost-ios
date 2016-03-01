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
    let mainAppearances: String
    let accompanists: String
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

        func formattedAppearance(appearance: Appearance) -> String {
            return "\(appearance.participantName), \(appearance.instrument)"
        }

        let mainAppearances = performance.appearances
            .filter { [.Soloist, .Ensemblist].contains($0.participantRole) }
            .map(formattedAppearance)
            .joinWithSeparator("\n")

        let accompanists = performance.appearances
            .filter { $0.participantRole == .Accompanist }
            .map(formattedAppearance)
            .joinWithSeparator("\n")

        return FormattedListPerformance(
            stageTime: stageTimeFormatter.stringFromDate(performance.stageTime),
            category: performance.categoryName,
            ageGroup: String(format: localize("FORMAT.AGE_GROUP_SHORT"), performance.ageGroup),
            mainAppearances: mainAppearances,
            accompanists: accompanists,
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
