//
//  StoreType.swift
//  JumuNordost
//
//  Created by Martin Richter on 14/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import ReactiveCocoa

typealias ContestDay = NSDateComponents

protocol StoreType {

    // MARK: - Contests

    func fetchContests(currentOnly currentOnly: Bool, timetablesPublic: Bool) -> SignalProducer<[Contest], NSError>

    // MARK: - Performances

    func fetchPerformances(contest contest: Contest, venue: Venue, day: ContestDay) -> SignalProducer<[Performance], NSError>
}
