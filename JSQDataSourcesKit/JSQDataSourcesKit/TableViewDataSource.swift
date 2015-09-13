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
//  Copyright (c) 2015 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import CoreData
import Foundation
import UIKit


/**
An instance conforming to `TableViewCellFactoryType` is responsible for initializing
and configuring table view cells to be consumed by an instance of `TableViewDataSourceProvider`.

The `TableViewCellFactoryType` protocol has two associated types, `Item` and `Cell`.
These associated types describe the type of model instances backing the table view
and the type of cells in the table view, respectively.
*/
public protocol TableViewCellFactoryType {

    // MARK: Associated types

    /// The type of elements backing the table view.
    typealias Item

    /// The type of `UITableViewCell` that the factory produces.
    typealias Cell: UITableViewCell

    // MARK: Methods

    /**
    Creates and returns a new `Cell` instance, or dequeues an existing cell for reuse.

    - parameter item:      The model instance (data object) at `indexPath`.
    - parameter tableView: The table view requesting this information.
    - parameter indexPath: The index path that specifies the location of `cell` and `item`.

    - returns: An initialized or dequeued `UITableViewCell` of type `Cell`.
    */
    func cellForItem(item: Item, inTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> Cell

    /**
    Configures and returns the specified cell.

    - parameter cell:      The cell to configure.
    - parameter item:      The model instance (data object) at `indexPath`.
    - parameter tableView: The table view requesting this information.
    - parameter indexPath: The index path that specifies the location of `cell` and `item`.

    - returns: A configured `UITableViewCell` of type `Cell`.
    */
    func configureCell(cell: Cell, forItem item: Item, inTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> Cell
}


/**
A `TableViewCellFactory` is a concrete `TableViewCellFactoryType`.
This factory is responsible for producing and configuring table view cells for a specific data item.

- Note: The factory has the following type parameters:
```swift
TableViewCellFactory<Cell: UITableViewCell, Item>
```
*/
public struct TableViewCellFactory <Cell: UITableViewCell, Item>: TableViewCellFactoryType {

    // MARK: Typealiases

    /**
    Configures the cell for the specified data item, table view and index path.

    - parameter Cell:        The cell to be configured at the index path.
    - parameter Item:        The data item at the index path.
    - parameter UITableView: The table view requesting this information.
    - parameter NSIndexPath: The index path at which the cell will be displayed.

    - returns: The configured cell.
    */
    public typealias ConfigurationHandler = (Cell, Item, UITableView, NSIndexPath) -> Cell

    // MARK: Properties

    /**
    A unique identifier that describes the purpose of the cells that the factory produces.
    The factory dequeues cells from the table view with this reuse identifier.

    - Warning: Clients are responsible for registering a cell for this identifier with the table view.
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

    - parameter item:      The model instance (data object) at `indexPath`.
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
    - parameter item:      The model instance (data object) at `indexPath`.
    - parameter tableView: The table view requesting this information.
    - parameter indexPath: The index path that specifies the location of `cell` and `item`.

    - returns: A configured `UITableViewCell` of type `Cell`.
    */
    public func configureCell(cell: Cell, forItem item: Item, inTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> Cell {
        return cellConfigurator(cell, item, tableView, indexPath)
    }
}


/// An instance conforming to `TableViewSectionInfo` represents a section of items in a table view.
public protocol TableViewSectionInfo {

    // MARK: Associated types

    /// The type of elements stored in the section.
    typealias Item

    // MARK: Properties

    /// Returns the elements in the table view section.
    var items: [Item] { get set }

    /// Returns the header title for the section.
    var headerTitle: String? { get }

    /// Returns the footer title for the section.
    var footerTitle: String? { get }
}


/**
A `TableViewSection` is a concrete `TableViewSectionInfo`.
A section instance is responsible for managing the elements in a section.

Elements in the section may be accessed or replaced via its subscripting interface.

- Note: The section has the following type parameters:
```swift
TableViewSection<Item>
```
*/
public struct TableViewSection <Item>: TableViewSectionInfo {

    // MARK: Properties

    /// The elements in the collection view section.
    public var items: [Item]

    /// The header title for the section.
    public let headerTitle: String?

    /// The footer title for the section.
    public let footerTitle: String?

    /// Returns the number of elements in the section.
    public var count: Int {
        return items.count
    }

    // MARK: Initialization

    /**
    Constructs a new table view section.

    - parameter items:       The elements in the section.
    - parameter headerTitle: The section header title.
    - parameter footerTitle: The section footer title.

    - returns: A new `TableViewSection` instance.
    */
    public init(items: Item..., headerTitle: String? = nil, footerTitle: String? = nil) {
        self.init(items, headerTitle: headerTitle, footerTitle: footerTitle)
    }

    /**
    Constructs a new table view section.

    - parameter items:       The elements in the section.
    - parameter headerTitle: The section header title.
    - parameter footerTitle: The section footer title.

    - returns: A new `TableViewSection` instance.
    */
    public init(_ items: [Item], headerTitle: String? = nil, footerTitle: String? = nil) {
        self.items = items
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
    }

    // MARK: Subscript

    public subscript (index: Int) -> Item {
        get {
            return items[index]
        }
        set {
            items[index] = newValue
        }
    }
}


/**
A `TableViewDataSourceProvider` is responsible for providing a data source object for a table view.
An instance of `TableViewDataSourceProvider` owns an array of section instances and a cell factory.

Sections may be accessed or replaced via the provider's subscripting interface.

- Warning: Clients are responsbile for:
    - Registering cells with the table view
    - Adding, removing, or reloading cells and sections as the provider's `sections` are modified.

- Note: The data source provider has the following type parameters:

```swift
<Item, SectionInfo: TableViewSectionInfo, 
    CellFactory: TableViewCellFactoryType
    where
    SectionInfo.Item == Item,
    CellFactory.Item == Item>
```
*/
public final class TableViewDataSourceProvider <Item,
                                                SectionInfo: TableViewSectionInfo,
                                                CellFactory: TableViewCellFactoryType
                                                where
                                                SectionInfo.Item == Item,
                                                CellFactory.Item == Item> {

    // MARK: Properties

    /// The sections in the table view
    public var sections: [SectionInfo]

    /// Returns the cell factory for this data source provider.
    public let cellFactory: CellFactory

    /// Returns the object that provides the data for the table view.
    public var dataSource: UITableViewDataSource { return bridgedDataSource }

    // MARK: Initialization

    /**
    Constructs a new data source provider for a table view.

    - parameter sections:    The sections to display in the table view.
    - parameter cellFactory: The cell factory from which the table view data source will dequeue cells.
    - parameter tableView:   The table view whose data source will be provided by this provider.

    - returns: A new `TableViewDataSourceProvider` instance.
    */
    public init(sections: [SectionInfo], cellFactory: CellFactory, tableView: UITableView? = nil) {
        self.sections = sections
        self.cellFactory = cellFactory

        tableView?.dataSource = dataSource
    }

    // MARK: Subscripts

    public subscript (index: Int) -> SectionInfo {
        get {
            return sections[index]
        }
        set {
            sections[index] = newValue
        }
    }

    public subscript (indexPath: NSIndexPath) -> Item {
        get {
            return sections[indexPath.section].items[indexPath.row]
        }
        set {
            sections[indexPath.section].items[indexPath.row] = newValue
        }
    }

    // MARK: Private

    private lazy var bridgedDataSource: BridgedTableViewDataSource = BridgedTableViewDataSource(
        numberOfSections: { [unowned self] () -> Int in
            self.sections.count
        },
        numberOfRowsInSection: { [unowned self] (section) -> Int in
            self.sections[section].items.count
        },
        cellForRowAtIndexPath: { [unowned self] (tableView, indexPath) -> UITableViewCell in
            let item = self.sections[indexPath.section].items[indexPath.row]
            let cell = self.cellFactory.cellForItem(item, inTableView: tableView, atIndexPath: indexPath)
            return self.cellFactory.configureCell(cell, forItem: item, inTableView: tableView, atIndexPath: indexPath)
        },
        titleForHeaderInSection: { [unowned self] (section) -> String? in
            self.sections[section].headerTitle
        },
        titleForFooterInSection: { [unowned self] (section) -> String? in
            self.sections[section].footerTitle
        })
}

/**
A `TableViewFetchedResultsDataSourceProvider` is responsible for providing a data source object for a table view
that is backed by an `NSFetchedResultsController` instance.

This provider owns a fetched results controller and a cell factory.

- Note: Clients are responsbile for registering cells with the table view.

- Note: The data source provider has the following type parameters:

```swift
<Item, CellFactory: TableViewCellFactoryType
    where CellFactory.Item == Item>
```
*/
public final class TableViewFetchedResultsDataSourceProvider <Item,
                                                              CellFactory: TableViewCellFactoryType
                                                              where
                                                              CellFactory.Item == Item> {

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
        self.fetchedResultsController = fetchedResultsController
        self.cellFactory = cellFactory

        tableView?.dataSource = dataSource
    }

    // MARK: Private

    private lazy var bridgedDataSource: BridgedTableViewDataSource = BridgedTableViewDataSource(
        numberOfSections: { [unowned self] () -> Int in
            self.fetchedResultsController.sections?.count ?? 0
        },
        numberOfRowsInSection: { [unowned self] (section) -> Int in
            return (self.fetchedResultsController.sections?[section])?.numberOfObjects ?? 0
        },
        cellForRowAtIndexPath: { [unowned self] (tableView, indexPath) -> UITableViewCell in
            let item = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Item
            let cell = self.cellFactory.cellForItem(item, inTableView: tableView, atIndexPath: indexPath)
            return self.cellFactory.configureCell(cell, forItem: item, inTableView: tableView, atIndexPath: indexPath)
        },
        titleForHeaderInSection: { [unowned self] (section) -> String? in
            return (self.fetchedResultsController.sections?[section])?.name
        },
        titleForFooterInSection: { (section) -> String? in
            return nil
    })
}


/*
This separate type is required for Objective-C interoperability (interacting with Cocoa).
Because the DataSourceProvider is generic it cannot be bridged to Objective-C.
That is, it cannot be assigned to `UITableView.dataSource`.
*/
@objc private final class BridgedTableViewDataSource: NSObject, UITableViewDataSource {

    typealias NumberOfSectionsHandler = () -> Int
    typealias NumberOfRowsInSectionHandler = (Int) -> Int
    typealias CellForRowAtIndexPathHandler = (UITableView, NSIndexPath) -> UITableViewCell
    typealias TitleForHeaderInSectionHandler = (Int) -> String?
    typealias TitleForFooterInSectionHandler = (Int) -> String?

    let numberOfSections: NumberOfSectionsHandler
    let numberOfRowsInSection: NumberOfRowsInSectionHandler
    let cellForRowAtIndexPath: CellForRowAtIndexPathHandler
    let titleForHeaderInSection: TitleForHeaderInSectionHandler
    let titleForFooterInSection: TitleForFooterInSectionHandler

    init(numberOfSections: NumberOfSectionsHandler,
        numberOfRowsInSection: NumberOfRowsInSectionHandler,
        cellForRowAtIndexPath: CellForRowAtIndexPathHandler,
        titleForHeaderInSection: TitleForHeaderInSectionHandler,
        titleForFooterInSection: TitleForFooterInSectionHandler) {

            self.numberOfSections = numberOfSections
            self.numberOfRowsInSection = numberOfRowsInSection
            self.cellForRowAtIndexPath = cellForRowAtIndexPath
            self.titleForHeaderInSection = titleForHeaderInSection
            self.titleForFooterInSection = titleForFooterInSection
    }

    @objc func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections()
    }

    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection(section)
    }

    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cellForRowAtIndexPath(tableView, indexPath)
    }

    @objc func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeaderInSection(section)
    }

    @objc func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return titleForFooterInSection(section)
    }
}
