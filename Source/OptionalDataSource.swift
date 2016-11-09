//
//  DataSourceEditing.swift
//  JSQDataSourcesKit
//
//  Created by Panagiotis Sartzetakis on 12/09/2016.
//  Copyright © 2016 Hexed Bits. All rights reserved.
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
