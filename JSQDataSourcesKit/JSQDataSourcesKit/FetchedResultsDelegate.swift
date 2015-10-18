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

Here, the `Item` type parameter acts as a phatom type.

- note: This type should correpsond to the type of objects that the `NSFetchedResultsController` fetches.
*/
public final class CollectionViewFetchedResultsDelegateProvider <Item> {

    // MARK: Properties

    /** 
    The collection view that displays the data from the `NSFetchedResultsController`
    for which this provider provides a delegate.
    */
    public weak var collectionView: UICollectionView?

    /// Returns the delegate object for the fetched results controller
    public var delegate: NSFetchedResultsControllerDelegate { return bridgedDelegate }

    
    // MARK: Initialization

    /**
    Constructs a new delegate provider for a fetched results controller.

    - parameter collectionView: The collection view to be updated when the fetched results change.
    - parameter controller:     The fetched results controller whose delegate will be provided by this provider.

    - returns: A new `CollectionViewFetchedResultsDelegateProvider` instance.
    */
    public init(collectionView: UICollectionView, controller: NSFetchedResultsController? = nil) {
        self.collectionView = collectionView

        controller?.delegate = delegate
    }


    // MARK: Private

    private typealias SectionChangeTuple = (changeType: NSFetchedResultsChangeType, sectionIndex: Int)
    private var sectionChanges = [SectionChangeTuple]()

    private typealias ObjectChangeTuple = (changeType: NSFetchedResultsChangeType, indexPaths: [NSIndexPath])
    private var objectChanges = [ObjectChangeTuple]()


    private lazy var bridgedDelegate: BridgedFetchedResultsDelegate = BridgedFetchedResultsDelegate(
        willChangeContent: { [unowned self] (controller) -> Void in
            self.sectionChanges.removeAll()
            self.objectChanges.removeAll()
        },
        didChangeSection: { [unowned self] (controller, sectionInfo, sectionIndex, changeType) -> Void in
            self.sectionChanges.append((changeType, sectionIndex))
        },
        didChangeObject: { [unowned self] (controller, anyObject, indexPath: NSIndexPath?, changeType, newIndexPath: NSIndexPath?) -> Void in
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
                }
            case .Move:
                if let old = indexPath, new = newIndexPath {
                    self.objectChanges.append((changeType, [old, new]))
                }
            }
        },
        didChangeContent: { [unowned self] (controller) -> Void in

            self.collectionView?.performBatchUpdates({ () -> Void in
                self.applyObjectChanges()
                self.applySectionChanges()
                },
                completion:{ (finished) -> Void in

                    if self.sectionChanges.count > 0 {
                        // if sections have changed, reload to update supplementary views
                        self.collectionView?.reloadData()
                    }

                    self.sectionChanges.removeAll()
                    self.objectChanges.removeAll()
            })
        })

    private func applyObjectChanges() {
        for (changeType, indexPaths) in objectChanges {

            switch(changeType) {
            case .Insert: collectionView?.insertItemsAtIndexPaths(indexPaths)
            case .Delete: collectionView?.deleteItemsAtIndexPaths(indexPaths)
            case .Update: collectionView?.reloadItemsAtIndexPaths(indexPaths)
            case .Move:
                if let first = indexPaths.first, last = indexPaths.last {
                    collectionView?.moveItemAtIndexPath(first, toIndexPath: last)
                }
            }
        }
    }

    private func applySectionChanges() {
        for (changeType, sectionIndex) in sectionChanges {
            let section = NSIndexSet(index: sectionIndex)

            switch(changeType) {
            case .Insert: collectionView?.insertSections(section)
            case .Delete: collectionView?.deleteSections(section)
            case .Update: collectionView?.reloadSections(section)
            case .Move: break
            }
        }
    }

}

/**
A `TableViewFetchedResultsDelegateProvider` is responsible for providing a delegate object
for an instance of `NSFetchedResultsController` that manages data to display in a table view.
*/
public final class TableViewFetchedResultsDelegateProvider <
    Item,
    CellFactory: TableViewCellFactoryType
    where CellFactory.Item == Item> {

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

    - parameter tableView:   The table view to be updated when the fetched results change.
    - parameter cellFactory: The cell factory from which the fetched results controller delegate will configure cells.
    - parameter controller:  The fetched results controller whose delegate will be provided by this provider.

    - returns: A new `TableViewFetchedResultsDelegateProvider` instance.
    */
    public init(tableView: UITableView, cellFactory: CellFactory, controller: NSFetchedResultsController? = nil) {
        self.tableView = tableView
        self.cellFactory = cellFactory

        controller?.delegate = delegate
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
                if let i = indexPath,
                    cell = self.tableView?.cellForRowAtIndexPath(i) as? CellFactory.Cell,
                    view = self.tableView {
                        self.cellFactory.configureCell(cell, forItem: anyObject as! Item, inTableView: view, atIndexPath: i)
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
This separate type is required for Objective-C interoperability (interacting with Cocoa).
Because the DelegateProvider is generic it cannot be bridged to Objective-C.
That is, it cannot be assigned to `NSFetchedResultsController.delegate`
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
