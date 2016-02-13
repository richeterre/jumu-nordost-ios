//
//  Contest.swift
//  JumuNordost
//
//  Created by Martin Richter on 13/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Argo

struct Contest {
    let id: String
    let name: String
    let venues: [Venue]
}

// MARK: - Decodable

extension Contest: Decodable {
    static func create(id: String)(name: String)(venues: [Venue]) -> Contest {
        return Contest(id: id, name: name, venues: venues)
    }

    static func decode(json: JSON) -> Decoded<Contest> {
        return Contest.create
            <^> json <| "id"
            <*> json <| "name"
            <*> json <|| "venues"
    }
}
