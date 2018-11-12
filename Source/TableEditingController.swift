//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//
//  Documentation
//  https://jessesquires.github.io/JSQDataSourcesKit
//
//
//  GitHub
//  https://github.com/jessesquires/JSQDataSourcesKit
//
//
//  License
//  Copyright © 2015-present Jesse Squires
//  Released under an MIT license: https://opensource.org/licenses/MIT
//

import Foundation
import UIKit

/// An instance of `TableEditingController` allows editing a table view via inserting and deleting rows.
public struct TableEditingController<DataSource: DataSourceProtocol> {

    // MARK: Typealiases

    /// Asks if a row at the specified index path is editable for the specified table view.
    /// - Parameters:
    ///   - item:      The item at `indexPath`.
    ///   - tableView: The table view requesting this information.
    ///   - indexPath: The index path of the item.
    ///
    /// - Returns: `true` if the specified row is editable, `false` otherwise.
    public typealias CanEditRowConfig = (DataSource.Item?, UITableView, IndexPath) -> Bool

    /// Commits the editing actions for the specified index path.
    ///
    /// - Parameters:
    ///   - dataSource: The dataSource at `indexPath`.
    ///   - tableView:  The table view being edited.
    ///   - commit:     The editing style.
    ///   - indexPath:  The index path of the item.
    public typealias CommitEditingConfig = (inout DataSource, UITableView, UITableViewCell.EditingStyle, IndexPath) -> Void

    /// A closure that determines if a given row is editable.
    public let canEditRow: CanEditRowConfig

    /// A closure that commits the editing actions for a table view.
    public let commitEditing: CommitEditingConfig

    // MARK: Initialization

    /// Constructs a new `TableEditingController`.
    ///
    /// - Parameters:
    ///   - canEditRow:    The closure that determines if a given row is editable.
    ///   - commitEditing: The closure that commits the editing actions for a table view.
    ///
    /// - Returns: A new `TableEditingController` instance.
    public init(canEditRow: @escaping CanEditRowConfig, commitEditing: @escaping CommitEditingConfig) {
        self.canEditRow = canEditRow
        self.commitEditing = commitEditing
    }
}
