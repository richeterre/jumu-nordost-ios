//
//  PieceView.swift
//  JumuNordost
//
//  Created by Martin Richter on 27/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Cartography

class PieceView: UIView {

    private let composerInfoLabel = Label(fontWeight: .Bold, fontStyle: .Normal, fontSize: .Medium)
    private let titleLabel = Label(fontWeight: .Regular, fontStyle: .Normal, fontSize: .Medium)

    // MARK: - Lifecycle

    init(piece: FormattedPiece) {
        super.init(frame: CGRectZero)

        composerInfoLabel.numberOfLines = 0
        titleLabel.numberOfLines = 0

        composerInfoLabel.text = piece.composerInfo
        titleLabel.text = piece.title

        addSubview(composerInfoLabel)
        addSubview(titleLabel)

        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func makeConstraints() {
        constrain(self, composerInfoLabel, titleLabel) { superview, composerInfoLabel, titleLabel in
            composerInfoLabel.top == superview.top
            composerInfoLabel.left == superview.left
            composerInfoLabel.right == superview.right

            distribute(by: 0, vertically: composerInfoLabel, titleLabel)

            align(left: composerInfoLabel, titleLabel)
            align(right: composerInfoLabel, titleLabel)

            titleLabel.bottom == superview.bottom
        }
    }
}
