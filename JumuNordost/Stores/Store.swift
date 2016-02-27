//
//  Store.swift
//  JumuNordost
//
//  Created by Martin Richter on 13/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Argo
import ReactiveCocoa

class Store: StoreType {
    func fetchContests(currentOnly currentOnly: Bool, timetablesPublic: Bool) -> SignalProducer<[Contest], NSError> {

        let queryItems = [
            NSURLQueryItem(name: "current_only", value: queryValueForBool(currentOnly)),
            NSURLQueryItem(name: "timetables_public", value: queryValueForBool(timetablesPublic))
        ]
        let request = requestForPath("contests", queryItems: queryItems)

        return NSURLSession.sharedSession().rac_dataWithRequest(request)
            .map { data, response in
                if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []),
                    contests: [Contest] = decode(json) {
                        return contests
                } else {
                    return []
                }
            }
    }

    func fetchPerformances(contest contest: Contest, venue: Venue, day: ContestDay) -> SignalProducer<[Performance], NSError> {

        let dateString = "\(day.year)-\(day.month)-\(day.day)"

        let queryItems = [
            NSURLQueryItem(name: "venue_id", value: venue.id),
            NSURLQueryItem(name: "date", value: dateString)
        ]

        let path = String(format: "contests/%@/performances", arguments: [contest.id])
        let request = requestForPath(path, queryItems: queryItems)

        return NSURLSession.sharedSession().rac_dataWithRequest(request)
            .map { data, response in
                if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []),
                    performances: [Performance] = decode(json) {
                        return performances
                } else {
                    return []
                }
            }
    }

    // MARK: - Private Helpers

    private func requestForPath(path: String, queryItems: [NSURLQueryItem] = []) -> NSURLRequest {
        let url = NSURL(string: path, relativeToURL: Constant.baseURL)!
        let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)!

        components.queryItems = queryItems

        return NSURLRequest(URL: components.URL!)
    }
}

/// Returns an API-compatible value for the given boolean.
func queryValueForBool(bool: Bool) -> String {
    return bool ? "1" : "0"
}
