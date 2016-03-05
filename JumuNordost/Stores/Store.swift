//
//  Store.swift
//  JumuNordost
//
//  Created by Martin Richter on 13/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Argo
import ReactiveCocoa
import Result

class Store: StoreType {

    private let baseURL: NSURL
    private let errorDomain = "StoreError"

    private enum StoreError: Int {
        case ParsingError
    }

    // MARK: - Lifecycle

    required init(baseURL: NSURL) {
        self.baseURL = baseURL
    }

    // MARK: - Contests

    func fetchContests(currentOnly currentOnly: Bool, timetablesPublic: Bool) -> SignalProducer<[Contest], NSError> {

        let queryItems = [
            NSURLQueryItem(name: "current_only", value: queryValueForBool(currentOnly)),
            NSURLQueryItem(name: "timetables_public", value: queryValueForBool(timetablesPublic))
        ]
        let request = requestForPath("contests", queryItems: queryItems)

        return NSURLSession.sharedSession().rac_dataWithRequest(request)
            .attemptMap(decodeModels)
    }

    // MARK: - Performances

    func fetchPerformances(contest contest: Contest, venue: Venue, day: ContestDay) -> SignalProducer<[Performance], NSError> {

        let dateString = "\(day.year)-\(day.month)-\(day.day)"

        let queryItems = [
            NSURLQueryItem(name: "venue_id", value: venue.id),
            NSURLQueryItem(name: "date", value: dateString)
        ]

        let path = String(format: "contests/%@/performances", arguments: [contest.id])
        let request = requestForPath(path, queryItems: queryItems)

        return NSURLSession.sharedSession().rac_dataWithRequest(request)
            .attemptMap(decodeModels)
    }

    // MARK: - Private Helpers

    private func requestForPath(path: String, queryItems: [NSURLQueryItem] = []) -> NSURLRequest {
        let url = NSURL(string: path, relativeToURL: baseURL)!
        let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)!

        components.queryItems = queryItems

        return NSURLRequest(URL: components.URL!)
    }

    private func decodeModels<Model: Decodable where Model == Model.DecodedType>(data data: NSData, response: NSURLResponse) -> Result<[Model], NSError> {
        if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []),
            models: [Model] = decode(json) {
                return .Success(models)
        } else {
            let error = NSError(domain: errorDomain, code: StoreError.ParsingError.rawValue, userInfo: nil)
            return .Failure(error)
        }
    }
}

/// Returns an API-compatible value for the given boolean.
func queryValueForBool(bool: Bool) -> String {
    return bool ? "1" : "0"
}
