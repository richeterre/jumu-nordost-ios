//
//  Localization.swift
//  JumuNordost
//
//  Created by Martin Richter on 14/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Foundation

/// Returns a localized string for the given key.
func localize(key: String) -> String {
    return NSLocalizedString(key, comment: "")
}