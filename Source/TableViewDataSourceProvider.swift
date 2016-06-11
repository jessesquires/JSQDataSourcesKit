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

import CoreData
import Foundation
import UIKit


/**
 A `TableViewFetchedResultsDataSourceProvider` is responsible for providing a data source object for a table view
 that is backed by an `NSFetchedResultsController` instance.

 - warning: The `CellFactory.Item` type should correspond to the type of objects that the `NSFetchedResultsController` fetches.
 - note: Clients are responsbile for registering cells with the table view.
 */
public final class TableViewFetchedResultsDataSourceProvider <CellFactory: ReusableViewFactoryProtocol where CellFactory.View: UITableViewCell>: CustomStringConvertible {

    // MARK: Typealiases

    /// The type of elements for the data source provider.
    public typealias Item = CellFactory.Item


    // MARK: Properties

    /// Returns the fetched results controller that provides the data for the table view data source.
    public let fetchedResultsController: NSFetchedResultsController

    /// Returns the cell factory for this data source provider.
    public let cellFactory: CellFactory

    /// Returns the object that provides the data for the table view.
    public var dataSource: UITableViewDataSource { return bridgedDataSource }


    // MARK: Initialization

    /**
     Constructs a new data source provider for the table view.

     - parameter fetchedResultsController: The fetched results controller that provides the data for the table view.
     - parameter cellFactory:              The cell factory from which the table view data source will dequeue cells.
     - parameter tableView:                The table view whose data source will be provided by this provider.

     - returns: A new `TableViewFetchedResultsDataSourceProvider` instance.
     */
    public init(fetchedResultsController: NSFetchedResultsController, cellFactory: CellFactory, tableView: UITableView? = nil) {
        assert(fetchedResultsController: fetchedResultsController,
               fetchesObjectsOfClass: Item.self as! AnyClass)

        self.fetchedResultsController = fetchedResultsController
        self.cellFactory = cellFactory
        tableView?.dataSource = dataSource
    }


    // MARK: CustomStringConvertible

    /// :nodoc:
    public var description: String {
        get {
            return "<\(TableViewFetchedResultsDataSourceProvider.self): fetchedResultsController=\(fetchedResultsController)>"
        }
    }


    // MARK: Private

    private lazy var bridgedDataSource: BridgedDataSource = {
        let dataSource = BridgedDataSource(
            numberOfSections: { [unowned self] () -> Int in
                return self.fetchedResultsController.sections?.count ?? 0
            },
            numberOfItemsInSection: { [unowned self] (section) -> Int in
                return (self.fetchedResultsController.sections?[section])?.numberOfObjects ?? 0
            })

        dataSource.tableCellForRowAtIndexPath = { [unowned self] (tableView, indexPath) -> UITableViewCell in
            let item = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Item
            return self.cellFactory.tableCellFor(item: item, parentView: tableView, indexPath: indexPath)
        }

        dataSource.tableTitleForHeaderInSection = { [unowned self] (section) -> String? in
            return (self.fetchedResultsController.sections?[section])?.name
        }
        
        return dataSource
    }()
}
