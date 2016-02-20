//
//  PerformanceFilterView.swift
//  JumuNordost
//
//  Created by Martin Richter on 20/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Cartography

class PerformanceFilterView: UIView {

    private let dateSwitcher: UISegmentedControl

    // MARK: - Lifecycle

    init(dateStrings: [String]) {
        dateSwitcher = UISegmentedControl(items: dateStrings)

        super.init(frame: CGRectZero)

        addSubview(dateSwitcher)
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func makeConstraints() {
        constrain(dateSwitcher, self) { dateSwitcher, superview in
            dateSwitcher.edges == superview.edgesWithinMargins
        }
    }
}
