//
//  Font.swift
//  JumuNordost
//
//  Created by Martin Richter on 22/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import UIKit

enum FontSize: CGFloat {
    case Small = 14
    case Medium = 16
    case Large = 19
}

enum FontStyle {
    case Normal
    case Italic
}

enum FontWeight {
    case Light
    case Regular
    case Bold
}

struct Font {
    static func fontWithWeight(weight: FontWeight, style: FontStyle, size: FontSize) -> UIFont {
        let fontName = fontNameForWeight(weight, style: style)
        return UIFont(name: fontName, size: size.rawValue)!
    }

    private static func fontNameForWeight(weight: FontWeight, style: FontStyle) -> String {
        switch (weight, style) {
        case (.Light, .Normal):
            return "Lato-Light"
        case (.Light, .Italic):
            return "Lato-LightItalic"
        case (.Regular, .Normal):
            return "Lato-Regular"
        case (.Regular, .Italic):
            return "Lato-Italic"
        case (.Bold, .Normal):
            return "Lato-Bold"
        case (.Bold, .Italic):
            return "Lato-BoldItalic"
        }
    }
}
