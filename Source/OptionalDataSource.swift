//
//  DataSourceEditing.swift
//  JSQDataSourcesKit
//
//  Created by Panagiotis Sartzetakis on 12/09/2016.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

import Foundation
import UIKit


public protocol DataSourceTableEditingProtocol{
    
    //MARK: Methods
    
    /// Returns a `Bool` which indicates if the cell will be available for editing or not
    ///
    /// - parameter indexPath: The index path specifying the location of the cell.
    /// - parameter tableView: The table view requesting this information.
    ///
    /// - returns: A `Bool` which indicates if the cell will be available for editing or not
    
    func configureCanEditRowAt(indexPath:IndexPath,in tableView:UITableView)->Bool
    
    
    /// Commit any neccessary action in respect of the `editingStyle` on the current `indexPath`
    ///
    /// - parameter tableView:    The table view requesting this information.
    /// - parameter editingStyle: The editingStyle that requested on the current `indexPath` (for example `.delete`)
    /// - parameter indexPath:    The index path specifying the location of the cell.
    
    func configureCommitEditStyleForRow(in tableView:UITableView,editingStyle:UITableViewCellEditingStyle,at indexPath:IndexPath)
    
}

public struct DataSourceEditingController:DataSourceTableEditingProtocol{
   
    public typealias CanEditRowConfigurator = (IndexPath,UITableView)->Bool
    public typealias CommitEditingStyleConfigurator = (UITableView,UITableViewCellEditingStyle,IndexPath)->Void
    
    public let canEditConfigurator:CanEditRowConfigurator
    public let commitEditingStyle:CommitEditingStyleConfigurator
    
    public init(canEditConfigurator:@escaping CanEditRowConfigurator,
                commitEditingStyle:@escaping CommitEditingStyleConfigurator){
        
        self.canEditConfigurator = canEditConfigurator
        self.commitEditingStyle = commitEditingStyle
    }
    
    
    public func configureCanEditRowAt(indexPath: IndexPath, in tableView: UITableView) -> Bool {
        return canEditConfigurator(indexPath, tableView)
    }
    
    public func configureCommitEditStyleForRow(in tableView: UITableView, editingStyle: UITableViewCellEditingStyle, at indexPath: IndexPath) {
        return commitEditingStyle(tableView, editingStyle, indexPath)
    }

    
}
