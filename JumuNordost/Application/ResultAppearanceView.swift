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
    private let ratingLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Small)
    private let advancementBadge = AdvancementBadge()

    // MARK: - Lifecycle

    init(appearance: FormattedResultAppearance) {
        super.init(frame: CGRectZero)

        participantLabel.numberOfLines = 0

        participantLabel.text = "\(appearance.name), \(appearance.instrument)"
        pointsLabel.text = appearance.points
        prizeLabel.text = appearance.prize
        ratingLabel.text = shorten(appearance.rating)
        advancementBadge.hidden = !(appearance.advancesToNextRound ?? false)

        self.addSubview(participantLabel)
        self.addSubview(pointsLabel)
        self.addSubview(prizeLabel)
        self.addSubview(ratingLabel)
        self.addSubview(advancementBadge)

        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func makeConstraints() {
        constrain(self, participantLabel, pointsLabel, prizeLabel, advancementBadge) { superview, participantLabel, pointsLabel, prizeLabel, advancementBadge in
            participantLabel.top == superview.top
            participantLabel.left == superview.left
            participantLabel.bottom == superview.bottom

            pointsLabel.left == participantLabel.right + 8
            pointsLabel.width == 20

            prizeLabel.left == pointsLabel.right + 8
            prizeLabel.width == 55

            advancementBadge.left == prizeLabel.right + 2
            advancementBadge.width == 30
            advancementBadge.right == superview.right

            align(top: participantLabel, pointsLabel, prizeLabel)
            align(centerY: prizeLabel, advancementBadge)
        }

        constrain(self, pointsLabel, prizeLabel, ratingLabel) { superview, pointsLabel, prizeLabel, ratingLabel in
            align(left: prizeLabel, ratingLabel)
            align(baseline: pointsLabel, ratingLabel)
            ratingLabel.right == superview.right
        }
    }
}

// Shortens an appearance result's textual rating for display, if possible.
private func shorten(rating: String?) -> String? {
    guard let rating = rating else { return nil }

    // Note the thin spaces between one-letter abbreviations
    switch rating {
    case "mit hervorragendem Erfolg teilgenommen":
        return "m. h. E. teilgen."
    case "mit sehr gutem Erfolg teilgenommen":
        return "m. s. g. E. teilg."
    case "mit gutem Erfolg teilgenommen":
        return "m. g. E. teilgen."
    case "mit Erfolg teilgenommen":
        return "m. E. teilgen."
    case "teilgenommen":
        return "teilgen."
    default:
        return rating
    }
}
