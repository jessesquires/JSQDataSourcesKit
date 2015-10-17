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
public struct CollectionViewCellFactory <Cell: UICollectionViewCell, Item>: CollectionViewCellFactoryType {

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

    - Note: Clients are responsible for registering a cell for this identifier with the collection view.
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

    // MARK: Methods

    /**
    Creates and returns a new `Cell` instance, or dequeues an existing cell for reuse.

    - parameter item:           The item at `indexPath`.
    - parameter collectionView: The collection view requesting this information.
    - parameter indexPath:      The index path that specifies the location of `cell` and `item`.

    - returns: An initialized or dequeued `UICollectionViewCell` of type `Cell`.
    */
    public func cellForItem(item: Item, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> Cell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! Cell
    }

    /**
    Configures and returns the specified cell.

    - parameter cell:           The cell to configure.
    - parameter item:           The item at `indexPath`.
    - parameter collectionView: The collection view requesting this information.
    - parameter indexPath:      The index path that specifies the location of `cell` and `item`.

    - returns: A configured `UICollectionViewCell` of type `Cell`.
    */
    public func configureCell(cell: Cell, forItem item: Item, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> Cell {
        return cellConfigurator(cell, item, collectionView, indexPath)
    }
}
