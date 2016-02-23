//
//  PerformanceView.swift
//  JumuNordost
//
//  Created by Martin Richter on 23/02/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Cartography

class PerformanceView: UIView {

    var categoryName: String? {
        get { return categoryLabel.text }
        set { categoryLabel.text = newValue }
    }

    private let categoryLabel = Label(fontWeight: .Bold, fontStyle: .Normal, fontSize: .Large)

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(categoryLabel)

        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func makeConstraints() {
        constrain(self, categoryLabel) { superview, categoryLabel in
            categoryLabel.top == superview.top
            categoryLabel.left == superview.left
            categoryLabel.right <= superview.right
            categoryLabel.bottom == superview.bottom
        }
    }
}
