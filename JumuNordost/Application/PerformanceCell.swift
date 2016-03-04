//
//  PerformanceCell.swift
//  JumuNordost
//
//  Created by Martin Richter on 21/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Cartography

class PerformanceCell: UITableViewCell {

    private let timeLabel = Label(fontWeight: .Bold, fontStyle: .Normal, fontSize: .Medium)
    private let categoryInfoLabel = Label(fontWeight: .Bold, fontStyle: .Normal, fontSize: .Medium)
    private let mainAppearancesLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)
    private let accompanistsLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)
    private let predecessorInfoLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)

    // MARK: - Lifecycle

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        mainAppearancesLabel.numberOfLines = 0
        accompanistsLabel.numberOfLines = 0

        contentView.addSubview(timeLabel)
        contentView.addSubview(categoryInfoLabel)
        contentView.addSubview(predecessorInfoLabel)
        contentView.addSubview(mainAppearancesLabel)
        contentView.addSubview(accompanistsLabel)

        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func makeConstraints() {
        constrain(contentView, timeLabel) { contentView, timeLabel in
            timeLabel.top == contentView.topMargin
            timeLabel.left == contentView.leftMargin
            timeLabel.width == 45
        }

        constrain(categoryInfoLabel, timeLabel, contentView) { categoryInfoLabel, timeLabel, contentView in
            align(top: timeLabel, categoryInfoLabel)

            categoryInfoLabel.left == timeLabel.right + 8
            categoryInfoLabel.right == contentView.rightMargin
        }

        constrain(categoryInfoLabel, mainAppearancesLabel, accompanistsLabel, predecessorInfoLabel, contentView) { categoryInfoLabel, mainAppearancesLabel, accompanistsLabel, predecessorInfoLabel, contentView in
            align(left: categoryInfoLabel, mainAppearancesLabel, accompanistsLabel, predecessorInfoLabel)
            align(right: categoryInfoLabel, mainAppearancesLabel, accompanistsLabel, predecessorInfoLabel)

            mainAppearancesLabel.top == categoryInfoLabel.bottom + 8
            accompanistsLabel.top == mainAppearancesLabel.bottom

            predecessorInfoLabel.top == accompanistsLabel.bottom + 8
            predecessorInfoLabel.bottom == contentView.bottomMargin
        }
    }

    // MARK: - Content

    func configure(performance: FormattedListPerformance) {
        timeLabel.text = performance.stageTime
        categoryInfoLabel.text = "\(performance.category), \(performance.ageGroup)"
        mainAppearancesLabel.text = performance.mainAppearances
        accompanistsLabel.text = performance.accompanists
        predecessorInfoLabel.text = performance.predecessorInfo
    }
}
