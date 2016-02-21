//
//  PerformanceCell.swift
//  JumuNordost
//
//  Created by Martin Richter on 21/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Cartography

class PerformanceCell: UITableViewCell {

    private let timeLabel = UILabel()
    private let categoryLabel = UILabel()
    private let ageGroupLabel = UILabel()
    private let predecessorHostNameLabel = UILabel()

    // MARK: - Lifecycle

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(timeLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(ageGroupLabel)
        contentView.addSubview(predecessorHostNameLabel)

        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func makeConstraints() {
        constrain(contentView, timeLabel, categoryLabel, ageGroupLabel) { contentView, timeLabel, categoryLabel, ageGroupLabel in
            timeLabel.top == contentView.topMargin
            timeLabel.left == contentView.leftMargin

            align(top: timeLabel, categoryLabel)

            categoryLabel.left == timeLabel.right + 16

            align(left: categoryLabel, ageGroupLabel)

            ageGroupLabel.top == categoryLabel.bottom
            ageGroupLabel.bottom == contentView.bottomMargin
        }
    }

    // MARK: - Content

    func configure(time time: String, category: String, ageGroup: String) {
        timeLabel.text = time
        categoryLabel.text = category
        ageGroupLabel.text = ageGroup
    }
}
