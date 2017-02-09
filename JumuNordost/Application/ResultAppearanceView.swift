//
//  ResultAppearanceView.swift
//  JumuNordost
//
//  Created by Martin Richter on 07/02/2017.
//  Copyright © 2017 Martin Richter. All rights reserved.
//

import Cartography

class ResultAppearanceView: UIView {

    private let participantLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)
    private let pointsLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)
    private let prizeLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)

    // MARK: - Lifecycle

    init(appearance: FormattedResultAppearance) {
        super.init(frame: CGRectZero)

        participantLabel.numberOfLines = 0

        participantLabel.text = "\(appearance.name), \(appearance.instrument)"
        pointsLabel.text = appearance.points
        prizeLabel.text = appearance.prize

        self.addSubview(participantLabel)
        self.addSubview(pointsLabel)
        self.addSubview(prizeLabel)

        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func makeConstraints() {
        constrain(self, participantLabel, pointsLabel, prizeLabel) { superview, participantLabel, pointsLabel, prizeLabel in
            participantLabel.top == superview.top
            participantLabel.left == superview.left
            participantLabel.bottom == superview.bottom

            pointsLabel.left == participantLabel.right + 8
            pointsLabel.width == 20

            prizeLabel.left == pointsLabel.right + 8
            prizeLabel.right == superview.right
            prizeLabel.width == 50

            align(top: participantLabel, pointsLabel, prizeLabel)
        }
    }
}
