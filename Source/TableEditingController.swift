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
 An instance of `TableEditingController` that allows to handle the insertion/deletion of a row.
 */
public struct TableEditingController {

    // MARK: Type aliases
    
    /**
     Asks if a row on the specified index path is editable for the specified table view.
    
     - parameter tableView: The table view requesting this information.
     - parameter indexPath: The index path of the row.
     
     - returns: If the specified row is editable.
     */
    public typealias CanEditRowConfig = (_ tableView: UITableView, _ indexPath: IndexPath) -> Bool
    
    /**
     Commits the insertion/deletion of a specified row.
     
     - parameter tableView: The specified table view.
     - parameter commit:    The specified editing style.
     - parameter indexPath: The specified index path.
     */
    public typealias CommitEditingConfig = (_ tableView: UITableView, _ commit: UITableViewCellEditingStyle, _ indexPath: IndexPath) -> Void

    /// A closure used to verify if a given row is editable.
    public let canEditRowConfig: CanEditRowConfig
    
    /// A closure used to commit the insertion/deletion of a specified row.
    public let commitEditingConfig: CommitEditingConfig
    
    //MARK: - Initialization
    
    /**
     Constructs a new `TableEditingController`.
     
     - parameter canEditRowConfig:    The closure which will ask to verify that a given row is editable.
     - parameter commitEditingConfig: The closure which will commit the insertion/deletion of a specified row.
     
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
