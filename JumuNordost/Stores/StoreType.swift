//
//  StoreType.swift
//  JumuNordost
//
//  Created by Martin Richter on 14/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa

protocol StoreType {

    // MARK: - Contests

    func fetchContests() -> SignalProducer<[Contest], NSError>

    // MARK: - Performances

    func fetchPerformances(contest contest: Contest, venue: Venue, date: NSDateComponents) -> SignalProducer<[Performance], NSError>
}
