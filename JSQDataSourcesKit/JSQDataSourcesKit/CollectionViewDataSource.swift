//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://www.jessesquires.com/JSQDataSourcesKit/
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


///  An instance conforming to `CollectionViewCellFactoryType` is responsible for initializing
///  and configuring collection view cells to be consumed by an instance of `CollectionViewDataSourceProvider`.
///  The `CollectionViewCellFactoryType` protocol has two associated types, `DataItem` and `Cell`.
///  These associated types describe the type of model instances backing the collection view
///  and the type of cells in the collection view, respectively. 
public protocol CollectionViewCellFactoryType {

    /// The type of the instance (model object) backing the collection view.
    typealias DataItem

    /// The type of `UICollectionViewCell` that the factory produces.
    typealias Cell: UICollectionViewCell

    ///  Creates and returns a new or dequeued `Cell` instance.
    ///
    ///  :param: item           The model instance (data object) at `indexPath`.
    ///  :param: collectionView The collection view requesting this information.
    ///  :param: indexPath      The index path that specifies the location of `cell` and `item`.
    ///
    ///  :returns: An initialized or dequeued `UICollectionViewCell` of type `Cell`.
    func cellForItem(item: DataItem, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> Cell

    ///  Configures and returns the specified cell.
    ///
    ///  :param: cell           The cell to configure.
    ///  :param: item           The model instance (data object) at `indexPath`.
    ///  :param: collectionView The collection view requesting this information.
    ///  :param: indexPath      The index path that specifies the location of `cell` and `item`.
    ///
    ///  :returns: A configured `UICollectionViewCell` of type `Cell`.
    func configureCell(cell: Cell, forItem item: DataItem, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> Cell
}


///  A `CollectionViewCellFactory` is a concrete `CollectionViewCellFactoryType`.
///  This factory is responsible for producing and configuring collection view cells for a specific data item.
public struct CollectionViewCellFactory <Cell: UICollectionViewCell, DataItem>: CollectionViewCellFactoryType {

    ///  Configures the cell for the specified data item, collection view and index path.
    ///
    ///  :param: Cell             The cell to be configured at the index path.
    ///  :param: DataItem         The data item at the index path.
    ///  :param: UICollectionView The collection view requesting this information.
    ///  :param: NSIndexPath      The index path at which the cell will be displayed.
    ///
    ///  :returns: The configured cell.
    public typealias ConfigurationHandler = (Cell, DataItem, UICollectionView, NSIndexPath) -> Cell

    /// A unique identifier that describes the purpose of the cells that the factory produces.
    /// The factory dequeues cells from the collection view with this reuse identifier.
    public let reuseIdentifier: String

    private let cellConfigurator: ConfigurationHandler

    ///  Initializes and returns a new collection view cell factory.
    ///
    ///  :param: reuseIdentifier  The reuse identifier with which the factory will dequeue cells.
    ///  :param: cellConfigurator The closure with which the factory will configure cells.
    ///
    ///  :returns: A new `CollectionViewCellFactory` instance.
    public init(reuseIdentifier: String, cellConfigurator: ConfigurationHandler) {
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }

    ///  Creates and returns a new or dequeued `Cell` instance.
    ///
    ///  :param: item           The model instance (data object) at `indexPath`.
    ///  :param: collectionView The collection view requesting this information.
    ///  :param: indexPath      The index path that specifies the location of `cell` and `item`.
    ///
    ///  :returns: An initialized or dequeued `UICollectionViewCell` of type `Cell`.
    public func cellForItem(item: DataItem, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> Cell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! Cell
    }

    ///  Configures and returns the specified cell.
    ///
    ///  :param: cell           The cell to configure.
    ///  :param: item           The model instance (data object) at `indexPath`.
    ///  :param: collectionView The collection view requesting this information.
    ///  :param: indexPath      The index path that specifies the location of `cell` and `item`.
    ///
    ///  :returns: A configured `UICollectionViewCell` of type `Cell`.
    public func configureCell(cell: Cell, forItem item: DataItem, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> Cell {
        return cellConfigurator(cell, item, collectionView, indexPath)
    }
}


///  Describes a collection view element kind, such as `UICollectionElementKindSectionHeader`.
public typealias SupplementaryViewKind = String


///  An instance conforming to `CollectionSupplementaryViewFactoryType` is responsible for initializing
///  and configuring collection view supplementary views to be consumed by an instance of `CollectionViewDataSourceProvider`.
///
///  The `CollectionSupplementaryViewFactoryType` protocol has two associated types, `DataItem` and `SupplementaryView`.
///  These associated types describe the type of model instances backing the collection view
///  and the type of supplementary views in the collection view, respectively.
public protocol CollectionSupplementaryViewFactoryType {

    /// The type of the instance (model object) backing the collection view.
    typealias DataItem

    /// The type of `UICollectionReusableView` that the factory produces.
    typealias SupplementaryView: UICollectionReusableView

    ///  Creates annd returns a new or dequeued `SupplementaryView` instance.
    ///
    ///  :param: item           The model instance (data object) at `indexPath`.
    ///  :param: kind           An identifier that describes the type of the supplementary view.
    ///  :param: collectionView The collection view requesting this information.
    ///  :param: indexPath      The index path that specifies the location of the new supplementary view.
    ///
    ///  :returns: An initialized or dequeued `UICollectionReusableView` of type `SupplementaryView`.
    func supplementaryViewForItem(item: DataItem, kind: SupplementaryViewKind,
                                  inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> SupplementaryView

    ///  Configures and returns the specified supplementary view.
    ///
    ///  :param: view           The supplementary view to configure.
    ///  :param: item           The model instance (data object) at `indexPath`.
    ///  :param: kind           An identifier that describes the type of the supplementary view.
    ///  :param: collectionView The collection view requesting this information.
    ///  :param: indexPath      The index path that specifies the location of `view` and `item`.
    ///
    ///  :returns: A configured `UICollectionReusableView` of type `SupplementaryView`.
    func configureSupplementaryView(view: SupplementaryView, forItem item: DataItem, kind: SupplementaryViewKind,
                                    inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> SupplementaryView
}


public struct CollectionSupplementaryViewFactory <SupplementaryView: UICollectionReusableView, DataItem>: CollectionSupplementaryViewFactoryType {

    public typealias ConfigurationHandler = (SupplementaryView, DataItem, SupplementaryViewKind, UICollectionView, NSIndexPath) -> SupplementaryView

    public let reuseIdentifier: String

    private let supplementaryViewConfigurator: ConfigurationHandler

    public init(reuseIdentifier: String, supplementaryViewConfigurator: ConfigurationHandler) {
        self.reuseIdentifier = reuseIdentifier
        self.supplementaryViewConfigurator = supplementaryViewConfigurator
    }

    public func supplementaryViewForItem(item: DataItem, kind: SupplementaryViewKind,
                                         inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> SupplementaryView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseIdentifier, forIndexPath: indexPath) as! SupplementaryView
    }

    public func configureSupplementaryView(view: SupplementaryView, forItem item: DataItem, kind: SupplementaryViewKind,
                                           inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> SupplementaryView {
        return supplementaryViewConfigurator(view, item, kind, collectionView, indexPath)
    }
}


public protocol CollectionViewSectionInfo {

    typealias DataItem

    var dataItems: [DataItem] { get }
}


public struct CollectionViewSection <DataItem>: CollectionViewSectionInfo {

    public var dataItems: [DataItem]

    public var count: Int {
        return dataItems.count
    }

    public init(dataItems: [DataItem]) {
        self.dataItems = dataItems
    }

    public subscript (index: Int) -> DataItem {
        get {
            return dataItems[index]
        }
        set {
            dataItems[index] = newValue
        }
    }
}


public final class CollectionViewDataSourceProvider <DataItem, SectionInfo: CollectionViewSectionInfo,
                                                     CellFactory: CollectionViewCellFactoryType, SupplementaryViewFactory: CollectionSupplementaryViewFactoryType
                                                     where
                                                     SectionInfo.DataItem == DataItem,
                                                     CellFactory.DataItem == DataItem,
                                                     SupplementaryViewFactory.DataItem == DataItem> {

    public var sections: [SectionInfo]

    public let cellFactory: CellFactory

    public let supplementaryViewFactory: SupplementaryViewFactory?

    public var dataSource: UICollectionViewDataSource { return bridgedDataSource }

    public init(sections: [SectionInfo], cellFactory: CellFactory, supplementaryViewFactory: SupplementaryViewFactory? = nil, collectionView: UICollectionView? = nil) {
        self.sections = sections
        self.cellFactory = cellFactory
        self.supplementaryViewFactory = supplementaryViewFactory

        collectionView?.dataSource = dataSource
    }

    public subscript (index: Int) -> SectionInfo {
        get {
            return sections[index]
        }
        set {
            sections[index] = newValue
        }
    }

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


public final class CollectionViewFetchedResultsDataSourceProvider <DataItem, CellFactory: CollectionViewCellFactoryType,
                                                                    SupplementaryViewFactory: CollectionSupplementaryViewFactoryType
                                                                    where
                                                                    CellFactory.DataItem == DataItem,
                                                                    SupplementaryViewFactory.DataItem == DataItem> {

    public let fetchedResultsController: NSFetchedResultsController

    public let cellFactory: CellFactory

    public let supplementaryViewFactory: SupplementaryViewFactory?

    public var dataSource: UICollectionViewDataSource { return bridgedDataSource }

    public init(fetchedResultsController: NSFetchedResultsController, cellFactory: CellFactory, supplementaryViewFactory: SupplementaryViewFactory? = nil, collectionView: UICollectionView? = nil) {
        self.fetchedResultsController = fetchedResultsController
        self.cellFactory = cellFactory
        self.supplementaryViewFactory = supplementaryViewFactory

        collectionView?.dataSource = dataSource
    }

    public func performFetch(error: NSErrorPointer = nil) -> Bool {
        let success = fetchedResultsController.performFetch(error)
        if !success {
            println("*** ERROR: \(toString(CollectionViewFetchedResultsDataSourceProvider.self))"
                    + "\n\t [\(__LINE__)] \(__FUNCTION__) Could not perform fetch error: \(error)")
        }
        return success
    }

    private lazy var bridgedDataSource: BridgedCollectionViewDataSource = BridgedCollectionViewDataSource(
        numberOfSections: { [unowned self] () -> Int in
            self.fetchedResultsController.sections?.count ?? 0
        },
        numberOfItemsInSection: { [unowned self] (section) -> Int in
            let sectionInfo = self.fetchedResultsController.sections?[section] as? NSFetchedResultsSectionInfo
            return sectionInfo?.numberOfObjects ?? 0
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


/**
*   This separate type is required for Objective-C interoperability (interacting with Cocoa).
*   Because the DataSourceProvider is generic it cannot be bridged to Objective-C.
*   That is, it cannot be assigned to `UICollectionView.dataSource`.
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
