//
//  PerformanceView.swift
//  JumuNordost
//
//  Created by Martin Richter on 23/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Cartography

class PerformanceView: UIView {

    private let categoryLabel = Label(fontWeight: .Bold, fontStyle: .Normal, fontSize: .Large)
    private let ageGroupLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Large)
    private let stageTimeIcon = UIImageView(image: UIImage(named: "IconDate"))
    private let stageTimeLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)
    private let venueIcon = UIImageView(image: UIImage(named: "IconLocation"))
    private let venueLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)
    private let appearancesSeparator = SeparatorView()
    private let mainAppearancesLabel = Label(fontWeight: .Bold, fontStyle: .Normal, fontSize: .Medium)
    private let accompanistsLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)
    private let predecessorInfoLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)
    private let piecesSeparator = SeparatorView()
    private let piecesStackView: UIStackView

    // MARK: - Lifecycle

    init(performance: FormattedPerformance) {
        mainAppearancesLabel.numberOfLines = 0
        accompanistsLabel.numberOfLines = 0
        accompanistsLabel.textColor = Color.secondaryTextColor

        categoryLabel.text = performance.category
        ageGroupLabel.text = performance.ageGroup
        stageTimeLabel.text = performance.stageTime
        venueLabel.text = performance.venue
        mainAppearancesLabel.text = performance.mainAppearances
        accompanistsLabel.text = performance.accompanists
        predecessorInfoLabel.text = performance.predecessorInfo

        let pieceViews = performance.pieces.map(PieceView.init)
        piecesStackView = UIStackView(arrangedSubviews: pieceViews)
        piecesStackView.axis = .Vertical
        piecesStackView.spacing = 8

        super.init(frame: CGRectZero)

        addSubview(categoryLabel)
        addSubview(ageGroupLabel)
        addSubview(stageTimeIcon)
        addSubview(stageTimeLabel)
        addSubview(venueIcon)
        addSubview(venueLabel)
        addSubview(appearancesSeparator)
        addSubview(mainAppearancesLabel)
        addSubview(accompanistsLabel)
        addSubview(predecessorInfoLabel)
        addSubview(piecesSeparator)
        addSubview(piecesStackView)

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

        constrain(appearancesSeparator, venueLabel, self) { appearancesSeparator, venueLabel, superview in
            appearancesSeparator.top == venueLabel.bottom + 16
            appearancesSeparator.centerX == superview.centerXWithinMargins
            appearancesSeparator.width == superview.width * 0.7
        }

        constrain(mainAppearancesLabel, appearancesSeparator, self) { mainAppearancesLabel, appearancesSeparator, superview in
            mainAppearancesLabel.top == appearancesSeparator.bottom + 16
            mainAppearancesLabel.right <= superview.right
        }

        constrain(accompanistsLabel, mainAppearancesLabel, self) { accompanistsLabel, mainAppearancesLabel, superview in
            accompanistsLabel.top == mainAppearancesLabel.bottom
            accompanistsLabel.right <= superview.right
        }

        constrain(predecessorInfoLabel, accompanistsLabel, self) { predecessorInfoLabel, accompanistsLabel, superview in
            predecessorInfoLabel.top == accompanistsLabel.bottom + 8
            predecessorInfoLabel.right <= superview.right
        }

        constrain(piecesSeparator, predecessorInfoLabel, self) { piecesSeparator, predecessorInfoLabel, superview in
            piecesSeparator.top == predecessorInfoLabel.bottom + 16
        }

        constrain(piecesStackView, piecesSeparator, self) { piecesStackView, piecesSeparator, superview in
            piecesStackView.top == piecesSeparator.bottom + 16
            piecesStackView.right <= superview.right
        }

        constrain(piecesStackView, self) { piecesStackView, superview in
            piecesStackView.bottom == superview.bottom
        }

        constrain(categoryLabel, ageGroupLabel, stageTimeIcon, venueIcon, mainAppearancesLabel) { categoryLabel, ageGroupLabel, stageTimeIcon, venueIcon, mainAppearancesLabel in
            align(left: categoryLabel, ageGroupLabel, stageTimeIcon, venueIcon, mainAppearancesLabel)
        }

        constrain(mainAppearancesLabel, accompanistsLabel, predecessorInfoLabel, piecesStackView) { mainAppearancesLabel, accompanistsLabel, predecessorInfoLabel, piecesStackView in
            align(left: mainAppearancesLabel, accompanistsLabel, predecessorInfoLabel, piecesStackView)
        }

        constrain(appearancesSeparator, piecesSeparator) { appearancesSeparator, piecesSeparator in
            align(left: appearancesSeparator, piecesSeparator)
            align(right: appearancesSeparator, piecesSeparator)
        }
    }
}
