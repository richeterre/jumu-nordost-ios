//
//  String.swift
//  JumuNordost
//
//  Created by Martin Richter on 23/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

extension String {
    /// Returns an emoji country flag, assuming the string is a country code.
    /// (adapted from [this SO answer](http://stackoverflow.com/a/30403199/1194468))
    func toCountryFlag() -> String {
        let base : UInt32 = 127397
        var string = ""
        for scalar in self.unicodeScalars {
            string.append(UnicodeScalar(base + scalar.value))
        }
        return string
    }
}
