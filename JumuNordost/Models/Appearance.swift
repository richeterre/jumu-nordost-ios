//
//  Appearance.swift
//  JumuNordost
//
//  Created by Martin Richter on 21/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Argo
import Curry

enum ParticipantRole: String {
    case Soloist = "soloist"
    case Ensemblist = "ensemblist"
    case Accompanist = "accompanist"
}

struct Appearance {
    let participantName: String
    let participantRole: ParticipantRole
    let instrument: String
}

// MARK: - Decodable

extension ParticipantRole: Decodable {}

extension Appearance: Decodable {
    static func decode(json: JSON) -> Decoded<Appearance> {
        return curry(self.init)
            <^> json <| "participant_name"
            <*> json <| "participant_role"
            <*> json <| "instrument_name"
    }
}
