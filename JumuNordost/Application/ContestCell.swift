//
//  ContestCell.swift
//  JumuNordost
//
//  Created by Martin Richter on 14/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Cartography

class ContestCell: UITableViewCell {

    static let height: CGFloat = 64

    private let nameLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Large)
    private let datesLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Small)

    // MARK: - Lifecycle

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(nameLabel)
        contentView.addSubview(datesLabel)

        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func makeConstraints() {
        constrain(contentView, nameLabel, datesLabel, block: { superview, nameLabel, datesLabel in
            nameLabel.top == superview.topMargin
            nameLabel.left == superview.leftMargin

            align(left: nameLabel, datesLabel)

            datesLabel.bottom == superview.bottomMargin
        })
    }

    // MARK: - Content

    func configure(formattedContest: FormattedContest) {
        nameLabel.text = formattedContest.name
        datesLabel.text = formattedContest.dates
    }
}
