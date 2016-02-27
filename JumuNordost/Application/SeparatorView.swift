//
//  SeparatorView.swift
//  JumuNordost
//
//  Created by Martin Richter on 27/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import UIKit

class SeparatorView: UIView {

    // MARK: - Lifecycle

    init() {
        super.init(frame: CGRectZero)
        self.backgroundColor = Color.separatorColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 1)
    }
}
