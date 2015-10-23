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
 An instance conforming to `CollectionViewCellFactoryType` is responsible for initializing
 and configuring collection view cells to be consumed by an instance of `CollectionViewDataSourceProvider`.
 */
public protocol CollectionViewCellFactoryType {

    // MARK: Associated types

    /// The type of elements backing the collection view.
    typealias Item

    /// The type of `UICollectionViewCell` that the factory produces.
    typealias Cell: UICollectionViewCell


    // MARK: Methods

    /**
    Creates and returns a new `Cell` instance, or dequeues an existing cell for reuse.

    - parameter item:           The item at `indexPath`.
    - parameter collectionView: The collection view requesting this information.
    - parameter indexPath:      The index path that specifies the location of `cell` and `item`.

    - returns: An initialized or dequeued `UICollectionViewCell` of type `Cell`.
    */
    func cellForItem(item: Item, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> Cell

    /**
     Configures and returns the specified cell.

     - parameter cell:           The cell to configure.
     - parameter item:           The item at `indexPath`.
     - parameter collectionView: The collection view requesting this information.
     - parameter indexPath:      The index path that specifies the location of `cell` and `item`.

     - returns: A configured `UICollectionViewCell` of type `Cell`.
     */
    func configureCell(cell: Cell, forItem item: Item, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> Cell
}
