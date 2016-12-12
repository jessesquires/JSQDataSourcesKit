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

public struct TableDataSourceEditingController {
   
    public typealias CanEditRowConfigurator = (IndexPath, UITableView) -> Bool
    public typealias CommitEditingStyleConfigurator = (UITableView, UITableViewCellEditingStyle, IndexPath) -> Void
    
    public let canEditConfigurator: CanEditRowConfigurator
    public let commitEditingStyle: CommitEditingStyleConfigurator
    
    public init(canEditConfigurator: @escaping CanEditRowConfigurator,
                commitEditingStyle: @escaping CommitEditingStyleConfigurator) {
        
        self.canEditConfigurator = canEditConfigurator
        self.commitEditingStyle = commitEditingStyle
    }
    
    public func canEditRowAt(indexPath: IndexPath, in tableView: UITableView) -> Bool {
        return canEditConfigurator(indexPath, tableView)
    }
    
    public func commitEditStyleForRow(in tableView: UITableView, editingStyle: UITableViewCellEditingStyle, at indexPath: IndexPath) {
        return commitEditingStyle(tableView, editingStyle, indexPath)
    }
    
}
