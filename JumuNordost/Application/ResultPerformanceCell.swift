//
//  ResultPerformanceCell.swift
//  JumuNordost
//
//  Created by Martin Richter on 15/01/2017.
//  Copyright © 2017 Martin Richter. All rights reserved.
//

import Cartography

class ResultPerformanceCell: UITableViewCell {

    private let categoryInfoLabel = Label(fontWeight: .Bold, fontStyle: .Normal, fontSize: .Medium)
    private let appearancesView = UIStackView()
    private let predecessorInfoLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)

    // MARK: - Lifecycle

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        appearancesView.axis = .Vertical

        contentView.addSubview(categoryInfoLabel)
        contentView.addSubview(predecessorInfoLabel)
        contentView.addSubview(appearancesView)

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
        constrain(categoryInfoLabel, contentView) { categoryInfoLabel, contentView in
            categoryInfoLabel.top == contentView.topMargin

            categoryInfoLabel.left == contentView.leftMargin
            categoryInfoLabel.right == contentView.rightMargin
        }

        constrain(categoryInfoLabel, appearancesView, predecessorInfoLabel, contentView) { categoryInfoLabel, appearancesView, predecessorInfoLabel, contentView in
            align(left: categoryInfoLabel, appearancesView, predecessorInfoLabel)
            align(right: categoryInfoLabel, appearancesView, predecessorInfoLabel)

            appearancesView.top == categoryInfoLabel.bottom + 8

            predecessorInfoLabel.top == appearancesView.bottom + 8
            predecessorInfoLabel.bottom == contentView.bottomMargin
        }
    }

    // MARK: - Content

    func configure(resultPerformance: FormattedResultPerformance) {
        categoryInfoLabel.text = "\(resultPerformance.category), \(resultPerformance.ageGroup)"

        resultPerformance.appearances.forEach({ appearance in
            let appearanceView = ResultAppearanceView(appearance: appearance)
            appearancesView.addArrangedSubview(appearanceView)
        })

        predecessorInfoLabel.text = resultPerformance.predecessorInfo
    }
}

