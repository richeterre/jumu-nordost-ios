//
//  ResultPerformanceCell.swift
//  JumuNordost
//
//  Created by Martin Richter on 15/01/2017.
//  Copyright © 2017 Martin Richter. All rights reserved.
//

import Cartography

class ResultPerformanceCell: UITableViewCell {

    private let appearancesView = UIStackView()
    private let generalInfoLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)

    // MARK: - Lifecycle

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        appearancesView.axis = .Vertical

        contentView.addSubview(appearancesView)
        contentView.addSubview(generalInfoLabel)

        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        appearancesView.removeAllArrangedSubviews()
    }

    // MARK: - Layout

    private func makeConstraints() {
        constrain(appearancesView, contentView) { appearancesView, contentView in
            appearancesView.top == contentView.topMargin

            appearancesView.left == contentView.leftMargin
            appearancesView.right == contentView.rightMargin
        }

        constrain(appearancesView, generalInfoLabel, contentView) { appearancesView, generalInfoLabel, contentView in
            align(left: appearancesView, generalInfoLabel)
            align(right: appearancesView, generalInfoLabel)

            generalInfoLabel.top == appearancesView.bottom + 8
            generalInfoLabel.bottom == contentView.bottomMargin
        }
    }

    // MARK: - Content

    func configure(resultPerformance: FormattedResultPerformance) {
        resultPerformance.appearances.forEach({ appearance in
            let appearanceView = ResultAppearanceView(appearance: appearance)
            appearancesView.addArrangedSubview(appearanceView)
        })

        if let predecessorInfo = resultPerformance.predecessorInfo {
            generalInfoLabel.text = "\(predecessorInfo), \(resultPerformance.ageGroup)"
        } else {
            generalInfoLabel.text = resultPerformance.ageGroup
        }
    }
}

