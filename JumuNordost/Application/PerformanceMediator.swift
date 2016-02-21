//
//  PerformanceMediator.swift
//  JumuNordost
//
//  Created by Martin Richter on 21/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Foundation

class PerformanceMediator: Mediator {

    private let performance: Performance

    init(store: StoreType, performance: Performance) {
        self.performance = performance

        super.init(store: store)
    }

}
