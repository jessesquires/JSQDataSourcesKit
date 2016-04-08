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
 A `CollectionViewFetchedResultsDelegateProvider` is responsible for providing a delegate object
 for an instance of `NSFetchedResultsController` that manages data to display in a collection view.

 - warning: The `CellFactory.Item` type should correspond to the type of objects that the `NSFetchedResultsController` fetches.
 */
public final class CollectionViewFetchedResultsDelegateProvider <CellFactory: CollectionViewCellFactoryType>: CustomStringConvertible {

    // MARK: Typealiases

    /// The type of elements for the delegate provider.
    public typealias Item = CellFactory.Item


    // MARK: Properties

    /**
     The collection view that displays the data from the `NSFetchedResultsController`
     for which this provider provides a delegate.
     */
    public weak var collectionView: UICollectionView?

    /// Returns the cell factory for this delegate provider.
    public let cellFactory: CellFactory

    /// Returns the delegate object for the fetched results controller
    public var delegate: NSFetchedResultsControllerDelegate { return bridgedDelegate }


    // MARK: Initialization

    /**
     Constructs a new delegate provider for a fetched results controller.

     - parameter collectionView:           The collection view to be updated when the fetched results change.
     - parameter cellFactory:              The cell factory from which the fetched results controller delegate will configure cells.
     - parameter fetchedResultsController: The fetched results controller whose delegate will be provided by this provider.

     - returns: A new `CollectionViewFetchedResultsDelegateProvider` instance.
     */
    public init(collectionView: UICollectionView,
                cellFactory: CellFactory,
                fetchedResultsController: NSFetchedResultsController) {
        assert(fetchedResultsController: fetchedResultsController,
               fetchesObjectsOfClass: Item.self as! AnyClass)

        self.collectionView = collectionView
        self.cellFactory = cellFactory
        fetchedResultsController.delegate = delegate
    }


    // MARK: CustomStringConvertible

    /// :nodoc:
    public var description: String {
        get {
            return "<\(CollectionViewFetchedResultsDelegateProvider.self): collectionView=\(collectionView)>"
        }
    }


    // MARK: Private

    private typealias SectionChangeTuple = (changeType: NSFetchedResultsChangeType, sectionIndex: Int)
    private var sectionChanges = [SectionChangeTuple]()

    private typealias ObjectChangeTuple = (changeType: NSFetchedResultsChangeType, indexPaths: [NSIndexPath])
    private var objectChanges = [ObjectChangeTuple]()

    private var updatedObjects = [NSIndexPath: Item]()

    private lazy var bridgedDelegate: BridgedFetchedResultsDelegate = BridgedFetchedResultsDelegate(
        willChangeContent: { [unowned self] (controller) in
            self.sectionChanges.removeAll()
            self.objectChanges.removeAll()
            self.updatedObjects.removeAll()
        },
        didChangeSection: { [unowned self] (controller, sectionInfo, sectionIndex, changeType) in
            self.sectionChanges.append((changeType, sectionIndex))
        },
        didChangeObject: { [unowned self] (controller, anyObject, indexPath: NSIndexPath?, changeType, newIndexPath: NSIndexPath?) in
            switch changeType {
            case .Insert:
                if let insertIndexPath = newIndexPath {
                    self.objectChanges.append((changeType, [insertIndexPath]))
                }
            case .Delete:
                if let deleteIndexPath = indexPath {
                    self.objectChanges.append((changeType, [deleteIndexPath]))
                }
            case .Update:
                if let indexPath = indexPath {
                    self.objectChanges.append((changeType, [indexPath]))
                    self.updatedObjects[indexPath] = anyObject as? Item
                }
            case .Move:
                if let old = indexPath, new = newIndexPath {
                    self.objectChanges.append((changeType, [old, new]))
                }
            }
        },
        didChangeContent: { [unowned self] (controller) in

            self.collectionView?.performBatchUpdates({ [weak self] in
                self?.applyObjectChanges()
                self?.applySectionChanges()
                },
                completion:{ [weak self] finished in
                    self?.reloadSupplementaryViewsIfNeeded()
                })
        })

    private func applyObjectChanges() {
        for (changeType, indexPaths) in objectChanges {

            switch(changeType) {
            case .Insert:
                collectionView?.insertItemsAtIndexPaths(indexPaths)
            case .Delete:
                collectionView?.deleteItemsAtIndexPaths(indexPaths)
            case .Update:
                if let indexPath = indexPaths.first,
                    item = updatedObjects[indexPath],
                    cell = collectionView?.cellForItemAtIndexPath(indexPath) as? CellFactory.Cell,
                    view = collectionView {
                    cellFactory.configureCell(cell, forItem: item, inCollectionView: view, atIndexPath: indexPath)
                }
            case .Move:
                if let deleteIndexPath = indexPaths.first {
                    self.collectionView?.deleteItemsAtIndexPaths([deleteIndexPath])
                }

                if let insertIndexPath = indexPaths.last {
                    self.collectionView?.insertItemsAtIndexPaths([insertIndexPath])
                }
            }
        }
    }

    private func applySectionChanges() {
        for (changeType, sectionIndex) in sectionChanges {
            let section = NSIndexSet(index: sectionIndex)

            switch(changeType) {
            case .Insert:
                collectionView?.insertSections(section)
            case .Delete:
                collectionView?.deleteSections(section)
            default:
                break
            }
        }
    }

    private func reloadSupplementaryViewsIfNeeded() {
        if sectionChanges.count > 0 {
            collectionView?.reloadData()
        }
    }

}

/**
 A `TableViewFetchedResultsDelegateProvider` is responsible for providing a delegate object
 for an instance of `NSFetchedResultsController` that manages data to display in a table view.

 - warning: The `CellFactory.Item` type should correspond to the type of objects that the `NSFetchedResultsController` fetches.
 */
public final class TableViewFetchedResultsDelegateProvider <CellFactory: TableViewCellFactoryType>: CustomStringConvertible {

    // MARK: Typealiases

    /// The type of elements for the delegate provider.
    public typealias Item = CellFactory.Item


    // MARK: Properties

    /**
     The table view that displays the data from the `NSFetchedResultsController`
     for which this provider provides a delegate.
     */
    public weak var tableView: UITableView?

    /// Returns the cell factory for this delegate provider.
    public let cellFactory: CellFactory

    /// Returns the object that is notified when the fetched results changed.
    public var delegate: NSFetchedResultsControllerDelegate { return bridgedDelegate }


    // MARK: Initialization

    /**
     Constructs a new delegate provider for a fetched results controller.

     - parameter tableView:                The table view to be updated when the fetched results change.
     - parameter cellFactory:              The cell factory from which the fetched results controller delegate will configure cells.
     - parameter fetchedResultsController: The fetched results controller whose delegate will be provided by this provider.

     - returns: A new `TableViewFetchedResultsDelegateProvider` instance.
     */
    public init(tableView: UITableView, cellFactory: CellFactory, fetchedResultsController: NSFetchedResultsController) {
        assert(fetchedResultsController: fetchedResultsController,
               fetchesObjectsOfClass: Item.self as! AnyClass)

        self.tableView = tableView
        self.cellFactory = cellFactory
        fetchedResultsController.delegate = delegate
    }


    // MARK: CustomStringConvertible

    /// :nodoc:
    public var description: String {
        get {
            return "<\(TableViewFetchedResultsDelegateProvider.self): tableView=\(tableView)>"
        }
    }


    // MARK: Private

    private lazy var bridgedDelegate: BridgedFetchedResultsDelegate = BridgedFetchedResultsDelegate(
        willChangeContent: { [unowned self] (controller) in
            self.tableView?.beginUpdates()
        },
        didChangeSection: { [unowned self] (controller, sectionInfo, sectionIndex, changeType) in
            switch changeType {
            case .Insert:
                self.tableView?.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            case .Delete:
                self.tableView?.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            default:
                break
            }
        },
        didChangeObject: { [unowned self] (controller, anyObject, indexPath, changeType, newIndexPath) in
            switch changeType {
            case .Insert:
                if let insertIndexPath = newIndexPath {
                    self.tableView?.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: .Fade)
                }
            case .Delete:
                if let deleteIndexPath = indexPath {
                    self.tableView?.deleteRowsAtIndexPaths([deleteIndexPath], withRowAnimation: .Fade)
                }
            case .Update:
                if let indexPath = indexPath,
                    cell = self.tableView?.cellForRowAtIndexPath(indexPath) as? CellFactory.Cell,
                    view = self.tableView {
                    self.cellFactory.configureCell(cell, forItem: anyObject as! Item, inTableView: view, atIndexPath: indexPath)
                }
            case .Move:
                if let deleteIndexPath = indexPath {
                    self.tableView?.deleteRowsAtIndexPaths([deleteIndexPath], withRowAnimation: .Fade)
                }

                if let insertIndexPath = newIndexPath {
                    self.tableView?.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: .Fade)
                }
            }
        },
        didChangeContent: { [unowned self] (controller) in
            self.tableView?.endUpdates()
        })
}


/*
 Avoid making DelegateProvider inherit from NSObject.
 Keep classes pure Swift.
 Keep responsibilies focused.
 */
@objc private final class BridgedFetchedResultsDelegate: NSObject, NSFetchedResultsControllerDelegate {

    typealias WillChangeContentHandler = (NSFetchedResultsController) -> Void
    typealias DidChangeSectionHandler = (NSFetchedResultsController, NSFetchedResultsSectionInfo, Int, NSFetchedResultsChangeType) -> Void
    typealias DidChangeObjectHandler = (NSFetchedResultsController, AnyObject, NSIndexPath?, NSFetchedResultsChangeType, NSIndexPath?) -> Void
    typealias DidChangeContentHandler = (NSFetchedResultsController) -> Void

    let willChangeContent: WillChangeContentHandler
    let didChangeSection: DidChangeSectionHandler
    let didChangeObject: DidChangeObjectHandler
    let didChangeContent: DidChangeContentHandler

    init(willChangeContent: WillChangeContentHandler,
         didChangeSection: DidChangeSectionHandler,
         didChangeObject: DidChangeObjectHandler,
         didChangeContent: DidChangeContentHandler) {

        self.willChangeContent = willChangeContent
        self.didChangeSection = didChangeSection
        self.didChangeObject = didChangeObject
        self.didChangeContent = didChangeContent
    }

    @objc func controllerWillChangeContent(controller: NSFetchedResultsController) {
        willChangeContent(controller)
    }

    @objc func controller(controller: NSFetchedResultsController,
                          didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                                           atIndex sectionIndex: Int,
                                                   forChangeType type: NSFetchedResultsChangeType) {
        didChangeSection(controller, sectionInfo, sectionIndex, type)
    }

    @objc func controller(controller: NSFetchedResultsController,
                          didChangeObject anObject: AnyObject,
                                          atIndexPath indexPath: NSIndexPath?,
                                                      forChangeType type: NSFetchedResultsChangeType,
                                                                    newIndexPath: NSIndexPath?) {
        didChangeObject(controller, anObject, indexPath, type, newIndexPath)
    }
    
    @objc func controllerDidChangeContent(controller: NSFetchedResultsController) {
        didChangeContent(controller)
    }
}
