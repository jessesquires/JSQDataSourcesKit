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

import UIKit


/**
 A `CollectionViewCellFactory` is a concrete `CollectionViewCellFactoryType`.
 This factory is responsible for producing and configuring collection view cells for a specific item.
 */
public struct CollectionViewCellFactory <Cell: UICollectionViewCell, Item>: CollectionViewCellFactoryType, CustomStringConvertible {

    // MARK: Typealiases

    /**
    Configures the cell for the specified data item, collection view and index path.

    - parameter Cell:             The cell to be configured at the index path.
    - parameter Item:             The item at the index path.
    - parameter UICollectionView: The collection view requesting this information.
    - parameter NSIndexPath:      The index path at which the cell will be displayed.

    - returns: The configured cell.
    */
    public typealias ConfigurationHandler = (Cell, Item, UICollectionView, NSIndexPath) -> Cell


    // MARK: Properties

    /**
    A unique identifier that describes the purpose of the cells that the factory produces.
    The factory dequeues cells from the collection view with this reuse identifier.

    - note: Clients are responsible for registering a cell for this identifier with the collection view.
    */
    public let reuseIdentifier: String

    private let cellConfigurator: ConfigurationHandler


    // MARK: Initialization

    /**
    Constructs a new collection view cell factory.

    - parameter reuseIdentifier:  The reuse identifier with which the factory will dequeue cells.
    - parameter cellConfigurator: The closure with which the factory will configure cells.

    - returns: A new `CollectionViewCellFactory` instance.
    */
    public init(reuseIdentifier: String, cellConfigurator: ConfigurationHandler) {
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }


    // MARK: CollectionViewCellFactoryType

    /// :nodoc:
    public func cellForItem(
        item: Item,
        inCollectionView collectionView: UICollectionView,
        atIndexPath indexPath: NSIndexPath) -> Cell {
            return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! Cell
    }

    /// :nodoc:
    public func configureCell(
        cell: Cell,
        forItem item: Item,
        inCollectionView collectionView: UICollectionView,
        atIndexPath indexPath: NSIndexPath) -> Cell {
            return cellConfigurator(cell, item, collectionView, indexPath)
    }


    // MARK: CustomStringConvertible

    /// :nodoc:
    public var description: String {
        get {
            return "<\(CollectionViewCellFactory.self): \(reuseIdentifier)>"
        }
    }
}
