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
 A `CollectionViewDataSourceProvider` is responsible for providing a data source object for a collection view.

 **Clients are responsbile for the follwing:**

 - Registering cells with the collection view
 - Registering supplementary views with the collection view
 - Adding, removing, or reloading cells as the provider's `sections` are modified
 - Adding, removing, or reloading sections as the provider's `sections` are modified
 */
public final class CollectionViewDataSourceProvider <
    SectionInfo: CollectionViewSectionInfo,
    CellFactory: CollectionViewCellFactoryType,
    SupplementaryViewFactory: CollectionSupplementaryViewFactoryType
    where CellFactory.Item == SectionInfo.Item, SupplementaryViewFactory.Item == SectionInfo.Item>: CustomStringConvertible {

    // MARK: Typealiases

    /// The type of elements for the data source provider.
    public typealias Item = SectionInfo.Item


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
    public init(
        sections: [SectionInfo],
        cellFactory: CellFactory,
        supplementaryViewFactory: SupplementaryViewFactory? = nil,
        collectionView: UICollectionView? = nil) {
            self.sections = sections
            self.cellFactory = cellFactory
            self.supplementaryViewFactory = supplementaryViewFactory
            collectionView?.dataSource = dataSource
    }


    // MARK: Subscripts

    /**
    - parameter index: The index of the section to return.

    - returns: The section at `index`.
    */
    public subscript (index: Int) -> SectionInfo {
        get {
            return sections[index]
        }
        set {
            sections[index] = newValue
        }
    }

    /**
     - parameter indexPath: The index path of the item to return.

     - returns: The item at `indexPath`.
     */
    public subscript (indexPath: NSIndexPath) -> Item {
        get {
            return sections[indexPath.section].items[indexPath.item];
        }
        set {
            sections[indexPath.section].items[indexPath.item] = newValue;
        }
    }


    // MARK: CustomStringConvertible

    /// :nodoc:
    public var description: String {
        get {
            return "<\(CollectionViewDataSourceProvider.self): sections=\(sections)>"
        }
    }


    // MARK: Private

    private lazy var bridgedDataSource: BridgedCollectionViewDataSource = BridgedCollectionViewDataSource(
        numberOfSections: { [unowned self] () -> Int in
            self.sections.count
        },
        numberOfItemsInSection: { [unowned self] (section) -> Int in
            self.sections[section].items.count
        },
        cellForItemAtIndexPath: { [unowned self] (collectionView, indexPath) -> UICollectionViewCell in
            let item = self.sections[indexPath.section].items[indexPath.row]
            let cell = self.cellFactory.cellForItem(item, inCollectionView: collectionView, atIndexPath: indexPath)
            return self.cellFactory.configureCell(cell, forItem: item, inCollectionView: collectionView, atIndexPath: indexPath)
        },
        supplementaryViewAtIndexPath: { [unowned self] (collectionView, kind, indexPath) -> UICollectionReusableView in
            if let factory = self.supplementaryViewFactory {
                let item = self.sections[indexPath.section].items[indexPath.row]
                let view = factory.supplementaryViewForItem(item, kind: kind, inCollectionView: collectionView, atIndexPath: indexPath)
                return factory.configureSupplementaryView(view, forItem: item, kind: kind, inCollectionView: collectionView, atIndexPath: indexPath)
            }

            // we must not return nil here, per the `UICollectionViewDataSource` docs
            // however, this will never get called as it is the client's responsibilty
            // supplementary views are hidden by returning `CGSizeZero`
            // from `collectionView(_:layout:referenceSizeForHeaderInSection:)`
            fatalError("Attempt to dequeue unknown or invalid supplementary view <\(kind)> "
                + "for collection view <\(collectionView)> at indexPath <\(indexPath)>")
        })
}


/**
 A `CollectionViewFetchedResultsDataSourceProvider` is responsible for providing a data source object
 for a collection view that is backed by an `NSFetchedResultsController` instance.

 The `CellFactory.Item` type should correspond to the type of objects that the `NSFetchedResultsController` fetches.

 - note: Clients are responsbile for registering cells and supplementary views with the collection view.
 */
public final class CollectionViewFetchedResultsDataSourceProvider <
    CellFactory: CollectionViewCellFactoryType,
    SupplementaryViewFactory: CollectionSupplementaryViewFactoryType
    where CellFactory.Item == SupplementaryViewFactory.Item>: CustomStringConvertible {

    // MARK: Typealiases

    /// The type of elements for the data source provider.
    public typealias Item = CellFactory.Item


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
    public init(
        fetchedResultsController: NSFetchedResultsController,
        cellFactory: CellFactory,
        supplementaryViewFactory: SupplementaryViewFactory? = nil,
        collectionView: UICollectionView? = nil) {
            assert(fetchedResultsController: fetchedResultsController,
                fetchesObjectsOfClassName: String(reflecting: Item.self))

            self.fetchedResultsController = fetchedResultsController
            self.cellFactory = cellFactory
            self.supplementaryViewFactory = supplementaryViewFactory
            collectionView?.dataSource = dataSource
    }


    // MARK: CustomStringConvertible

    /// :nodoc:
    public var description: String {
        get {
            return "<\(CollectionViewFetchedResultsDataSourceProvider.self): fetchedResultsController=\(fetchedResultsController)>"
        }
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
            let item = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Item
            let cell = self.cellFactory.cellForItem(item, inCollectionView: collectionView, atIndexPath: indexPath)
            return self.cellFactory.configureCell(cell, forItem: item, inCollectionView: collectionView, atIndexPath: indexPath)
        },
        supplementaryViewAtIndexPath: { [unowned self] (collectionView, kind, indexPath) -> UICollectionReusableView in
            if let factory = self.supplementaryViewFactory {
                let item = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Item
                let view = factory.supplementaryViewForItem(item, kind: kind, inCollectionView: collectionView, atIndexPath: indexPath)
                return factory.configureSupplementaryView(view, forItem: item, kind: kind, inCollectionView: collectionView, atIndexPath: indexPath)
            }

            // we must not return nil here, per the `UICollectionViewDataSource` docs
            // however, this will never get called as it is the client's responsibilty
            // supplementary views are hidden by returning `CGSizeZero`
            // from `collectionView(_:layout:referenceSizeForHeaderInSection:)`
            fatalError("Attempt to dequeue unknown or invalid supplementary view <\(kind)> "
                + "for collection view <\(collectionView)> at indexPath <\(indexPath)>")
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
