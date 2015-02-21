//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQDataSourcesKit
//
//
//  GitHub
//  https://github.com/jessesquires/JSQDataSourcesKit
//
//
//  License
//  Copyright (c) 2015 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation
import UIKit
import CoreData


public class TableViewFetchedResultsDelegate <Cell: UITableViewCell, DataItem>: NSFetchedResultsControllerDelegate {

    public weak var tableView: UITableView?

    public let cellFactory: TableViewCellFactory<Cell, DataItem>

    public init(tableView: UITableView, cellFactory: TableViewCellFactory<Cell, DataItem>) {
        self.tableView = tableView
        self.cellFactory = cellFactory
    }

    // MARK: fetched results controller delegate

    public func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView?.beginUpdates()
    }

    public func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            tableView?.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            tableView?.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            break
        }
    }

    public func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if let i = indexPath {
                tableView?.insertRowsAtIndexPaths([i], withRowAnimation: .Fade)
            }
        case .Delete:
            if let i = indexPath {
                tableView?.deleteRowsAtIndexPaths([i], withRowAnimation: .Fade)
            }
        case .Update:
            if let i = indexPath, cell = tableView?.cellForRowAtIndexPath(i) {
                cellFactory.configureCell(cell as! Cell, forItem: anObject as! DataItem, inTableView: tableView!, atIndexPath: indexPath!)
            }
        case .Move:
            if let deleteIndexPath = indexPath {
                tableView?.deleteRowsAtIndexPaths([deleteIndexPath], withRowAnimation: .Fade)
            }

            if let insertIndexPath = newIndexPath {
                tableView?.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: .Fade)
            }
        }
    }

    public func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView?.endUpdates()
    }
    
}
