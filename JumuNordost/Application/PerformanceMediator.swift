//
//  PerformanceMediator.swift
//  JumuNordost
//
//  Created by Martin Richter on 21/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Foundation

class PerformanceMediator: Mediator {

    // MARK: - Outputs

    let title: String

    let category: String
    let ageGroup: String
    let stageTime: String
    let venue: String
    let mainAppearances: String
    let accompanists: String

    // MARK: - Private Properties

    private let performance: Performance

    // MARK: - Lifecycle

    init(store: StoreType, performance: Performance, contest: Contest, venue: Venue) {
        self.performance = performance

        let titleFormatter: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .ShortStyle
            formatter.locale = NSLocale.autoupdatingCurrentLocale()
            formatter.timeZone = contest.timeZone
            return formatter
        }()
        title = titleFormatter.stringFromDate(performance.stageTime)

        category = performance.categoryName
        ageGroup = String(format: localize("FORMAT.AGE_GROUP"), performance.ageGroup)

        let stageTimeFormatter: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .FullStyle
            formatter.timeStyle = .ShortStyle
            formatter.locale = NSLocale.autoupdatingCurrentLocale()
            formatter.timeZone = contest.timeZone
            return formatter
        }()
        stageTime = stageTimeFormatter.stringFromDate(performance.stageTime)

        self.venue = venue.name

        func formattedAppearances(appearances: [Appearance], roles: [ParticipantRole]) -> String {
            return appearances.filter { roles.contains($0.participantRole) }
                .map { "\($0.participantName), \($0.instrument)" }
                .joinWithSeparator("\n")
        }

        mainAppearances = formattedAppearances(performance.appearances, roles: [.Soloist, .Ensemblist])
        accompanists = formattedAppearances(performance.appearances, roles: [.Accompanist])

        super.init(store: store)
    }
}
