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


public struct TableEditingController {

    public typealias CanEditRowConfig = (UITableView, IndexPath) -> Bool
    public typealias CommitEditingConfig = (UITableView, UITableViewCellEditingStyle, IndexPath) -> Void

    public let canEditRowConfig: CanEditRowConfig
    public let commitEditingConfig: CommitEditingConfig

    public init(canEditRowConfig: @escaping CanEditRowConfig, commitEditingConfig: @escaping CommitEditingConfig) {
        self.canEditRowConfig = canEditRowConfig
        self.commitEditingConfig = commitEditingConfig
    }

    // MARK: Internal

    func canEditRow(in tableView: UITableView, at indexPath: IndexPath) -> Bool {
        return canEditRowConfig(tableView, indexPath)
    }

    func commitEditStyleForRow(in tableView: UITableView, editingStyle: UITableViewCellEditingStyle, at indexPath: IndexPath) {
        return commitEditingConfig(tableView, editingStyle, indexPath)
    }
}
