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
 This factory is responsible for producing and configuring table view cells for a specific item.
 */
public struct TableViewCellFactory <Cell: UITableViewCell, Item>: TableViewCellFactoryType, CustomStringConvertible {

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

    - note: Clients are responsible for registering a cell for this identifier with the table view.
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


    // MARK: TableViewCellFactoryType

    /// :nodoc:
    public func cellForItem(
        item: Item,
        inTableView tableView: UITableView,
        atIndexPath indexPath: NSIndexPath) -> Cell {
            return tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! Cell
    }

    /// :nodoc:
    public func configureCell(
        cell: Cell,
        forItem item: Item,
        inTableView tableView: UITableView,
        atIndexPath indexPath: NSIndexPath) -> Cell {
            return cellConfigurator(cell, item, tableView, indexPath)
    }


    // MARK: CustomStringConvertible

    /// :nodoc:
    public var description: String {
        get {
            return "<\(TableViewCellFactory.self): \(reuseIdentifier)>"
        }
    }
}
