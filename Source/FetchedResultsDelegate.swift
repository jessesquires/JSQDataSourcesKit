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


public final class FetchedResultsDelegateProvider<CellFactory: ReusableViewFactoryProtocol> {

    public typealias Item = CellFactory.Item

    public typealias ParentView = CellFactory.View.ParentView

    public weak var cellParentView: ParentView?

    public let cellFactory: CellFactory

    private var bridgedDelegate: BridgedFetchedResultsDelegate?

    private init(cellFactory: CellFactory, cellParentView: ParentView) {
        self.cellFactory = cellFactory
        self.cellParentView = cellParentView
    }


    // MARK: Private, collection view properties

    private typealias SectionChangeTuple = (changeType: NSFetchedResultsChangeType, sectionIndex: Int)
    private lazy var sectionChanges = [SectionChangeTuple]()

    private typealias ObjectChangeTuple = (changeType: NSFetchedResultsChangeType, indexPaths: [NSIndexPath])
    private lazy var objectChanges = [ObjectChangeTuple]()

    private lazy var updatedObjects = [NSIndexPath: Item]()
}


extension FetchedResultsDelegateProvider where CellFactory.View.ParentView == UICollectionView {

    public convenience init(cellFactory: CellFactory, collectionView: UICollectionView) {
        self.init(cellFactory: cellFactory, cellParentView: collectionView)
    }

    public var collectionFetchedDelegate: NSFetchedResultsControllerDelegate {
        if bridgedDelegate == nil {
            bridgedDelegate = bridgedCollectionFetchedResultsDelegate()
        }
        return bridgedDelegate!
    }

    private weak var collectionView: UICollectionView? { return cellParentView }

    private func bridgedCollectionFetchedResultsDelegate() -> BridgedFetchedResultsDelegate {
        let delegate = BridgedFetchedResultsDelegate(
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

        return delegate
    }

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
                    cell = collectionView?.cellForItemAtIndexPath(indexPath) as? CellFactory.View,
                    collectionView = collectionView {
                    cellFactory.configure(view: cell, item: item, type: .cell, parentView: collectionView, indexPath: indexPath)
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


extension FetchedResultsDelegateProvider where CellFactory.View.ParentView == UITableView {

    public convenience init(cellFactory: CellFactory, tableView: UITableView) {
        self.init(cellFactory: cellFactory, cellParentView: tableView)
    }

    public var tableFetchedDelegate: NSFetchedResultsControllerDelegate {
        if bridgedDelegate == nil {
            bridgedDelegate = bridgedTableFetchedResultsDelegate()
        }
        return bridgedDelegate!
    }

    private weak var tableView: UITableView? { return cellParentView }

    private func bridgedTableFetchedResultsDelegate() -> BridgedFetchedResultsDelegate {
        let delegate = BridgedFetchedResultsDelegate(
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
                        cell = self.tableView?.cellForRowAtIndexPath(indexPath) as? CellFactory.View,
                        tableView = self.tableView {
                        self.cellFactory.configure(view: cell, item: anyObject as? Item, type: .cell, parentView: tableView, indexPath: indexPath)
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

        return delegate
    }
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
