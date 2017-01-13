//
//  Contest.swift
//  JumuNordost
//
//  Created by Martin Richter on 13/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Argo
import Curry

struct Contest {
    let id: String
    let name: String
    let hostCountry: String
    let timeZone: NSTimeZone
    let startDate: NSDate
    let endDate: NSDate
    let contestCategories: [ContestCategory]
    let venues: [Venue]
}

// MARK: - Equatable

extension Contest: Equatable {}

func ==(lhs: Contest, rhs: Contest) -> Bool {
    return lhs.id == rhs.id
}

// MARK: - Decodable

extension Contest: Decodable {
    static func decode(json: JSON) -> Decoded<Contest> {
        return curry(self.init)
            <^> json <| "id"
            <*> json <| "name"
            <*> json <| "host_country"
            <*> json <| "time_zone"
            <*> json <| "start_date"
            <*> json <| "end_date"
            <*> json <|| "contest_categories"
            <*> json <|| "venues"
    }
}
