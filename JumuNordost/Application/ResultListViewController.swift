//
//  ResultListViewController.swift
//  JumuNordost
//
//  Created by Martin Richter on 07/01/2017.
//  Copyright © 2017 Martin Richter. All rights reserved.
//

import UIKit

class ResultListViewController: UIViewController {

    // MARK: - Private Properties

    private let mediator: ResultListMediator

    // MARK: - Lifecycle

    init(mediator: ResultListMediator) {
        self.mediator = mediator

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = mediator.title
    }
}
