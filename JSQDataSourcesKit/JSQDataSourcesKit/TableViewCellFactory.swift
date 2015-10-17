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

import UIKit


/**
A `TableViewCellFactory` is a concrete `TableViewCellFactoryType`.
This factory is responsible for producing and configuring table view cells for a specific data item.
*/
public struct TableViewCellFactory <Cell: UITableViewCell, Item>: TableViewCellFactoryType {

    // MARK: Typealiases

    /**
    Configures the cell for the specified data item, table view and index path.

    - parameter Cell:        The cell to be configured at the index path.
    - parameter Item:        The item at the index path.
    - parameter UITableView: The table view requesting this information.
    - parameter NSIndexPath: The index path at which the cell will be displayed.

    - returns: The configured cell.
    */
    public typealias ConfigurationHandler = (Cell, Item, UITableView, NSIndexPath) -> Cell

    // MARK: Properties

    /**
    A unique identifier that describes the purpose of the cells that the factory produces.
    The factory dequeues cells from the table view with this reuse identifier.

    - Note: Clients are responsible for registering a cell for this identifier with the table view.
    */
    public let reuseIdentifier: String

    private let cellConfigurator: ConfigurationHandler

    // MARK: Initialization

    /**
    Constructs a new table view cell factory.

    - parameter reuseIdentifier:  The reuse identifier with which the factory will dequeue cells.
    - parameter cellConfigurator: The closure with which the factory will configure cells.

    - returns: A new `TableViewCellFactory` instance.
    */
    public init(reuseIdentifier: String, cellConfigurator: ConfigurationHandler) {
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }

    // MARK: Methods

    /**
    Creates and returns a new `Cell` instance, or dequeues an existing cell for reuse.

    - parameter item:      The item at `indexPath`.
    - parameter tableView: The table view requesting this information.
    - parameter indexPath: The index path that specifies the location of `cell` and `item`.

    - returns: An initialized or dequeued `UITableViewCell` of type `Cell`.
    */
    public func cellForItem(item: Item, inTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> Cell {
        return tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! Cell
    }

    /**
    Configures and returns the specified cell.

    - parameter cell:      The cell to configure.
    - parameter item:      The item at `indexPath`.
    - parameter tableView: The table view requesting this information.
    - parameter indexPath: The index path that specifies the location of `cell` and `item`.

    - returns: A configured `UITableViewCell` of type `Cell`.
    */
    public func configureCell(cell: Cell, forItem item: Item, inTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> Cell {
        return cellConfigurator(cell, item, tableView, indexPath)
    }
}
