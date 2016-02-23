//
//  Label.swift
//  JumuNordost
//
//  Created by Martin Richter on 23/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import UIKit

class Label: UILabel {
    convenience init(fontWeight: FontWeight, fontStyle: FontStyle, fontSize: FontSize) {
        self.init()
        self.font = Font.fontWithWeight(fontWeight, style: fontStyle, size: fontSize)
        self.textColor = Color.primaryTextColor
    }
}
