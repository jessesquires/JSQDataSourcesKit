//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//
//  Documentation
//  https://jessesquires.github.io/JSQDataSourcesKit
//
//
//  GitHub
//  https://github.com/jessesquires/JSQDataSourcesKit
//
//
//  License
//  Copyright © 2015-present Jesse Squires
//  Released under an MIT license: https://opensource.org/licenses/MIT
//

import CoreData
import Foundation
import UIKit

/// A `FetchedResultsDelegateProvider` is responsible for providing a delegate object for an instance of `NSFetchedResultsController`.
public final class FetchedResultsDelegateProvider<CellConfig: ReusableViewConfigProtocol> {

    // MARK: Type aliases

    /// The parent view of cell's that the cell configuration produces.
    public typealias ParentView = CellConfig.View.ParentView

    // MARK: Properties

    /// The table view or collection view displaying data for the fetched results controller.
    public weak var cellParentView: ParentView?

    /// The cell configuration.
    public let cellConfig: CellConfig

    // MARK: Private

    private typealias Item = CellConfig.Item

    private var bridgedDelegate: BridgedFetchedResultsDelegate?

    private init(cellConfig: CellConfig, cellParentView: ParentView) {
        self.cellConfig = cellConfig
        self.cellParentView = cellParentView
    }

    // MARK: Private, collection view properties

    private lazy var sectionChanges = [() -> Void]()
    private lazy var objectChanges = [() -> Void]()
}

extension FetchedResultsDelegateProvider where CellConfig.View.ParentView == UICollectionView {

    // MARK: Collection views

    /// Initializes a new fetched results delegate provider for collection views.
    ///
    /// - Parameters:
    ///   - cellConfig: The cell configuration with which the fetched results controller delegate will configure cells.
    ///   - collectionView: The collection view to be updated when the fetched results change.
    public convenience init(cellConfig: CellConfig, collectionView: UICollectionView) {
        self.init(cellConfig: cellConfig, cellParentView: collectionView)
    }

    /// Returns the `NSFetchedResultsControllerDelegate` object for a collection view.
    public var collectionDelegate: NSFetchedResultsControllerDelegate {
        if bridgedDelegate == nil {
            bridgedDelegate = bridgedCollectionFetchedResultsDelegate()
        }
        return bridgedDelegate!
    }

    private var collectionView: UICollectionView? { return cellParentView }

    private func bridgedCollectionFetchedResultsDelegate() -> BridgedFetchedResultsDelegate {
        let delegate = BridgedFetchedResultsDelegate(
            willChangeContent: { [unowned self] _ in

                self.sectionChanges.removeAll()
                self.objectChanges.removeAll()
            },
            didChangeSection: { [unowned self] _, _, sectionIndex, changeType in

                let section = IndexSet(integer: sectionIndex)
                self.sectionChanges.append { [unowned self] in
                    switch changeType {
                    case .insert:
                        self.collectionView?.insertSections(section)

                    case .delete:
                        self.collectionView?.deleteSections(section)

                    default:
                        break
                    }
                }
            },
            didChangeObject: { [unowned self] (_, anyObject, indexPath: IndexPath?, changeType, newIndexPath: IndexPath?) in

                switch changeType {
                case .insert:
                    if let insertIndexPath = newIndexPath {
                        self.objectChanges.append { [unowned self] in
                            self.collectionView?.insertItems(at: [insertIndexPath])
                        }
                    }

                case .delete:
                    if let deleteIndexPath = indexPath {
                        self.objectChanges.append { [unowned self] in
                            self.collectionView?.deleteItems(at: [deleteIndexPath])
                        }
                    }

                case .update:
                    if let indexPath = indexPath {
                        self.objectChanges.append { [unowned self] in
                            if let item = anyObject as? Item,
                                let collectionView = self.collectionView,
                                let cell = collectionView.cellForItem(at: indexPath) as? CellConfig.View {
                                self.cellConfig.configure(view: cell, item: item, type: .cell, parentView: collectionView, indexPath: indexPath)
                            }
                        }
                    }

                case .move:
                    if let old = indexPath, let new = newIndexPath {
                        self.objectChanges.append { [unowned self] in
                            self.collectionView?.deleteItems(at: [old])
                            self.collectionView?.insertItems(at: [new])
                        }
                    }
                }
            },
            didChangeContent: { [unowned self] _ in

                self.collectionView?.performBatchUpdates({ [weak self] in
                    // apply object changes
                    self?.objectChanges.forEach { $0() }

                    // apply section changes
                    self?.sectionChanges.forEach { $0() }

                    }, completion: { [weak self] _ in
                        self?.reloadSupplementaryViewsIfNeeded()
                })
        })

        return delegate
    }

    private func reloadSupplementaryViewsIfNeeded() {
        if !sectionChanges.isEmpty {
            collectionView?.reloadData()
        }
    }
}

extension FetchedResultsDelegateProvider where CellConfig.View.ParentView == UITableView {

    // MARK: Table views

    /// Initializes a new fetched results delegate provider for table views.
    ///
    /// - Parameters:
    ///   - cellConfig: The cell configuration with which the fetched results controller delegate will configure cells.
    ///   - tableView: The table view to be updated when the fetched results change.
    public convenience init(cellConfig: CellConfig, tableView: UITableView) {
        self.init(cellConfig: cellConfig, cellParentView: tableView)
    }

    /// Returns the `NSFetchedResultsControllerDelegate` object for a table view.
    public var tableDelegate: NSFetchedResultsControllerDelegate {
        if bridgedDelegate == nil {
            bridgedDelegate = bridgedTableFetchedResultsDelegate()
        }
        return bridgedDelegate!
    }

    private var tableView: UITableView? { return cellParentView }

    private func bridgedTableFetchedResultsDelegate() -> BridgedFetchedResultsDelegate {
        let delegate = BridgedFetchedResultsDelegate(
            willChangeContent: { [unowned self] _ in
                self.tableView?.beginUpdates()
            },
            didChangeSection: { [unowned self] _, _, sectionIndex, changeType in
                switch changeType {
                case .insert:
                    self.tableView?.insertSections(IndexSet(integer: sectionIndex), with: .fade)

                case .delete:
                    self.tableView?.deleteSections(IndexSet(integer: sectionIndex), with: .fade)

                default:
                    break
                }
            },
            didChangeObject: { [unowned self] _, anyObject, indexPath, changeType, newIndexPath in
                switch changeType {
                case .insert:
                    if let insertIndexPath = newIndexPath {
                        self.tableView?.insertRows(at: [insertIndexPath], with: .fade)
                    }

                case .delete:
                    if let deleteIndexPath = indexPath {
                        self.tableView?.deleteRows(at: [deleteIndexPath], with: .fade)
                    }

                case .update:
                    if let indexPath = indexPath,
                        let tableView = self.tableView,
                        let cell = tableView.cellForRow(at: indexPath) as? CellConfig.View {
                        self.cellConfig.configure(view: cell, item: anyObject as? Item, type: .cell, parentView: tableView, indexPath: indexPath)
                    }

                case .move:
                    if let deleteIndexPath = indexPath {
                        self.tableView?.deleteRows(at: [deleteIndexPath], with: .fade)
                    }

                    if let insertIndexPath = newIndexPath {
                        self.tableView?.insertRows(at: [insertIndexPath], with: .fade)
                    }
                }
            },
            didChangeContent: { [unowned self] _ in
                self.tableView?.endUpdates()
        })

        return delegate
    }
}
