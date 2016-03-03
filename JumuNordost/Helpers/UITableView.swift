//
//  UITableView.swift
//  JumuNordost
//
//  Created by Martin Richter on 03/03/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import UIKit

extension UITableView {

    /// Performs a batch update on the table view for the given changes.
    func updateWithChangeset<E: Equatable>(changeset: Changeset<E>, animation: UITableViewRowAnimation) {
        self.beginUpdates()
        self.deleteRowsAtIndexPaths(changeset.deletions, withRowAnimation: animation)
        self.reloadRowsAtIndexPaths(changeset.modifications, withRowAnimation: animation)
        self.insertRowsAtIndexPaths(changeset.insertions, withRowAnimation: animation)
        self.endUpdates()
    }
}
