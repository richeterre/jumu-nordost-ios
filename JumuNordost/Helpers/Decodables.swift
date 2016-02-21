//
//  Decodables.swift
//  JumuNordost
//
//  Created by Martin Richter on 21/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Argo

extension NSDate: Decodable {
    static var dateFormatter: NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        return dateFormatter
    }

    public static func decode(json: JSON) -> Decoded<NSDate> {
        switch(json) {
        case .String(let dateString):
            return .fromOptional(dateFormatter.dateFromString(dateString))
        default:
            return Decoded<NSDate>.typeMismatch("date", actual: json.description)
        }
    }
}

extension NSTimeZone: Decodable {
    public static func decode(json: JSON) -> Decoded<NSTimeZone> {
        switch json {
        case .String(let name):
            return .fromOptional(NSTimeZone(name: name))
        default:
            return Decoded<NSTimeZone>.typeMismatch("time zone", actual: json.description)
        }
    }
}
