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


public protocol CollectionViewCellFactoryType {

    typealias DataItem

    typealias Cell: UICollectionViewCell

    func cellForItem(item: DataItem, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> Cell

    func configureCell(cell: Cell, forItem item: DataItem, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> Cell
}


public struct CollectionViewCellFactory <Cell: UICollectionViewCell, DataItem>: CollectionViewCellFactoryType {

    public typealias ConfigurationHandler = (Cell, DataItem, UICollectionView, NSIndexPath) -> Cell

    public let reuseIdentifier: String

    private let cellConfigurator: ConfigurationHandler

    public init(reuseIdentifier: String, cellConfigurator: ConfigurationHandler) {
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }

    public func cellForItem(item: DataItem, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> Cell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! Cell
    }

    public func configureCell(cell: Cell, forItem item: DataItem, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> Cell {
        return cellConfigurator(cell, item, collectionView, indexPath)
    }
}


public typealias SupplementaryViewKind = String

public protocol CollectionSupplementaryViewFactoryType {

    typealias DataItem

    typealias SupplementaryView: UICollectionReusableView

    func supplementaryViewForItem(item: DataItem, kind: SupplementaryViewKind,
                                  inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> SupplementaryView

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

        collectionView?.dataSource = self.dataSource
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

        collectionView?.dataSource = self.dataSource
    }

    public func performFetch(error: NSErrorPointer = nil) -> Bool {
        let success = self.fetchedResultsController.performFetch(error)
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

    private let numberOfSections: NumberOfSectionsHandler
    private let numberOfItemsInSection: NumberOfItemsInSectionHandler
    private let cellForItemAtIndexPath: CellForItemAtIndexPathHandler
    private let supplementaryViewAtIndexPath: SupplementaryViewAtIndexPathHandler

    init(numberOfSections: NumberOfSectionsHandler,
        numberOfItemsInSection: NumberOfItemsInSectionHandler,
        cellForItemAtIndexPath: CellForItemAtIndexPathHandler,
        supplementaryViewAtIndexPath: SupplementaryViewAtIndexPathHandler) {

            self.numberOfSections = numberOfSections
            self.numberOfItemsInSection = numberOfItemsInSection
            self.cellForItemAtIndexPath = cellForItemAtIndexPath
            self.supplementaryViewAtIndexPath = supplementaryViewAtIndexPath
    }

    @objc private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }

    @objc private func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection(section)
    }

    @objc private func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return cellForItemAtIndexPath(collectionView, indexPath)
    }

    @objc private func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: SupplementaryViewKind,
                                      atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return supplementaryViewAtIndexPath(collectionView, kind, indexPath)
    }
}
