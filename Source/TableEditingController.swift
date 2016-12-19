//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://jessesquires.com/JSQDataSourcesKit
//
//
//  GitHub
//  https://github.com/jessesquires/JSQDataSourcesKit
//
//
//  License
//  Copyright © 2015 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation
import UIKit

/**
 An instance of `TableEditingController` allows editing a table view via inserting and deleting rows.
 */
public struct TableEditingController {

    // MARK: Typealiases
    
    /**
     Asks if a row at the specified index path is editable for the specified table view.
    
     - parameter tableView: The table view requesting this information.
     - parameter indexPath: The index path of the item.
     
     - returns: `true` if the specified row is editable, `false` otherwise.
     */
    public typealias CanEditRowConfig = (_ tableView: UITableView, _ indexPath: IndexPath) -> Bool
    
    /**
     Commits the editing actions for the specified index path.
     
     - parameter tableView: The table view being edited.
     - parameter commit:    The editing style.
     - parameter indexPath: The index path of the item.
     */
    public typealias CommitEditingConfig = (_ tableView: UITableView, _ commit: UITableViewCellEditingStyle, _ indexPath: IndexPath) -> Void

    /// A closure that determines if a given row is editable.
    public let canEditRowConfig: CanEditRowConfig
    
    /// A closure that commits the editing actions for a table view.
    public let commitEditingConfig: CommitEditingConfig
    
    // MARK: Initialization
    
    /**
     Constructs a new `TableEditingController`.
     
     - parameter canEditRowConfig:    The closure that determines if a given row is editable.
     - parameter commitEditingConfig: The closure that commits the editing actions for a table view.
     
     - returns: A new `TableEditingController` instance.
     */
    public init(canEditRowConfig: @escaping CanEditRowConfig, commitEditingConfig: @escaping CommitEditingConfig) {
        self.canEditRowConfig = canEditRowConfig
        self.commitEditingConfig = commitEditingConfig
    }

    // MARK: Internal

    /// :nodoc:
    func canEditRow(in tableView: UITableView, at indexPath: IndexPath) -> Bool {
        return canEditRowConfig(tableView, indexPath)
    }

    /// :nodoc:
    func commitEditStyleForRow(in tableView: UITableView, editingStyle: UITableViewCellEditingStyle, at indexPath: IndexPath) {
        return commitEditingConfig(tableView, editingStyle, indexPath)
    }
}
