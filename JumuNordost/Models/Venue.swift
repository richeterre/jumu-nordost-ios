//
//  Venue.swift
//  JumuNordost
//
//  Created by Martin Richter on 13/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Argo

struct Venue {
    let id: String
    let name: String
}

// MARK: - Decodable

extension Venue: Decodable {
    static func create(id: String)(name: String) -> Venue {
        return Venue(id: id, name: name)
    }

    static func decode(json: JSON) -> Decoded<Venue> {
        return Venue.create
            <^> json <| "id"
            <*> json <| "name"
    }
}
