//
//  Piece.swift
//  JumuNordost
//
//  Created by Martin Richter on 23/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Argo
import Curry

struct Piece {
    let title: String
    let composerName: String
    let composerBorn: String
    let composerDied: String
}

// MARK: - Decodable

extension Piece: Decodable {
    static func decode(json: JSON) -> Decoded<Piece> {
        return curry(self.init)
            <^> json <| "title"
            <*> json <| "composer_name"
            <*> json <| "composer_born"
            <*> json <| "composer_died"
    }
}
