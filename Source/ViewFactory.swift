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

    // MARK: Associated types

    /// The type of cell for this parent view.
    associatedtype CellType: UIView


    // MARK: Methods

    /**
     Returns a reusable cell located by its identifier.

     - parameter identifier: The reuse identifier for the specified cell.
     - parameter indexPath:  The index path specifying the location of the cell.

     - returns: A valid `CellType` reusable cell.
     */
    func dequeueReusableCellFor(identifier: String, indexPath: IndexPath) -> CellType

    /**
     Returns a reusable supplementary view located by its identifier and kind.

     - parameter kind:       The kind of supplementary view to retrieve.
     - parameter identifier: The reuse identifier for the specified view.
     - parameter indexPath:  The index path specifying the location of the supplementary view in the collection view.

     - returns: A valid `CellType` reusable view.
     */
    func dequeueReusableSupplementaryViewFor(kind: String, identifier: String, indexPath: IndexPath) -> CellType?
}

extension UICollectionView: CellParentViewProtocol {
    /// :nodoc:
    public typealias CellType = UICollectionReusableView

    /// :nodoc:
    public func dequeueReusableCellFor(identifier: String, indexPath: IndexPath) -> CellType {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

    /// :nodoc:
    public func dequeueReusableSupplementaryViewFor(kind: String, identifier: String, indexPath: IndexPath) -> CellType? {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
    }
}

extension UITableView: CellParentViewProtocol {
    /// :nodoc:
    public typealias CellType = UITableViewCell

    /// :nodoc:
    public func dequeueReusableCellFor(identifier: String, indexPath: IndexPath) -> CellType {
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }

    /// :nodoc:
    public func dequeueReusableSupplementaryViewFor(kind: String, identifier: String, indexPath: IndexPath) -> CellType? {
        return nil
    }
}



// MARK: ReusableViewProtocol

/**
 This protocol unifies `UICollectionViewCell`, `UICollectionReusableView`, and `UITableViewCell` by providing a common interface for cells.
 */
public protocol ReusableViewProtocol {

    // MARK: Associated types

    /**
     The "parent" view of the cell.
     For `UICollectionViewCell` or `UICollectionReusableView` this is `UICollectionView`.
     For `UITableViewCell` this is `UITableView`.
     */
    associatedtype ParentView: UIView, CellParentViewProtocol


    // MARK: Properties

    /// A string that identifies the purpose of the view.
    var reuseIdentifier: String? { get }


    // MARK: Methods

    /// Performs any clean up necessary to prepare the view for use again.
    func prepareForReuse()
}

extension UICollectionReusableView: ReusableViewProtocol {
    /// :nodoc:
    public typealias ParentView = UICollectionView
}

extension UITableViewCell: ReusableViewProtocol {
    /// :nodoc:
    public typealias ParentView = UITableView
}

/**
 Specifies the type of reusable view.
 */
public enum ReusableViewType {

    /// A collection or table view cell.
    case cell

    /// A supplementary view and its associated kind identifer.
    case supplementaryView(kind: String)
}


extension ReusableViewType: Equatable { }

/// :nodoc:
public func ==(lhs: ReusableViewType, rhs: ReusableViewType) -> Bool {
    switch (lhs, rhs) {
    case (.cell, .cell):
        return true
    case (.supplementaryView(let kind1), .supplementaryView(let kind2)):
        return kind1 == kind2
    default:
        return false
    }
}



// MARK: ReusableViewFactory

/**
 An instance conforming to `ReusableViewFactoryProtocol` is responsible for initializing
 and configuring reusable views to be displayed in either a `UICollectionView` or a `UITableView`.
 */
public protocol ReusableViewFactoryProtocol {

    // MARK: Associated types

    /// The type of elements backing the collection view or table view.
    associatedtype Item

    /// The type of views that the factory produces.
    associatedtype View: ReusableViewProtocol


    // MARK: Methods

    /**
     Provides a view reuse identifer for the given item, type, and indexPath.

     - parameter item:      The item at `indexPath`.
     - parameter type:      The type of reusable view.
     - parameter indexPath: The index path that specifies the location of the view.

     - returns: An identifier for a reusable view.
     */
    func reuseIdentiferFor(item: Item?, type: ReusableViewType, indexPath: IndexPath) -> String

    /**
     Configures and returns the specified view.

     - parameter view:       The view to configure.
     - parameter item:       The item at `indexPath`.
     - parameter type:       The type of reusable view.
     - parameter parentView: The collection view or table view requesting this information.
     - parameter indexPath:  The index path that specifies the location of `view` and `item`.

     - returns: A configured view of type `View`.
     */
    @discardableResult
    func configure(view: View, item: Item?, type: ReusableViewType, parentView: View.ParentView, indexPath: IndexPath) -> View
}


public extension ReusableViewFactoryProtocol where View: UITableViewCell {

    // MARK: Table cells

    /**
     Creates a new `View` instance, or dequeues an existing cell for reuse, then configures and returns it.

     - parameter item:       The item at `indexPath`.
     - parameter tableView: The table view requesting this information.
     - parameter indexPath:  The index path that specifies the location of the cell and item.

     - returns: An initialized or dequeued, and fully configured table cell.
     */
    public func tableCellFor(item: Item, tableView: UITableView, indexPath: IndexPath) -> View {
        let reuseIdentifier = reuseIdentiferFor(item: item, type: .cell, indexPath: indexPath)
        let cell = tableView.dequeueReusableCellFor(identifier: reuseIdentifier, indexPath: indexPath) as! View
        return configure(view: cell, item: item, type: .cell, parentView: tableView, indexPath: indexPath)
    }
}


public extension ReusableViewFactoryProtocol where View: UICollectionViewCell {

    // MARK: Collection cells

    /**
     Creates a new `View` instance, or dequeues an existing cell for reuse, then configures and returns it.

     - parameter item:           The item at `indexPath`.
     - parameter collectionView: The collection view requesting this information.
     - parameter indexPath:      The index path that specifies the location of the cell and item.

     - returns: An initialized or dequeued, and fully configured collection cell.
     */
    public func collectionCellFor(item: Item, collectionView: UICollectionView, indexPath: IndexPath) -> View {
        let reuseIdentifier = reuseIdentiferFor(item: item, type: .cell, indexPath: indexPath)
        let cell = collectionView.dequeueReusableCellFor(identifier: reuseIdentifier, indexPath: indexPath) as! View
        return configure(view: cell, item: item, type: .cell, parentView: collectionView, indexPath: indexPath)
    }
}


public extension ReusableViewFactoryProtocol where View: UICollectionReusableView {

    // MARK: Supplementary views

    /**
     Creates a new `View` instance, or dequeues an existing view for reuse, then configures and returns it.

     - parameter item:           The item at `indexPath`.
     - parameter kind:           The kind of supplementary view to retrieve.
     - parameter collectionView: The collection view requesting this information.
     - parameter indexPath:      The index path that specifies the location of the view and item.

     - returns: An initialized or dequeued, and fully configured supplementary view.
     */
    public func supplementaryViewFor(item: Item?, kind: String, collectionView: UICollectionView, indexPath: IndexPath) -> View {
        let reuseIdentifier = reuseIdentiferFor(item: item, type: .supplementaryView(kind: kind), indexPath: indexPath)
        let view = collectionView.dequeueReusableSupplementaryViewFor(kind: kind, identifier: reuseIdentifier, indexPath: indexPath) as! View
        return configure(view: view, item: item, type: .supplementaryView(kind: kind), parentView: collectionView, indexPath: indexPath)
    }
}


/**
 A `ViewFactory` is a concrete `ReusableViewFactoryProtocol` type.
 This factory is responsible for producing and configuring reusable views for a specific item.
 Cells can be for either collection views or table views.
 */
public struct ViewFactory<Item, Cell: ReusableViewProtocol>: ReusableViewFactoryProtocol  {

    // MARK: Type aliases

    /**
     Configures the cell for the specified item, parent view, and index path.

     - parameter cell:       The cell to be configured at the index path.
     - parameter item:       The item at `indexPath`.
     - parameter type:       The type of reusable view.
     - parameter parentView: The collection view or table view requesting this information.
     - parameter indexPath:  The index path at which the cell will be displayed.

     - returns: The configured cell.
     */
    public typealias ViewConfigurator = (_ cell: Cell, _ item: Item?, _ type: ReusableViewType, _ parentView: Cell.ParentView, _ indexPath: IndexPath) -> Cell


    // MARK: Properties

    /**
     A unique identifier that describes the purpose of the cells that the factory produces.
     The factory dequeues cells from the collection view or table view with this reuse identifier.

     - note: Clients are responsible for registering a cell for this identifier with the collection view or table view.
     */
    public let reuseIdentifier: String

    /// The type of the reusable view.
    public let type: ReusableViewType

    /// A closure used to configure the views.
    public let viewConfigurator: ViewConfigurator


    // MARK: Initialization

    /**
     Constructs a new cell factory.

     - parameter reuseIdentifier:  The reuse identifier with which the factory will dequeue cells.
     - parameter type:             The type of the reusable view.
     - parameter viewConfigurator: The closure with which the factory will configure cells.

     - returns: A new `CellFactory` instance.
     */
    public init(reuseIdentifier: String, type: ReusableViewType = .cell, viewConfigurator: @escaping ViewConfigurator) {
        self.reuseIdentifier = reuseIdentifier
        self.type = type
        self.viewConfigurator = viewConfigurator
    }

    /// :nodoc:
    public func reuseIdentiferFor(item: Item?, type: ReusableViewType, indexPath: IndexPath) -> String {
        return reuseIdentifier
    }

    /// :nodoc:
    public func configure(view: Cell, item: Item?, type: ReusableViewType, parentView: Cell.ParentView, indexPath: IndexPath) -> Cell {
        assert(self.type == type)
        return viewConfigurator(view, item, type, parentView, indexPath)
    }
}
