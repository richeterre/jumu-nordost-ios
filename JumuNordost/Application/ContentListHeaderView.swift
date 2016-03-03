//
//  ContentListHeaderView.swift
//  JumuNordost
//
//  Created by Martin Richter on 02/03/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Cartography

class ContestListHeaderView: UIView {

    private let textLabel = Label(fontWeight: .Regular, fontStyle: .Italic, fontSize: .Medium)

    // MARK: - Lifecycle

    convenience init(text: String) {
        self.init()

        self.layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 8, right: 16)

        textLabel.numberOfLines = 0
        textLabel.textAlignment = .Center
        textLabel.textColor = Color.secondaryTextColor
        textLabel.text = text

        addSubview(textLabel)
        makeConstraints()
    }

    // MARK: - Layout

    private func makeConstraints() {
        constrain(textLabel, self) { textLabel, superview in
            textLabel.edges == superview.edgesWithinMargins
        }
    }
}
