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


//public class CollectionViewFetchedResultsDelegate <DataItem, CellFactory: CollecitonViewCellFactoryType
//                                                    where
//                                                    CellFactory.DataItem == DataItem>: NSFetchedResultsControllerDelegate {
//
//    typealias SectionIndex = Int
//    typealias SectionChangesDictionary = [NSFetchedResultsChangeType : SectionIndex]
//    typealias ObjectChangesDictionary = [NSFetchedResultsChangeType : [NSIndexPath]]
//
//    public weak var collectionView: UICollectionView?
//
//    public let cellFactory: CellFactory
//
//    private var sectionChanges = [SectionChangesDictionary]()
//
//    private var objectChanges = [ObjectChangesDictionary]()
//
//    public init(collectionView: UICollectionView, cellFactory: CellFactory) {
//        self.tableView = tableView
//        self.cellFactory = cellFactory
//    }
//
//    // MARK: fetched results controller delegate
//
//    public func controllerWillChangeContent(controller: NSFetchedResultsController) {
//        sectionChanges.removeAll(keepCapacity: false)
//        objectChanges.removeAll(keepCapacity: false)
//    }
//
//    public func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
//        let changes: SectionChangesDictionary = [type : sectionIndex]
//        sectionChanges.append(changes)
//    }
//
//    public func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
//        var changes = ObjectChangesDictionary()
//
//        switch type {
//        case .Insert:
//            if let i = newIndexPath {
//                changes[type] = [i]
//            }
//        case .Delete:
//            fallthrough
//        case .Update:
//            if let i = indexPath {
//                changes[type] = [i]
//            }
//        case .Move:
//            if let old = indexPath, new = newIndexPath {
//                changes[type] = [old, new]
//            }
//        }
//
//        objectChanges.append(changes)
//    }
//
//    public func controllerDidChangeContent(controller: NSFetchedResultsController) {
//
//        if sectionChanges.count > 0 {
//            self.collectionView?.performBatchUpdates({ () -> Void in
//
//                for eachChange in self.sectionChanges {
//                    for (changeType: NSFetchedResultsChangeType, index: SectionIndex) in eachChange {
//
//                        let sections = NSIndexSet(index: index)
//
//                        switch(changeType) {
//                        case .Insert:
//                            self.collectionView?.insertSections(sections)
//                        case .Delete:
//                            self.collectionView?.deleteSections(sections)
//                        case .Update:
//                            self.collectionView?.reloadSections(sections)
//                        case .Move:
//                            break
//                        }
//                    }
//                }
//                },
//                completion:{ (finished) -> Void in
//                    self.sectionChanges.removeAll(keepCapacity: false)
//                }
//            )
//
//        }
//
//        if objectChanges.count > 0 {
//            self.collectionView?.performBatchUpdates({ () -> Void in
//
//                for eachChange in self.objectChanges {
//                    for (changeType: NSFetchedResultsChangeType, indexes: [NSIndexPath]) in eachChange {
//
//                        switch(changeType) {
//                        case .Insert:
//                            self.collectionView?.insertItemsAtIndexPaths([indexes.first!])
//                        case .Delete:
//                            self.collectionView?.deleteItemsAtIndexPaths([indexes.first!])
//                        case .Update:
//                            self.collectionView?.reloadItemsAtIndexPaths([indexes.first!])
//                        case .Move:
//                            self.collectionView?.moveItemAtIndexPath(indexes.first!, toIndexPath: indexes.last!)
//                        }
//
//                    }
//                }
//                },
//                completion:{ (finished) -> Void in
//                    self.objectChanges.removeAll(keepCapacity: false)
//                }
//            )
//
//        }
//    }
//
//}
