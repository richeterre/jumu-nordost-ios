//
//  ContestCategoryCell.swift
//  JumuNordost
//
//  Created by Martin Richter on 13/01/2017.
//  Copyright © 2017 Martin Richter. All rights reserved.
//

import Cartography

class ContestCategoryCell: UITableViewCell {

    private let nameLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)

    // MARK: - Lifecycle

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        nameLabel.numberOfLines = 0

        contentView.addSubview(nameLabel)

        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func makeConstraints() {
        constrain(contentView, nameLabel) { contentView, timeLabel in
            timeLabel.centerY == contentView.centerY
            timeLabel.left == contentView.leftMargin
            timeLabel.right == contentView.rightMargin
        }
    }

    // MARK: - Content

    func configure(contestCategory: ContestCategory) {
        nameLabel.text = contestCategory.name
    }
}
