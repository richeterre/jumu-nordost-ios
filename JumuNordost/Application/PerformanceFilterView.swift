//
//  PerformanceFilterView.swift
//  JumuNordost
//
//  Created by Martin Richter on 20/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Cartography
import ReactiveCocoa

class PerformanceFilterView: UIView {

    let selectedDateIndex = MutableProperty<Int?>(nil)

    private let dateSwitcher: UISegmentedControl

    // MARK: - Lifecycle

    init(dateStrings: [String]) {
        dateSwitcher = UISegmentedControl(items: dateStrings)

        super.init(frame: CGRectZero)

        selectedDateIndex.producer.startWithNext { [weak self] index in
            self?.dateSwitcher.selectedSegmentIndex = index ?? -1
        }

        dateSwitcher.addTarget(self, action: Selector("dateSwitcherChanged:"), forControlEvents: .ValueChanged)

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

    // MARK: - User Interaction

    func dateSwitcherChanged(switcher: UISegmentedControl) {
        selectedDateIndex.value = switcher.selectedSegmentIndex
    }
}
