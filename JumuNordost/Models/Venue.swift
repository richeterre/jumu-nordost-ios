//
//  Venue.swift
//  JumuNordost
//
//  Created by Martin Richter on 13/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Argo
import Curry

struct Venue {
    let id: String
    let name: String
}

// MARK: - Decodable

extension Venue: Decodable {
    static func decode(json: JSON) -> Decoded<Venue> {
        return curry(self.init)
            <^> json <| "id"
            <*> json <| "name"
    }
}
