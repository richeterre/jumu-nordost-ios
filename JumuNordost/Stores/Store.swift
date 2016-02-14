//
//  Store.swift
//  JumuNordost
//
//  Created by Martin Richter on 13/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Argo
import ReactiveCocoa

enum Endpoint: String {
    case Contests = "contests"
}

class Store: StoreType {
    func fetchContests() -> SignalProducer<[Contest], NSError> {
        let request = requestForEndpoint(.Contests)
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

    // MARK: - Private Helpers

    private func requestForEndpoint(endpoint: Endpoint) -> NSURLRequest {
        let url = NSURL(string: endpoint.rawValue, relativeToURL: Constant.baseURL)!
        return NSURLRequest(URL: url)
    }
}
