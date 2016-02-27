//
//  Color.swift
//  JumuNordost
//
//  Created by Martin Richter on 19/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import UIKit

struct Color {
    static let primaryColor = UIColor(hex: 0xC82432)
    static let primaryTextColor = UIColor(hex: 0x333333)
    static let secondaryTextColor = UIColor(hex: 0x666666)
    static let barTintColor = UIColor(hex: 0xBD0215)
    static let separatorColor = UIColor(hex: 0xE9E9E9)
}

extension UIColor {
    convenience init(hex: UInt32) {
        let mask = 0x000000FF
        let r = Int(hex >> 16) & mask
        let g = Int(hex >> 8) & mask
        let b = Int(hex) & mask

        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
