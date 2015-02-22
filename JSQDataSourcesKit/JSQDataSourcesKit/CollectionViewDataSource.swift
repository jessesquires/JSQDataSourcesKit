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

    typealias CellConfigurationHandler = (Cell, DataItem, UICollectionView, NSIndexPath) -> Cell

    private let reuseIdentifier: String

    private let cellConfigurator: CellConfigurationHandler

    public init(reuseIdentifier: String, cellConfigurator: CellConfigurationHandler) {
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }

    public func cellForItem(item: DataItem, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> Cell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! Cell
        return configureCell(cell, forItem: item, inCollectionView: collectionView, atIndexPath: indexPath)
    }

    public func configureCell(cell: Cell, forItem item: DataItem, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> Cell {
        return self.cellConfigurator(cell, item, collectionView, indexPath)
    }

}


public protocol CollectionViewSectionInfo {
    typealias DataItem

    var dataItems: [DataItem] { get }

    var headerTitle: String? { get }

    var footerTitle: String? { get }
}


public struct CollectionViewSection <DataItem>: CollectionViewSectionInfo {

    public var dataItems: [DataItem]

    public let headerTitle: String?

    public let footerTitle: String?

    public init(dataItems: [DataItem], headerTitle: String? = nil, footerTitle: String? = nil) {
        self.dataItems = dataItems
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
    }
    
}


public class CollectionViewDataSourceProvider <DataItem, SectionInfo: CollectionViewSectionInfo, CellFactory: CollectionViewCellFactoryType
                                                where
                                                SectionInfo.DataItem == DataItem,
                                                CellFactory.DataItem == DataItem> {

    public var sections: [SectionInfo]

    public let cellFactory: CellFactory

    public var dataSource: UICollectionViewDataSource { return bridgedDataSource }

    public init(sections: [SectionInfo], cellFactory: CellFactory, collectionView: UICollectionView? = nil) {
        self.sections = sections
        self.cellFactory = cellFactory

        collectionView?.dataSource = self.dataSource
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
            return self.cellFactory.cellForItem(dataItem, inCollectionView: collectionView, atIndexPath: indexPath)
        }
    )

}


public class CollectionViewFetchedResultsDataSourceProvider <DataItem, CellFactory: CollectionViewCellFactoryType
                                                             where CellFactory.DataItem == DataItem> {

    public let fetchedResultsController: NSFetchedResultsController

    public let cellFactory: CellFactory

    public var dataSource: UICollectionViewDataSource { return bridgedDataSource }

    public init(fetchedResultsController: NSFetchedResultsController, cellFactory: CellFactory, collectionView: UICollectionView? = nil) {
        self.fetchedResultsController = fetchedResultsController
        self.cellFactory = cellFactory

        collectionView?.dataSource = self.dataSource
    }

    private lazy var bridgedDataSource: BridgedCollectionViewDataSource = BridgedCollectionViewDataSource(
        numberOfSections: { [unowned self] () -> Int in
            self.fetchedResultsController.sections?.count ?? 0
        },
        numberOfItemsInSection: { [unowned self] (section) -> Int in
            let sectionInfo = self.fetchedResultsController.sections?[section] as! NSFetchedResultsSectionInfo
            return sectionInfo.numberOfObjects ?? 0
        },
        cellForItemAtIndexPath: { [unowned self] (collectionView, indexPath) -> UICollectionViewCell in
            let dataItem = self.fetchedResultsController.objectAtIndexPath(indexPath) as! DataItem
            return self.cellFactory.cellForItem(dataItem, inCollectionView: collectionView, atIndexPath: indexPath)
        }
    )

}


@objc private class BridgedCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    typealias NumberOfSectionsHandler = () -> Int
    typealias NumberOfItemsInSectionHandler = (Int) -> Int
    typealias CellForItemAtIndexPathHandler = (UICollectionView, NSIndexPath) -> UICollectionViewCell

    private let numberOfSections: NumberOfSectionsHandler
    private let numberOfItemsInSection: NumberOfItemsInSectionHandler
    private let cellForItemAtIndexPath: CellForItemAtIndexPathHandler

    init(numberOfSections: NumberOfSectionsHandler,
        numberOfItemsInSection: NumberOfItemsInSectionHandler,
        cellForItemAtIndexPath: CellForItemAtIndexPathHandler) {

            self.numberOfSections = numberOfSections
            self.numberOfItemsInSection = numberOfItemsInSection
            self.cellForItemAtIndexPath = cellForItemAtIndexPath
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

}
