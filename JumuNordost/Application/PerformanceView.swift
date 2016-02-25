//
//  PerformanceView.swift
//  JumuNordost
//
//  Created by Martin Richter on 23/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Cartography

class PerformanceView: UIView {

    var category: String? {
        get { return categoryLabel.text }
        set { categoryLabel.text = newValue }
    }

    var ageGroup: String? {
        get { return ageGroupLabel.text }
        set { ageGroupLabel.text = newValue }
    }

    var stageTime: String? {
        get { return stageTimeLabel.text }
        set { stageTimeLabel.text = newValue }
    }

    private let categoryLabel = Label(fontWeight: .Bold, fontStyle: .Normal, fontSize: .Large)
    private let ageGroupLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Large)
    private let stageTimeLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(categoryLabel)
        addSubview(ageGroupLabel)
        addSubview(stageTimeLabel)

        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func makeConstraints() {
        constrain(self, categoryLabel, ageGroupLabel, stageTimeLabel) { superview, categoryLabel, ageGroupLabel, stageTimeLabel in
            categoryLabel.top == superview.top
            categoryLabel.left == superview.left
            categoryLabel.right <= superview.right

            ageGroupLabel.top == categoryLabel.bottom
            ageGroupLabel.right <= superview.right

            stageTimeLabel.top == ageGroupLabel.bottom + 8
            stageTimeLabel.bottom == superview.bottom

            align(left: categoryLabel, ageGroupLabel, stageTimeLabel)
        }
    }
}
