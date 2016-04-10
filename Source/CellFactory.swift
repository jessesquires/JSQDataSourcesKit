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
    /// :nodoc:
    public typealias CellType = UICollectionViewCell

    /// :nodoc:
    public func dequeueReusableCellFor(identifier identifier: String, indexPath: NSIndexPath) -> CellType {
        return dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
    }
}


extension UITableView: CellParentViewProtocol {
    /// :nodoc:
    public typealias CellType = UITableViewCell

    /// :nodoc:
    public func dequeueReusableCellFor(identifier identifier: String, indexPath: NSIndexPath) -> CellType {
        return dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
    }
}




public protocol ReusableViewProtocol {
    associatedtype ParentView: UIView, CellParentViewProtocol

    var reuseIdentifier: String? { get }

    func prepareForReuse()
}

extension UICollectionReusableView: ReusableViewProtocol {
    public typealias ParentView = UICollectionView
}

extension UITableViewCell: ReusableViewProtocol {
    public typealias ParentView = UITableView
}




public protocol CellFactoryProtocol {

    associatedtype Item
    associatedtype Cell: ReusableViewProtocol

    func reuseIdentiferFor(item item: Item, indexPath: NSIndexPath) -> String

    func configure(cell cell: Cell, item: Item, parentView: Cell.ParentView, indexPath: NSIndexPath) -> Cell
}

extension CellFactoryProtocol {

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

    public func reuseIdentiferFor(item item: Item, indexPath: NSIndexPath) -> String {
        return reuseIdentifier
    }

    public func configure(cell cell: Cell, item: Item, parentView: Cell.ParentView, indexPath: NSIndexPath) -> Cell {
        return cellConfigurator(cell: cell, item: item, parentView: parentView, indexPath: indexPath)
    }
}
