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

    var venue: String? {
        get { return venueLabel.text }
        set { venueLabel.text = newValue }
    }

    var mainAppearances: String? {
        get { return mainAppearancesLabel.text }
        set { mainAppearancesLabel.text = newValue }
    }

    private let categoryLabel = Label(fontWeight: .Bold, fontStyle: .Normal, fontSize: .Large)
    private let ageGroupLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Large)
    private let stageTimeIcon = UIImageView(image: UIImage(named: "IconDate"))
    private let stageTimeLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)
    private let venueIcon = UIImageView(image: UIImage(named: "IconLocation"))
    private let venueLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)
    private let mainAppearancesLabel = Label(fontWeight: .Bold, fontStyle: .Normal, fontSize: .Medium)

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        mainAppearancesLabel.numberOfLines = 0

        addSubview(categoryLabel)
        addSubview(ageGroupLabel)
        addSubview(stageTimeIcon)
        addSubview(stageTimeLabel)
        addSubview(venueIcon)
        addSubview(venueLabel)
        addSubview(mainAppearancesLabel)

        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func makeConstraints() {
        constrain(categoryLabel, self) { categoryLabel, superview in
            categoryLabel.top == superview.top
            categoryLabel.left == superview.left
            categoryLabel.right <= superview.right
        }

        constrain(ageGroupLabel, categoryLabel, self) { ageGroupLabel, categoryLabel, superview in
            ageGroupLabel.top == categoryLabel.bottom
            ageGroupLabel.right <= superview.right
        }

        constrain(stageTimeIcon, stageTimeLabel, ageGroupLabel) { stageTimeIcon, stageTimeLabel, ageGroupLabel in
            stageTimeLabel.top == ageGroupLabel.bottom + 16
            stageTimeLabel.left == stageTimeIcon.right + 8
            align(centerY: stageTimeIcon, stageTimeLabel)
        }

        constrain(venueIcon, venueLabel, stageTimeLabel) { venueIcon, venueLabel, stageTimeLabel in
            venueLabel.top == stageTimeLabel.bottom + 4
            venueLabel.left == venueIcon.right + 8
            align(centerY: venueIcon, venueLabel)
        }

        constrain(mainAppearancesLabel, venueLabel, self) { mainAppearancesLabel, venueLabel, superview in
            mainAppearancesLabel.top == venueLabel.bottom + 16
            mainAppearancesLabel.right <= superview.right
        }

        constrain(mainAppearancesLabel, self) { mainAppearancesLabel, superview in
            mainAppearancesLabel.bottom == superview.bottom
        }

        constrain(categoryLabel, ageGroupLabel, stageTimeIcon, venueIcon, mainAppearancesLabel) { categoryLabel, ageGroupLabel, stageTimeIcon, venueIcon, mainAppearancesLabel in
            align(left: categoryLabel, ageGroupLabel, stageTimeIcon, venueIcon, mainAppearancesLabel)
        }
    }
}
