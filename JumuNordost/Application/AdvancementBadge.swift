//
//  AdvancementBadge.swift
//  JumuNordost
//
//  Created by Martin Richter on 09/02/2017.
//  Copyright © 2017 Martin Richter. All rights reserved.
//

import Cartography

class AdvancementBadge: UIView {

    private let textLabel = Label(fontWeight: .Bold, fontStyle: .Normal, fontSize: .Small)

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: CGRectNull)

        self.backgroundColor = Color.successColor
        self.layoutMargins = UIEdgeInsets(top: 0.5, left: 4, bottom: 0.5, right: 4)
        self.layer.cornerRadius = 6

        textLabel.textAlignment = .Center
        textLabel.textColor = UIColor.whiteColor()

        textLabel.text = "WL"

        self.addSubview(textLabel)

        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func makeConstraints() {
        constrain(self, textLabel) { superview, textLabel in
            textLabel.edges == superview.edgesWithinMargins
        }
    }
}
