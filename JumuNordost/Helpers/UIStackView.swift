//
//  UIStackView.swift
//  JumuNordost
//
//  Created by Martin Richter on 07/02/2017.
//  Copyright © 2017 Martin Richter. All rights reserved.
//

import UIKit

extension UIStackView {

    /// Removes all arranged subviews from the stack view.
    func removeAllArrangedSubviews() {
        self.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
}
