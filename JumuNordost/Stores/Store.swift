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
    func fetchContests() -> SignalProducer<[Contest], NSError> {

        let request = requestForPath("contests")
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

    func fetchPerformances(contest contest: Contest, venue: Venue, date: NSDateComponents) -> SignalProducer<[Performance], NSError> {

        let dateString = "\(date.year)-\(date.month)-\(date.day)"

        let queryItems = [
            NSURLQueryItem(name: "venue_id", value: venue.id),
            NSURLQueryItem(name: "local_date", value: dateString)
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
