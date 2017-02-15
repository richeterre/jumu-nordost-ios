//
//  AppearanceResult.swift
//  JumuNordost
//
//  Created by Martin Richter on 07/02/2017.
//  Copyright © 2017 Martin Richter. All rights reserved.
//

import Argo
import Curry

struct AppearanceResult {
    let points: Int
    let prize: String?
    let advancesToNextRound: Bool
}

// MARK: - Decodable

extension AppearanceResult: Decodable {
    static func decode(json: JSON) -> Decoded<AppearanceResult> {
        return curry(self.init)
            <^> json <| "points"
            <*> json <|? "prize"
            <*> json <| "advances_to_next_round"
    }
}

