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
    let selectedVenueIndex = MutableProperty<Int?>(nil)

    private let dateSwitcher: UISegmentedControl
    private let venueSwitcher: UISegmentedControl

    // MARK: - Lifecycle

    init(dateStrings: [String], venueNames: [String]) {
        dateSwitcher = UISegmentedControl(items: dateStrings)
        venueSwitcher = UISegmentedControl(items: venueNames)

        super.init(frame: CGRectZero)

        selectedDateIndex.producer.startWithNext { [weak self] index in
            self?.dateSwitcher.selectedSegmentIndex = index ?? -1
        }

        selectedVenueIndex.producer.startWithNext { [weak self] index in
            self?.venueSwitcher.selectedSegmentIndex = index ?? -1
        }

        dateSwitcher.addTarget(self, action: Selector("dateSwitcherChanged:"), forControlEvents: .ValueChanged)
        venueSwitcher.addTarget(self, action: Selector("venueSwitcherChanged:"), forControlEvents: .ValueChanged)

        addSubview(dateSwitcher)
        addSubview(venueSwitcher)

        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func makeConstraints() {
        constrain(self, dateSwitcher, venueSwitcher) { superview, dateSwitcher, venueSwitcher in
            dateSwitcher.top == superview.topMargin
            dateSwitcher.left == superview.leftMargin
            dateSwitcher.right == superview.rightMargin
            venueSwitcher.top == dateSwitcher.bottom + 8
            venueSwitcher.left == superview.leftMargin
            venueSwitcher.right == superview.rightMargin
            venueSwitcher.bottom == superview.bottomMargin
        }
    }

    // MARK: - User Interaction

    func dateSwitcherChanged(switcher: UISegmentedControl) {
        selectedDateIndex.value = switcher.selectedSegmentIndex
    }

    func venueSwitcherChanged(switcher: UISegmentedControl) {
        selectedVenueIndex.value = switcher.selectedSegmentIndex
    }
}
