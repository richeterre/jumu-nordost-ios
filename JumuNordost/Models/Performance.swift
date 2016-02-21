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
    let stageTime: NSDate
    let categoryName: String
    let ageGroup: String
    let predecessorHostName: String?
}

// MARK: - Decodable

extension Performance: Decodable {
    static func decode(json: JSON) -> Decoded<Performance> {
        return curry(self.init)
            <^> json <| "stage_time"
            <*> json <| "category_name"
            <*> json <| "age_group"
            <*> json <|? "predecessor_host_name"
    }
}
