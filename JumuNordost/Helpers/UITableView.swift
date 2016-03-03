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
        beginUpdates()
        deleteRowsAtIndexPaths(changeset.deletions, withRowAnimation: animation)
        reloadRowsAtIndexPaths(changeset.modifications, withRowAnimation: animation)
        insertRowsAtIndexPaths(changeset.insertions, withRowAnimation: animation)
        endUpdates()
    }

    /// Adjusts the scroll position to show the content at the top.
    func scrollToTop(animated animated: Bool) {
        guard numberOfRowsInSection(0) > 0 else { return }
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: animated)
    }
}
