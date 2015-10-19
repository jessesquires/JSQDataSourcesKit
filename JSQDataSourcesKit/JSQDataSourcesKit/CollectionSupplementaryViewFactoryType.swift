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


/// Describes a collection view element kind, such as `UICollectionElementKindSectionHeader`.
public typealias SupplementaryViewKind = String


/**
An instance conforming to `CollectionSupplementaryViewFactoryType` is responsible for initializing
and configuring collection view supplementary views to be consumed by an instance of `CollectionViewDataSourceProvider`.
*/
public protocol CollectionSupplementaryViewFactoryType {

    // MARK: Associated types

    /// The type of elements backing the collection view.
    typealias Item

    /// The type of `UICollectionReusableView` that the factory produces.
    typealias SupplementaryView: UICollectionReusableView

    
    // MARK: Methods

    /**
    Creates and returns a new `SupplementaryView` instance, or dequeues an existing view for reuse.

    - parameter item:           The item at `indexPath`.
    - parameter kind:           An identifier that describes the type of the supplementary view.
    - parameter collectionView: The collection view requesting this information.
    - parameter indexPath:      The index path that specifies the location of the new supplementary view.

    - returns: An initialized or dequeued `UICollectionReusableView` of type `SupplementaryView`.
    */
    func supplementaryViewForItem(item: Item, kind: SupplementaryViewKind, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> SupplementaryView

    /**
    Configures and returns the specified supplementary view.

    - parameter view:           The supplementary view to configure.
    - parameter item:           The item at `indexPath`.
    - parameter kind:           An identifier that describes the type of the supplementary view.
    - parameter collectionView: The collection view requesting this information.
    - parameter indexPath:      The index path that specifies the location of `view` and `item`.

    - returns: A configured `UICollectionReusableView` of type `SupplementaryView`.
    */
    func configureSupplementaryView(view: SupplementaryView, forItem item: Item, kind: SupplementaryViewKind, inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> SupplementaryView
}
