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


public class CollectionViewFetchedResultsDelegateProvider <DataItem> {

    typealias SectionIndex = Int
    typealias SectionChangesDictionary = [NSFetchedResultsChangeType : SectionIndex]

    typealias ObjectIndexPaths = [NSIndexPath]
    typealias ObjectChangesDictionary = [NSFetchedResultsChangeType : ObjectIndexPaths]

    public weak var collectionView: UICollectionView?

    public var delegate: NSFetchedResultsControllerDelegate { return bridgedDelegate }

    public init(collectionView: UICollectionView, controller: NSFetchedResultsController? = nil) {
        self.collectionView = collectionView

        controller?.delegate = self.delegate
    }

    private var sectionChanges = [SectionChangesDictionary]()
    
    private var objectChanges = [ObjectChangesDictionary]()

    private lazy var bridgedDelegate: BridgedFetchedResultsDelegate = BridgedFetchedResultsDelegate(
        willChangeContent: { [unowned self] (controller) -> Void in
            self.sectionChanges.removeAll(keepCapacity: false)
            self.objectChanges.removeAll(keepCapacity: false)
        },
        didChangeSection: { [unowned self] (controller, sectionInfo, sectionIndex, changeType) -> Void in
            println("*** did change section type:\(changeType.rawValue), index:\(sectionIndex)")

            let changes: SectionChangesDictionary = [changeType : sectionIndex]
            self.sectionChanges.append(changes)
        },
        didChangeObject: { [unowned self] (controller, anyObject, indexPath: NSIndexPath?, changeType, newIndexPath: NSIndexPath?) -> Void in
            println("*** did change object: old = \(indexPath), new = \(newIndexPath)")

            var changes = ObjectChangesDictionary()

            switch changeType {
            case .Insert:
                if let insertIndexPath = newIndexPath {
                    changes[changeType] = [insertIndexPath]
                }
            case .Delete:
                if let deleteIndexPath = indexPath {
                    changes[changeType] = [deleteIndexPath]
                }
            case .Update:
                if let i = indexPath {
                    changes[changeType] = [i]
                }
            case .Move:
                if let old = indexPath, new = newIndexPath {
                    changes[changeType] = [old, new]
                }
            }
            
            self.objectChanges.append(changes)
        },
        didChangeContent: { [unowned self] (controller) -> Void in
            println("*** did change content")

            self.collectionView?.performBatchUpdates({ () -> Void in

                // println("first object changes....")
                // FIXES edge case: delete 1 item from each section, where 1 section has 1 item, thus that section is deleted
                // however, afterwards this breaks

                // TODO: add a check to see if object changes should be applied first
                // self.applyObjectChanges()

                println("applying section changes...")
                self.applySectionChanges()

                if self.objectChanges.count > 0 && self.sectionChanges.count == 0 {

                    println("checking should reload? ...")
                    if self.reloadForKnownIssue() || self.collectionView?.window == nil {
                        println("reload!")
                        self.collectionView?.reloadData()
                    }
                    else {
                        println("applying object changes...")
                        self.applyObjectChanges()
                    }
                }

                }, completion:{ (finished) -> Void in
                    println("ALL changes complete!")
                    self.sectionChanges.removeAll(keepCapacity: false)
                    self.objectChanges.removeAll(keepCapacity: false)
            })
        }
    )

    private func reloadForKnownIssue() -> Bool {

        var shouldReload: Bool = false

        for eachChange in self.objectChanges {
            for (changeType: NSFetchedResultsChangeType, indexes: [NSIndexPath]) in eachChange {

                switch(changeType) {
                case .Insert:
                    if let indexPath = indexes.first {
                        if self.collectionView?.numberOfItemsInSection(indexPath.section) == 0 {
                            shouldReload = true
                        }
                        else {
                            shouldReload = false
                        }
                    }

                case .Delete:
                    if let indexPath = indexes.first {
                        if self.collectionView?.numberOfItemsInSection(indexPath.section) == 1 {
                            shouldReload = true
                        }
                        else {
                            shouldReload = false
                        }
                    }

                case .Update:
                    shouldReload = false
                case .Move:
                    shouldReload = false
                }
            }
        }

        return shouldReload
    }

    private func applySectionChanges() {
        for eachChange in self.sectionChanges {
            for (changeType: NSFetchedResultsChangeType, index: SectionIndex) in eachChange {

                let section = NSIndexSet(index: index)

                switch(changeType) {
                case .Insert: self.collectionView?.insertSections(section)
                case .Delete: self.collectionView?.deleteSections(section)
                case .Update: self.collectionView?.reloadSections(section)
                case .Move: break
                }
            }
        }
    }

    private func applyObjectChanges() {
        for eachChange in self.objectChanges {
            for (changeType: NSFetchedResultsChangeType, indexes: [NSIndexPath]) in eachChange {

                switch(changeType) {
                case .Insert: self.collectionView?.insertItemsAtIndexPaths(indexes)
                case .Delete: self.collectionView?.deleteItemsAtIndexPaths(indexes)
                case .Update: self.collectionView?.reloadItemsAtIndexPaths(indexes)
                case .Move:
                    if let first = indexes.first, last = indexes.last {
                        self.collectionView?.moveItemAtIndexPath(first, toIndexPath: last)
                    }
                }
            }
        }
    }

}


public class TableViewFetchedResultsDelegateProvider <DataItem, CellFactory: TableViewCellFactoryType
                                                      where CellFactory.DataItem == DataItem> {

    public weak var tableView: UITableView?

    public let cellFactory: CellFactory

    public var delegate: NSFetchedResultsControllerDelegate { return bridgedDelegate }

    public init(tableView: UITableView, cellFactory: CellFactory, controller: NSFetchedResultsController? = nil) {
        self.tableView = tableView
        self.cellFactory = cellFactory

        controller?.delegate = self.delegate
    }

    private lazy var bridgedDelegate: BridgedFetchedResultsDelegate = BridgedFetchedResultsDelegate(
        willChangeContent: { [unowned self] (controller) -> Void in
            self.tableView?.beginUpdates()
            return // Swift compiler bug: single statement void closure
        },
        didChangeSection: { [unowned self] (controller, sectionInfo, sectionIndex, changeType) -> Void in
            switch changeType {
            case .Insert:
                self.tableView?.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            case .Delete:
                self.tableView?.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            default:
                break
            }
        },
        didChangeObject: { [unowned self] (controller, anyObject, indexPath, changeType, newIndexPath) -> Void in
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
                if let i = indexPath, cell = self.tableView?.cellForRowAtIndexPath(i) as? CellFactory.Cell, view = self.tableView {
                    self.cellFactory.configureCell(cell, forItem: anyObject as! DataItem, inTableView: view, atIndexPath: i)
                }
                break
            case .Move:
                if let deleteIndexPath = indexPath {
                    self.tableView?.deleteRowsAtIndexPaths([deleteIndexPath], withRowAnimation: .Fade)
                }

                if let insertIndexPath = newIndexPath {
                    self.tableView?.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: .Fade)
                }
            }
        },
        didChangeContent: { [unowned self] (controller) -> Void in
            self.tableView?.endUpdates()
            return // Swift compiler bug: single statement void closure
        }
    )

}


@objc private class BridgedFetchedResultsDelegate: NSFetchedResultsControllerDelegate {

    typealias WillChangeContentHandler = (NSFetchedResultsController) -> Void
    typealias DidChangeSectionHandler = (NSFetchedResultsController, NSFetchedResultsSectionInfo, Int, NSFetchedResultsChangeType) -> Void
    typealias DidChangeObjectHandler = (NSFetchedResultsController, AnyObject, NSIndexPath?, NSFetchedResultsChangeType, NSIndexPath?) -> Void
    typealias DidChangeContentHandler = (NSFetchedResultsController) -> Void

    private let willChangeContent: WillChangeContentHandler
    private let didChangeSection: DidChangeSectionHandler
    private let didChangeObject: DidChangeObjectHandler
    private let didChangeContent: DidChangeContentHandler

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

    @objc func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        didChangeSection(controller, sectionInfo, sectionIndex, type)
    }

    @objc func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        didChangeObject(controller, anObject, indexPath, type, newIndexPath)
    }

    @objc func controllerDidChangeContent(controller: NSFetchedResultsController) {
        didChangeContent(controller)
    }

}
