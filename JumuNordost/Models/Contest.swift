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
    let timeZone: NSTimeZone
    let startDate: NSDate
    let venues: [Venue]
}

// MARK: - Decodable

extension Contest: Decodable {
    static func create(id: String)(name: String)(timeZone: NSTimeZone)(startDate: NSDate)(venues: [Venue]) -> Contest {
        return Contest(id: id, name: name, timeZone: timeZone, startDate: startDate, venues: venues)
    }

    static func decode(json: JSON) -> Decoded<Contest> {
        let toTimeZone: String -> Decoded<NSTimeZone> = {
            .fromOptional(NSTimeZone(name: $0))
        }

        let jsonDateFormatter: NSDateFormatter = {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            return dateFormatter
        }()

        let toNSDate: String -> Decoded<NSDate> = {
            .fromOptional(jsonDateFormatter.dateFromString($0))
        }

        return Contest.create
            <^> json <| "id"
            <*> json <| "name"
            <*> (json <| "timeZone" >>- toTimeZone)
            <*> (json <| "startDate" >>- toNSDate)
            <*> json <|| "venues"
    }
}
