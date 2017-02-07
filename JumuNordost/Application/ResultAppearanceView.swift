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

    // MARK: - Lifecycle

    init(appearance: FormattedResultAppearance) {
        super.init(frame: CGRectZero)

        participantLabel.numberOfLines = 0
        pointsLabel.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        pointsLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)

        participantLabel.text = "\(appearance.name), \(appearance.instrument)"
        pointsLabel.text = appearance.points

        self.addSubview(participantLabel)
        self.addSubview(pointsLabel)

        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func makeConstraints() {
        constrain(self, participantLabel, pointsLabel) { superview, participantLabel, pointsLabel in
            participantLabel.top == superview.top
            participantLabel.left == superview.left
            participantLabel.bottom == superview.bottom
            pointsLabel.left == participantLabel.right + 8
            pointsLabel.right == superview.right
            pointsLabel.bottom == participantLabel.bottom
        }
    }
}
