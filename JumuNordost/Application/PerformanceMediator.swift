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
    let formattedPerformance: FormattedPerformance

    // MARK: - Private Properties

    private let performance: Performance

    // MARK: - Lifecycle

    init(store: StoreType, performance: Performance, contest: Contest, venue: Venue) {
        self.performance = performance

        let titleFormatter: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .ShortStyle
            formatter.locale = NSLocale.localeMatchingAppLanguage()
            formatter.timeZone = contest.timeZone
            return formatter
        }()
        title = titleFormatter.stringFromDate(performance.stageTime)

        formattedPerformance = PerformanceFormatter.formattedPerformance(performance, contest: contest, venue: venue)

        super.init(store: store)
    }
}
