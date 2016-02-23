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

    var title: String {
        return performance.categoryName
    }

    var categoryName: String {
        return performance.categoryName
    }

    // MARK: - Private Properties

    private let performance: Performance

    // MARK: - Lifecycle

    init(store: StoreType, performance: Performance) {
        self.performance = performance

        super.init(store: store)
    }
}
