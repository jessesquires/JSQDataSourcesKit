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
 A `CollectionViewFetchedResultsDataSourceProvider` is responsible for providing a data source object
 for a collection view that is backed by an `NSFetchedResultsController` instance.

 - warning: The `CellFactory.Item` type should correspond to the type of objects that the `NSFetchedResultsController` fetches.
 - note: Clients are responsbile for registering cells and supplementary views with the collection view.
 */
public final class CollectionViewFetchedResultsDataSourceProvider <
    CellFactory: ReusableViewFactoryProtocol, SupplementaryViewFactory: ReusableViewFactoryProtocol
    where
    CellFactory.Item == SupplementaryViewFactory.Item,
    CellFactory.View: UICollectionViewCell,
    SupplementaryViewFactory.View: UICollectionReusableView>: CustomStringConvertible {

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
    public init(fetchedResultsController: NSFetchedResultsController,
                cellFactory: CellFactory,
                supplementaryViewFactory: SupplementaryViewFactory? = nil,
                collectionView: UICollectionView? = nil) {
        assert(fetchedResultsController: fetchedResultsController, fetchesObjectsOfClass: Item.self as! AnyClass)

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

    private lazy var bridgedDataSource: BridgedDataSource = {
        let dataSource = BridgedDataSource(
            numberOfSections: { [unowned self] () -> Int in
                return self.fetchedResultsController.sections?.count ?? 0
            },
            numberOfItemsInSection: { [unowned self] (section) -> Int in
                return (self.fetchedResultsController.sections?[section])?.numberOfObjects ?? 0
            })

        dataSource.collectionCellForItemAtIndexPath = { [unowned self] (collectionView, indexPath) -> UICollectionViewCell in
            let item = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Item
            return self.cellFactory.collectionCellFor(item: item, parentView: collectionView, indexPath: indexPath)
        }

        dataSource.collectionSupplementaryViewAtIndexPath = { [unowned self] (collectionView, kind, indexPath) -> UICollectionReusableView in
            let factory = self.supplementaryViewFactory!
            var item: Item?
            if indexPath.section < self.fetchedResultsController.sections?.count {
                if indexPath.item < self.fetchedResultsController.sections?[indexPath.section].numberOfObjects {
                    item = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Item
                }
            }
            return factory.supplementaryViewFor(item: item, kind: kind, parentView: collectionView, indexPath: indexPath)
        }

        return dataSource
    }()
}
