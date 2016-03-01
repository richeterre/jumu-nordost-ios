//
//  AppearanceFormatter.swift
//  JumuNordost
//
//  Created by Martin Richter on 01/03/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Foundation

class AppearanceFormatter {

    // MARK: - Formatting

    static func formattedMainAppearances(performance performance: Performance) -> String {
        func formattedAppearance(appearance: Appearance) -> String {
            return "\(appearance.participantName), \(appearance.instrument)"
        }

        return performance.appearances
            .filter { [.Soloist, .Ensemblist].contains($0.participantRole) }
            .map(formattedAppearance)
            .joinWithSeparator("\n")
    }

    static func formattedAccompanists(performance performance: Performance, highlightAgeGroup: Bool) -> String {
        func formattedAppearance(appearance: Appearance) -> String {
            var text = "\(appearance.participantName), \(appearance.instrument)"
            // Append age group if necessary
            if highlightAgeGroup && appearance.ageGroup != performance.ageGroup {
                text += " (\(String(format: localize("FORMAT.AGE_GROUP_SHORT"), appearance.ageGroup)))"
            }
            return text
        }

        return performance.appearances
            .filter { $0.participantRole == .Accompanist }
            .map(formattedAppearance)
            .joinWithSeparator("\n")
    }
}
