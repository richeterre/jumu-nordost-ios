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

    // MARK: - Private Properties

    private let performance: Performance

    // MARK: - Lifecycle

    init(store: StoreType, performance: Performance, contest: Contest) {
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

        super.init(store: store)
    }
}
