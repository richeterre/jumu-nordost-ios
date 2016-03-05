//
//  Credentials.swift
//  JumuNordost
//
//  Created by Martin Richter on 05/03/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Foundation

class CredentialsHelper {
    static func apiKey() -> String? {
        guard let
            credentialsPath = NSBundle.mainBundle().pathForResource("Credentials", ofType: "plist"),
            credentials = NSDictionary(contentsOfFile: credentialsPath)
            else {
                return nil
        }

        return credentials["ApiKey"] as? String
    }
}
