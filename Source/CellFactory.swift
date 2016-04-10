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

import Foundation
import UIKit


// MARK: CellParentViewProtocol

/**
 This protocol unifies `UICollectionView` and `UITableView` by providing a common dequeue method for cells.
 It describes a view that is the "parent" view for a cell.
 For `UICollectionViewCell`, this would be `UICollectionView`.
 For `UITableViewCell`, this would be `UITableView`.
 */
public protocol CellParentViewProtocol {
    /// The type of cell for this parent view.
    associatedtype CellType: UIView

    /**
     Returns a reusable cell object located by its identifier.

     - parameter identifier: The reuse identifier for the specified cell.
     - parameter indexPath:  The index path specifying the location of the cell.

     - returns: A valid `CellType` reusable view.
     */
    func dequeueReusableCellFor(identifier identifier: String, indexPath: NSIndexPath) -> CellType
}

extension UICollectionView: CellParentViewProtocol {
    public typealias CellType = UICollectionViewCell

    public func dequeueReusableCellFor(identifier identifier: String, indexPath: NSIndexPath) -> CellType {
        return dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
    }
}

extension UITableView: CellParentViewProtocol {
    public typealias CellType = UITableViewCell

    public func dequeueReusableCellFor(identifier identifier: String, indexPath: NSIndexPath) -> CellType {
        return dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
    }
}



// MARK: ReusableViewProtocol

/**
 This protocol unifies `UICollectionViewCell` and `UITableViewCell` by providing a common interface for cells.
 */
public protocol ReusableViewProtocol {

    /**
     The "parent" view of the cell. 
     For `UICollectionViewCell` this is `UICollectionView`. For `UITableViewCell` this is `UITableView`.
     */
    associatedtype ParentView: UIView, CellParentViewProtocol

    /// A string that identifies the purpose of the view.
    var reuseIdentifier: String? { get }

    /// Performs any clean up necessary to prepare the view for use again.
    func prepareForReuse()
}

extension UICollectionReusableView: ReusableViewProtocol {
    public typealias ParentView = UICollectionView
}

extension UITableViewCell: ReusableViewProtocol {
    public typealias ParentView = UITableView
}



// MARK: CellFactoryProtocol

/**
 An instance conforming to `CellFactoryProtocol` is responsible for initializing
 and configuring reusable cells to be displayed in either a `UICollectionView` or a `UITableView`.
 */
public protocol CellFactoryProtocol {

    /// The type of elements backing the collection view or table view.
    associatedtype Item

    /// The type of cells that the factory produces
    associatedtype Cell: ReusableViewProtocol

    /**
     Provides a cell reuse identifer for the given item and indexPath.

     - parameter item:      The item at `indexPath`.
     - parameter indexPath: The index path that specifies the location of the cell.

     - returns: An identifier for a reusable cell.
     */
    func reuseIdentiferFor(item item: Item, indexPath: NSIndexPath) -> String

    /**
     Configures and returns the specified cell.

     - parameter cell:       The cell to configure.
     - parameter item:       The item at `indexPath`.
     - parameter parentView: The collection view or table view requesting this information.
     - parameter indexPath:  The index path that specifies the location of `cell` and `item`.

     - returns: A configured cell of type `Cell`.
     */
    func configure(cell cell: Cell, item: Item, parentView: Cell.ParentView, indexPath: NSIndexPath) -> Cell
}

public extension CellFactoryProtocol {

    /**
     Creates a new `Cell` instance, or dequeues an existing cell for reuse, then configures and returns it.

     - parameter item:       The item at `indexPath`.
     - parameter parentView: The collection view or table view requesting this information.
     - parameter indexPath:  The index path that specifies the location of `cell` and `item`.

     - returns: An initialized or dequeued, and fully configured cell of type `Cell`.
     */
    public func cellFor(item item: Item, parentView: Cell.ParentView, indexPath: NSIndexPath) -> Cell {
        let reuseIdentifier = reuseIdentiferFor(item: item, indexPath: indexPath)
        let cell = parentView.dequeueReusableCellFor(identifier: reuseIdentifier, indexPath: indexPath) as! Cell
        return configure(cell: cell, item: item, parentView: parentView, indexPath: indexPath)
    }
}


public struct CellFactory<Item, Cell: ReusableViewProtocol>: CellFactoryProtocol  {

    public typealias CellConfigurator = (cell: Cell, item: Item, parentView: Cell.ParentView, indexPath: NSIndexPath) -> Cell

    public let reuseIdentifier: String
    public let cellConfigurator: CellConfigurator

    public init(reuseIdentifier: String, cellConfigurator: CellConfigurator) {
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }

    /// :nodoc:
    public func reuseIdentiferFor(item item: Item, indexPath: NSIndexPath) -> String {
        return reuseIdentifier
    }

    /// :nodoc:
    public func configure(cell cell: Cell, item: Item, parentView: Cell.ParentView, indexPath: NSIndexPath) -> Cell {
        return cellConfigurator(cell: cell, item: item, parentView: parentView, indexPath: indexPath)
    }
}
