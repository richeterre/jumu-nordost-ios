//
//  Performance.swift
//  JumuNordost
//
//  Created by Martin Richter on 14/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Argo
import Curry

struct Performance {
    let categoryName: String
}

// MARK: - Decodable

extension Performance: Decodable {
    static func decode(json: JSON) -> Decoded<Performance> {
        return curry(self.init)
            <^> json <| "category_name"
    }
}
