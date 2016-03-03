//
//  Performance.swift
//  JumuNordost
//
//  Created by Martin Richter on 14/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Argo

struct Performance {
    let id: String
    let stageTime: NSDate
    let categoryName: String
    let ageGroup: String
    let predecessorHostName: String?
    let predecessorHostCountry: String?
    let appearances: [Appearance]
    let pieces: [Piece]
}

// MARK: - Equatable

extension Performance: Equatable {}

func ==(lhs: Performance, rhs: Performance) -> Bool {
    return lhs.id == rhs.id
}

// MARK: - Decodable

extension Performance: Decodable {
    private static func create(id: String)(stageTime: NSDate)(categoryName: String)(ageGroup: String)(predecessorHostName: String?)(predecessorHostCountry: String?)(appearances: [Appearance])(pieces: [Piece]) -> Performance {
        return Performance(
            id: id,
            stageTime: stageTime,
            categoryName: categoryName,
            ageGroup: ageGroup,
            predecessorHostName: predecessorHostName,
            predecessorHostCountry: predecessorHostCountry,
            appearances: appearances,
            pieces: pieces
        )
    }

    static func decode(json: JSON) -> Decoded<Performance> {
        return create // curry(self.init) is currently too complex to compile
            <^> json <| "id"
            <*> json <| "stage_time"
            <*> json <| "category_name"
            <*> json <| "age_group"
            <*> json <|? "predecessor_host_name"
            <*> json <|? "predecessor_host_country"
            <*> json <|| "appearances"
            <*> json <|| "pieces"
    }
}
