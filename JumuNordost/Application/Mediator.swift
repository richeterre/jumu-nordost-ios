//
//  Mediator.swift
//  JumuNordost
//
//  Created by Martin Richter on 14/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa
import Result

class Mediator {

    // MARK: - Inputs

    let active = MutableProperty<Bool>(false)
    let refreshObserver: Observer<Void, NoError>

    // MARK: - Outputs

    let isLoading: MutableProperty<Bool>

    // MARK: - Internal Properties

    let store: StoreType
    let refreshTrigger: SignalProducer<Void, NoError>

    // MARK: - Lifecycle

    init(store: StoreType) {
        self.store = store

        (refreshTrigger, refreshObserver) = SignalProducer<Void, NoError>.buffer(0)

        let isLoading = MutableProperty<Bool>(false)
        self.isLoading = isLoading

        active.producer
            .filter { $0 }
            .map { _ in () }
            .start(refreshObserver)
    }
}
