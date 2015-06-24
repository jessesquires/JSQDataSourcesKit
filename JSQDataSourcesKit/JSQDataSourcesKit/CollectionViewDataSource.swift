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

import Foundation
import UIKit
import CoreData

/**
An instance conforming to `CollectionViewCellFactoryType` is responsible for initializing
and configuring collection view cells to be consumed by an instance of `CollectionViewDataSourceProvider`.

The `CollectionViewCellFactoryType` protocol has two associated types, `DataItem` and `Cell`.
These associated types describe the type of model instances backing the collection view
and the type of cells in the collection view, respectively.
*/
public protocol CollectionViewCellFactoryType {

    // MARK: Associated types

    /// The type of elements backing the collection view.
    typealias DataItem

    /// The type of `UICollectionViewCell` that the factory produces.
    typealias Cell: UICollectionViewCell

    // MARK: Methods

    /**
    Creates and returns a new `Cell` instance, or dequeues an existing cell for reuse.

    - parameter item:           The model instance (data object) at `indexPath`.
    - parameter collectionView: The collection view requesting this information.
    - parameter indexPath:      The index path that specifies the location of `cell` and `item`.

    - returns: An initialized or dequeued `UICollectionViewCell` of type `Cell`.
    */
    func cellForItem(item: DataItem, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> Cell

    /**
    Configures and returns the specified cell.

    - parameter cell:           The cell to configure.
    - parameter item:           The model instance (data object) at `indexPath`.
    - parameter collectionView: The collection view requesting this information.
    - parameter indexPath:      The index path that specifies the location of `cell` and `item`.

    - returns: A configured `UICollectionViewCell` of type `Cell`.
    */
    func configureCell(cell: Cell, forItem item: DataItem, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> Cell
}


/**
A `CollectionViewCellFactory` is a concrete `CollectionViewCellFactoryType`.
This factory is responsible for producing and configuring collection view cells for a specific data item.

- Note: The factory has the following type parameters:

```swift
CollectionViewCellFactory<Cell: UICollectionViewCell, DataItem>
```
*/
public struct CollectionViewCellFactory <Cell: UICollectionViewCell, DataItem>: CollectionViewCellFactoryType {

    // MARK: Typealiases

    /**
    Configures the cell for the specified data item, collection view and index path.

    - parameter Cell:             The cell to be configured at the index path.
    - parameter DataItem:         The data item at the index path.
    - parameter UICollectionView: The collection view requesting this information.
    - parameter NSIndexPath:      The index path at which the cell will be displayed.

    - returns: The configured cell.
    */
    public typealias ConfigurationHandler = (Cell, DataItem, UICollectionView, NSIndexPath) -> Cell

    // MARK: Properties

    /**
    A unique identifier that describes the purpose of the cells that the factory produces.
    The factory dequeues cells from the collection view with this reuse identifier.
    Clients are responsible for registering a cell for this identifier with the collection view.
    */
    public let reuseIdentifier: String

    private let cellConfigurator: ConfigurationHandler

    // MARK: Initialization

    /**
    Constructs a new collection view cell factory.

    - parameter reuseIdentifier:  The reuse identifier with which the factory will dequeue cells.
    - parameter cellConfigurator: The closure with which the factory will configure cells.

    - returns: A new `CollectionViewCellFactory` instance.
    */
    public init(reuseIdentifier: String, cellConfigurator: ConfigurationHandler) {
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }

    // MARK: Methods

    /**
    Creates and returns a new `Cell` instance, or dequeues an existing cell for reuse.

    - parameter item:           The model instance (data object) at `indexPath`.
    - parameter collectionView: The collection view requesting this information.
    - parameter indexPath:      The index path that specifies the location of `cell` and `item`.

    - returns: An initialized or dequeued `UICollectionViewCell` of type `Cell`.
    */
    public func cellForItem(item: DataItem, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> Cell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! Cell
    }

    /**
    Configures and returns the specified cell.

    - parameter cell:           The cell to configure.
    - parameter item:           The model instance (data object) at `indexPath`.
    - parameter collectionView: The collection view requesting this information.
    - parameter indexPath:      The index path that specifies the location of `cell` and `item`.

    - returns: A configured `UICollectionViewCell` of type `Cell`.
    */
    public func configureCell(cell: Cell, forItem item: DataItem, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> Cell {
        return cellConfigurator(cell, item, collectionView, indexPath)
    }
}


/// Describes a collection view element kind, such as `UICollectionElementKindSectionHeader`.
public typealias SupplementaryViewKind = String


/**
An instance conforming to `CollectionSupplementaryViewFactoryType` is responsible for initializing
and configuring collection view supplementary views to be consumed by an instance of `CollectionViewDataSourceProvider`.

The `CollectionSupplementaryViewFactoryType` protocol has two associated types, `DataItem` and `SupplementaryView`.
These associated types describe the type of model instances backing the collection view
and the type of supplementary views in the collection view, respectively.
*/
public protocol CollectionSupplementaryViewFactoryType {

    // MARK: Associated types

    /// The type of elements backing the collection view.
    typealias DataItem

    /// The type of `UICollectionReusableView` that the factory produces.
    typealias SupplementaryView: UICollectionReusableView

    // MARK: Methods

    /**
    Creates and returns a new `SupplementaryView` instance, or dequeues an existing view for reuse.

    - parameter item:           The model instance (data object) at `indexPath`.
    - parameter kind:           An identifier that describes the type of the supplementary view.
    - parameter collectionView: The collection view requesting this information.
    - parameter indexPath:      The index path that specifies the location of the new supplementary view.

    - returns: An initialized or dequeued `UICollectionReusableView` of type `SupplementaryView`.
    */
    func supplementaryViewForItem(item: DataItem, kind: SupplementaryViewKind,
        inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> SupplementaryView

    /**
    Configures and returns the specified supplementary view.

    - parameter view:           The supplementary view to configure.
    - parameter item:           The model instance (data object) at `indexPath`.
    - parameter kind:           An identifier that describes the type of the supplementary view.
    - parameter collectionView: The collection view requesting this information.
    - parameter indexPath:      The index path that specifies the location of `view` and `item`.

    - returns: A configured `UICollectionReusableView` of type `SupplementaryView`.
    */
    func configureSupplementaryView(view: SupplementaryView, forItem item: DataItem, kind: SupplementaryViewKind,
        inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> SupplementaryView
}


/**
A `CollectionSupplementaryViewFactory` is a concrete `CollectionSupplementaryViewFactoryType`.
This factory is responsible for producing and configuring supplementary views for a collection view for a specific data item.

- Note: The factory has the following type parameters:
```swift
CollectionSupplementaryViewFactory<SupplementaryView: UICollectionReusableView, DataItem>
```
*/
public struct CollectionSupplementaryViewFactory <SupplementaryView: UICollectionReusableView, DataItem>: CollectionSupplementaryViewFactoryType {

    // MARK: Typealiases

    /**
    Configures the supplementary view for the specified data item, collection view, and index path.

    - parameter SupplementaryView:     The supplementary view to be configured at the index path.
    - parameter DataItem:              The data item at the index path.
    - parameter SupplementaryViewKind: An identifier that describes the type of the supplementary view.
    - parameter UICollectionView:      The collection view requesting this information.
    - parameter NSIndexPath:           The index path at which the supplementary view will be displayed.

    - returns: The configured supplementary view.
    */
    public typealias ConfigurationHandler = (SupplementaryView, DataItem, SupplementaryViewKind, UICollectionView, NSIndexPath) -> SupplementaryView

    // MARK: Properties

    /**
    A unique identifier that describes the purpose of the supplementary views that the factory produces.
    The factory dequeues supplementary views from the collection view with this reuse identifier.
    - Warning: Clients are responsible for registering a view for this identifier and a supplementary view kind with the collection view.
    */
    public let reuseIdentifier: String

    private let supplementaryViewConfigurator: ConfigurationHandler

    // MARK: Initialization

    /**
    Constructs a new supplementary view factory.

    - parameter reuseIdentifier:               The reuse identifier with which the factory will dequeue supplementary views.
    - parameter supplementaryViewConfigurator: The closure with which the factory will configure supplementary views.

    - returns: A new `CollectionSupplementaryViewFactory` instance.
    */
    public init(reuseIdentifier: String, supplementaryViewConfigurator: ConfigurationHandler) {
        self.reuseIdentifier = reuseIdentifier
        self.supplementaryViewConfigurator = supplementaryViewConfigurator
    }

    // MARK: Methods

    /**
    Creates and returns a new `SupplementaryView` instance, or dequeues an existing view for reuse.

    - parameter item:           The model instance (data object) at `indexPath`.
    - parameter kind:           An identifier that describes the type of the supplementary view.
    - parameter collectionView: The collection view requesting this information.
    - parameter indexPath:      The index path that specifies the location of the new supplementary view.

    - returns: An initialized or dequeued `UICollectionReusableView` of type `SupplementaryView`.
    */
    public func supplementaryViewForItem(item: DataItem, kind: SupplementaryViewKind,
        inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> SupplementaryView {
            return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseIdentifier, forIndexPath: indexPath) as! SupplementaryView
    }

    /**
    Configures and returns the specified supplementary view.

    - parameter view:           The supplementary view to configure.
    - parameter item:           The model instance (data object) at `indexPath`.
    - parameter kind:           An identifier that describes the type of the supplementary view.
    - parameter collectionView: The collection view requesting this information.
    - parameter indexPath:      The index path that specifies the location of `view` and `item`.

    - returns: A configured `UICollectionReusableView` of type `SupplementaryView`.
    */
    public func configureSupplementaryView(view: SupplementaryView, forItem item: DataItem, kind: SupplementaryViewKind,
        inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> SupplementaryView {
            return supplementaryViewConfigurator(view, item, kind, collectionView, indexPath)
    }
}

/// An instance conforming to `CollectionViewSectionInfo` represents a section of items in a collection view.
public protocol CollectionViewSectionInfo {

    // MARK: Associated types

    /// The type of elements stored in the section.
    typealias DataItem

    // MARK: Computed properties

    /// Returns the elements in the collection view section.
    var dataItems: [DataItem] { get }
}


/**
A `CollectionViewSection` is a concrete `CollectionViewSectionInfo`.
A section instance is responsible for managing the elements in a section.
Elements in the section may be accessed or replaced via its subscripting interface.

- Note: The section has the following type parameters:
```swift
CollectionViewSection<DataItem>
```
*/
public struct CollectionViewSection <DataItem>: CollectionViewSectionInfo {

    // MARK: Properties

    /// The elements in the collection view section.
    public var dataItems: [DataItem]

    /// Returns the number of elements in the section.
    public var count: Int {
        return dataItems.count
    }

    // MARK: Initialization

    /**
    Constructs a new collection view section.

    - parameter dataItems: The elements in the section.

    - returns: A new `CollectionViewSection` instance.
    */
    public init(dataItems: [DataItem]) {
        self.dataItems = dataItems
    }

    // MARK: Subscript

    public subscript (index: Int) -> DataItem {
        get {
            return dataItems[index]
        }
        set {
            dataItems[index] = newValue
        }
    }
}


/**
A `CollectionViewDataSourceProvider` is responsible for providing a data source object for a collection view.
An instance of `CollectionViewDataSourceProvider` owns an array of section instances, a cell factory, and a supplementary view factory.

Sections may be accessed or replaced via the provider's subscripting interface.

- Warning: Clients are responsbile for:
    - Registering cells with the collection view
    - Registering supplementary views with the collection view
    - Adding, removing, or reloading cells as the provider's `sections` are modified
    - Adding, removing, or reloading sections as the provider's `sections` are modified

- Note: The data source provider has the following type parameters:
```swift
<DataItem, SectionInfo: CollectionViewSectionInfo, 
           CellFactory: CollectionViewCellFactoryType,
           SupplementaryViewFactory: CollectionSupplementaryViewFactoryType
        where
            SectionInfo.DataItem == DataItem,
            CellFactory.DataItem == DataItem,
            SupplementaryViewFactory.DataItem == DataItem>
```
*/
public final class CollectionViewDataSourceProvider <DataItem, SectionInfo: CollectionViewSectionInfo,
                                                    CellFactory: CollectionViewCellFactoryType, SupplementaryViewFactory: CollectionSupplementaryViewFactoryType
                                                    where
                                                    SectionInfo.DataItem == DataItem,
                                                    CellFactory.DataItem == DataItem,
                                                    SupplementaryViewFactory.DataItem == DataItem> {

    // MARK: Properties

    /// The sections in the collection view.
    public var sections: [SectionInfo]

    /// Returns the cell factory for this data source provider.
    public let cellFactory: CellFactory

    /// Returns the supplementary view factory for this data source provider, or `nil` if it does not exist.
    public let supplementaryViewFactory: SupplementaryViewFactory?

    /// Returns the object that provides the data for the collection view.
    public var dataSource: UICollectionViewDataSource { return bridgedDataSource }

    // MARK: Initialization

    /**
    Constructs a new data source provider for a collection view.

    - parameter sections:                 The sections to display in the collection view.
    - parameter cellFactory:              The cell factory from which the collection view data source will dequeue cells.
    - parameter supplementaryViewFactory: The supplementary view factory from which the collection view data source will dequeue supplementary views.
    - parameter collectionView:           The collection view whose data source will be provided by this provider.

    - returns: A new `CollectionViewDataSourceProvider` instance.
    */
    public init(sections: [SectionInfo], cellFactory: CellFactory, supplementaryViewFactory: SupplementaryViewFactory? = nil, collectionView: UICollectionView? = nil) {
        self.sections = sections
        self.cellFactory = cellFactory
        self.supplementaryViewFactory = supplementaryViewFactory

        collectionView?.dataSource = dataSource
    }

    // MARK: Subscript

    public subscript (index: Int) -> SectionInfo {
        get {
            return sections[index]
        }
        set {
            sections[index] = newValue
        }
    }

    // MARK: Private

    private lazy var bridgedDataSource: BridgedCollectionViewDataSource = BridgedCollectionViewDataSource(
        numberOfSections: { [unowned self] () -> Int in
            self.sections.count
        },
        numberOfItemsInSection: { [unowned self] (section) -> Int in
            self.sections[section].dataItems.count
        },
        cellForItemAtIndexPath: { [unowned self] (collectionView, indexPath) -> UICollectionViewCell in
            let dataItem = self.sections[indexPath.section].dataItems[indexPath.row]
            let cell = self.cellFactory.cellForItem(dataItem, inCollectionView: collectionView, atIndexPath: indexPath)
            return self.cellFactory.configureCell(cell, forItem: dataItem, inCollectionView: collectionView, atIndexPath: indexPath)
        },
        supplementaryViewAtIndexPath: { [unowned self] (collectionView, kind, indexPath) -> UICollectionReusableView in
            if let factory = self.supplementaryViewFactory {
                let dataItem = self.sections[indexPath.section].dataItems[indexPath.row]
                let view = factory.supplementaryViewForItem(dataItem, kind: kind, inCollectionView: collectionView, atIndexPath: indexPath)
                return factory.configureSupplementaryView(view, forItem: dataItem, kind: kind, inCollectionView: collectionView, atIndexPath: indexPath)
            }

            // we must not return nil here, per the `UICollectionViewDataSource` docs
            // however, this will never get called as it is the client's responsibilty
            // supplementary views are hidden by returning `CGSizeZero` from `collectionView(_:layout:referenceSizeForHeaderInSection:)`
            return UICollectionReusableView()
        })
}


/**
A `CollectionViewFetchedResultsDataSourceProvider` is responsible for providing a data source object for a collection view
that is backed by an `NSFetchedResultsController` instance.

This provider owns a fetched results controller, a cell factory, and a supplementary view factory.

- Warning: Clients are responsbile for registering cells and supplementary views with the collection view.

- Note: The data source provider has the following type parameters:
```swift
<DataItem, CellFactory: CollectionViewCellFactoryType,
           SupplementaryViewFactory: CollectionSupplementaryViewFactoryType
        where
            CellFactory.DataItem == DataItem,
            SupplementaryViewFactory.DataItem == DataItem>
```
*/
public final class CollectionViewFetchedResultsDataSourceProvider <DataItem, CellFactory: CollectionViewCellFactoryType,
                                                                    SupplementaryViewFactory: CollectionSupplementaryViewFactoryType
                                                                    where
                                                                    CellFactory.DataItem == DataItem,
                                                                    SupplementaryViewFactory.DataItem == DataItem> {

    // MARK: Properties

    /// Returns the fetched results controller that provides the data for the collection view data source.
    public let fetchedResultsController: NSFetchedResultsController

    /// Returns the cell factory for this data source provider.
    public let cellFactory: CellFactory

    /// Returns the supplementary view factory for this data source provider, or `nil` if it does not exist.
    public let supplementaryViewFactory: SupplementaryViewFactory?

    /// Returns the object that provides the data for the collection view.
    public var dataSource: UICollectionViewDataSource { return bridgedDataSource }

    // MARK: Initialization

    /**
    Constructs a new data source provider for the collection view.

    - parameter fetchedResultsController: The fetched results controller that provides the data for the collection view.
    - parameter cellFactory:              The cell factory from which the collection view data source will dequeue cells.
    - parameter supplementaryViewFactory: The supplementary view factory from which the collection view data source will dequeue supplementary views.
    - parameter collectionView:           The collection view whose data source will be provided by this provider.

    - returns: A new `CollectionViewFetchedResultsDataSourceProvider` instance.
    */
    public init(fetchedResultsController: NSFetchedResultsController, cellFactory: CellFactory, supplementaryViewFactory: SupplementaryViewFactory? = nil, collectionView: UICollectionView? = nil) {
        self.fetchedResultsController = fetchedResultsController
        self.cellFactory = cellFactory
        self.supplementaryViewFactory = supplementaryViewFactory

        collectionView?.dataSource = dataSource
    }

    // MARK: Private

    private lazy var bridgedDataSource: BridgedCollectionViewDataSource = BridgedCollectionViewDataSource(
        numberOfSections: { [unowned self] () -> Int in
            self.fetchedResultsController.sections?.count ?? 0
        },
        numberOfItemsInSection: { [unowned self] (section) -> Int in
            return (self.fetchedResultsController.sections?[section])?.numberOfObjects ?? 0
        },
        cellForItemAtIndexPath: { [unowned self] (collectionView, indexPath) -> UICollectionViewCell in
            let dataItem = self.fetchedResultsController.objectAtIndexPath(indexPath) as! DataItem
            let cell = self.cellFactory.cellForItem(dataItem, inCollectionView: collectionView, atIndexPath: indexPath)
            return self.cellFactory.configureCell(cell, forItem: dataItem, inCollectionView: collectionView, atIndexPath: indexPath)
        },
        supplementaryViewAtIndexPath: { [unowned self] (collectionView, kind, indexPath) -> UICollectionReusableView in
            if let factory = self.supplementaryViewFactory {
                let dataItem = self.fetchedResultsController.objectAtIndexPath(indexPath) as! DataItem
                let view = factory.supplementaryViewForItem(dataItem, kind: kind, inCollectionView: collectionView, atIndexPath: indexPath)
                return factory.configureSupplementaryView(view, forItem: dataItem, kind: kind, inCollectionView: collectionView, atIndexPath: indexPath)
            }
            // we must not return nil here, per the `UICollectionViewDataSource` docs
            // however, this will never get called as it is the client's responsibilty
            // supplementary views are hidden by returning `CGSizeZero` from `collectionView(_:layout:referenceSizeForHeaderInSection:)`
            return UICollectionReusableView()
        })
}


/*
This separate type is required for Objective-C interoperability (interacting with Cocoa).
Because the DataSourceProvider is generic it cannot be bridged to Objective-C.
That is, it cannot be assigned to `UICollectionView.dataSource`.
*/
@objc private final class BridgedCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    typealias NumberOfSectionsHandler = () -> Int
    typealias NumberOfItemsInSectionHandler = (Int) -> Int
    typealias CellForItemAtIndexPathHandler = (UICollectionView, NSIndexPath) -> UICollectionViewCell
    typealias SupplementaryViewAtIndexPathHandler = (UICollectionView, String, NSIndexPath) -> UICollectionReusableView

    let numberOfSections: NumberOfSectionsHandler
    let numberOfItemsInSection: NumberOfItemsInSectionHandler
    let cellForItemAtIndexPath: CellForItemAtIndexPathHandler
    let supplementaryViewAtIndexPath: SupplementaryViewAtIndexPathHandler

    init(numberOfSections: NumberOfSectionsHandler,
        numberOfItemsInSection: NumberOfItemsInSectionHandler,
        cellForItemAtIndexPath: CellForItemAtIndexPathHandler,
        supplementaryViewAtIndexPath: SupplementaryViewAtIndexPathHandler) {

            self.numberOfSections = numberOfSections
            self.numberOfItemsInSection = numberOfItemsInSection
            self.cellForItemAtIndexPath = cellForItemAtIndexPath
            self.supplementaryViewAtIndexPath = supplementaryViewAtIndexPath
    }

    @objc func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }

    @objc func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection(section)
    }

    @objc func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return cellForItemAtIndexPath(collectionView, indexPath)
    }
    
    @objc func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: SupplementaryViewKind,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            return supplementaryViewAtIndexPath(collectionView, kind, indexPath)
    }
}
