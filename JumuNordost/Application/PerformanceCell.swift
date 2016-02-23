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
    private let appearancesInfoLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)
    private let predecessorInfoLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)

    // MARK: - Lifecycle

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        appearancesInfoLabel.numberOfLines = 0

        contentView.addSubview(timeLabel)
        contentView.addSubview(categoryInfoLabel)
        contentView.addSubview(predecessorInfoLabel)
        contentView.addSubview(appearancesInfoLabel)

        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func makeConstraints() {
        constrain(contentView, timeLabel, categoryInfoLabel, predecessorInfoLabel, appearancesInfoLabel) { contentView, timeLabel, categoryInfoLabel, predecessorInfoLabel, appearancesInfoLabel in
            timeLabel.top == contentView.topMargin
            timeLabel.left == contentView.leftMargin
            timeLabel.width == 45

            align(top: timeLabel, categoryInfoLabel)

            categoryInfoLabel.left == timeLabel.right + 8
            categoryInfoLabel.right == contentView.rightMargin

            align(left: categoryInfoLabel, appearancesInfoLabel, predecessorInfoLabel)
            align(right: categoryInfoLabel, appearancesInfoLabel, predecessorInfoLabel)

            appearancesInfoLabel.top == categoryInfoLabel.bottom + 8

            predecessorInfoLabel.top == appearancesInfoLabel.bottom + 8
            predecessorInfoLabel.bottom == contentView.bottomMargin
        }
    }

    // MARK: - Content

    func configure(time time: String, category: String, ageGroup: String, appearances: String, predecessorInfo: String?) {
        timeLabel.text = time
        categoryInfoLabel.text = "\(category), \(ageGroup)"
        appearancesInfoLabel.text = appearances
        predecessorInfoLabel.text = predecessorInfo
    }
}