//
//  ContestCategory.swift
//  JumuNordost
//
//  Created by Martin Richter on 13/01/2017.
//  Copyright © 2017 Martin Richter. All rights reserved.
//

import Argo
import Curry

struct ContestCategory {
    let id: String
    let name: String
}

// MARK: - Decodable

extension ContestCategory: Decodable {
    static func decode(json: JSON) -> Decoded<ContestCategory> {
        return curry(self.init)
            <^> json <| "id"
            <*> json <| "name"
    }
}

