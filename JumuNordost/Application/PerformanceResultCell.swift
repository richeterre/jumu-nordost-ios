//
//  PerformanceResultCell.swift
//  JumuNordost
//
//  Created by Martin Richter on 15/01/2017.
//  Copyright © 2017 Martin Richter. All rights reserved.
//

import Cartography

class PerformanceResultCell: UITableViewCell {

    private let categoryInfoLabel = Label(fontWeight: .Bold, fontStyle: .Normal, fontSize: .Medium)
    private let mainAppearancesLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)
    private let accompanistsLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)
    private let predecessorInfoLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)

    // MARK: - Lifecycle

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        mainAppearancesLabel.numberOfLines = 0
        accompanistsLabel.numberOfLines = 0

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
        constrain(categoryInfoLabel, contentView) { categoryInfoLabel, contentView in
            categoryInfoLabel.top == contentView.topMargin

            categoryInfoLabel.left == contentView.leftMargin
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

    func configure(performanceResult: FormattedPerformanceResult) {
        categoryInfoLabel.text = "\(performanceResult.category), \(performanceResult.ageGroup)"
        mainAppearancesLabel.text = performanceResult.mainAppearances
        accompanistsLabel.text = performanceResult.accompanists
        predecessorInfoLabel.text = performanceResult.predecessorInfo
    }
}

