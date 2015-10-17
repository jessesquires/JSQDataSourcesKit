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
A `CollectionSupplementaryViewFactory` is a concrete `CollectionSupplementaryViewFactoryType`.
This factory is responsible for producing and configuring supplementary views for a collection view for a specific item.
*/
public struct CollectionSupplementaryViewFactory <SupplementaryView: UICollectionReusableView, Item>: CollectionSupplementaryViewFactoryType {

    // MARK: Typealiases

    /**
    Configures the supplementary view for the specified data item, collection view, and index path.

    - parameter SupplementaryView:     The supplementary view to be configured at the index path.
    - parameter Item:                  The item at the index path.
    - parameter SupplementaryViewKind: An identifier that describes the type of the supplementary view.
    - parameter UICollectionView:      The collection view requesting this information.
    - parameter NSIndexPath:           The index path at which the supplementary view will be displayed.

    - returns: The configured supplementary view.
    */
    public typealias ConfigurationHandler = (SupplementaryView, Item, SupplementaryViewKind, UICollectionView, NSIndexPath) -> SupplementaryView

    // MARK: Properties

    /**
    A unique identifier that describes the purpose of the supplementary views that the factory produces.
    The factory dequeues supplementary views from the collection view with this reuse identifier.

    - Note: Clients are responsible for registering a view for this identifier and a supplementary view kind with the collection view.
    */
    public let reuseIdentifier: String

    private let supplementaryViewConfigurator: ConfigurationHandler

    // MARK: Initialization

    /**
    Constructs a new supplementary view factory.

    - parameter reuseIdentifier:               The reuse identifier with which the factory will dequeue supplementary views.
    - parameter supplementaryViewConfigurator: The closure with which the factory will configure supplementary views.

    - returns: A new `CollectionSupplementaryViewFactory` instance.
    */
    public init(reuseIdentifier: String, supplementaryViewConfigurator: ConfigurationHandler) {
        self.reuseIdentifier = reuseIdentifier
        self.supplementaryViewConfigurator = supplementaryViewConfigurator
    }

    // MARK: Methods

    /**
    Creates and returns a new `SupplementaryView` instance, or dequeues an existing view for reuse.

    - parameter item:           The item at `indexPath`.
    - parameter kind:           An identifier that describes the type of the supplementary view.
    - parameter collectionView: The collection view requesting this information.
    - parameter indexPath:      The index path that specifies the location of the new supplementary view.

    - returns: An initialized or dequeued `UICollectionReusableView` of type `SupplementaryView`.
    */
    public func supplementaryViewForItem(item: Item, kind: SupplementaryViewKind,
        inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> SupplementaryView {
            return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseIdentifier, forIndexPath: indexPath) as! SupplementaryView
    }

    /**
    Configures and returns the specified supplementary view.

    - parameter view:           The supplementary view to configure.
    - parameter item:           The item at `indexPath`.
    - parameter kind:           An identifier that describes the type of the supplementary view.
    - parameter collectionView: The collection view requesting this information.
    - parameter indexPath:      The index path that specifies the location of `view` and `item`.

    - returns: A configured `UICollectionReusableView` of type `SupplementaryView`.
    */
    public func configureSupplementaryView(view: SupplementaryView, forItem item: Item, kind: SupplementaryViewKind,
        inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> SupplementaryView {
            return supplementaryViewConfigurator(view, item, kind, collectionView, indexPath)
    }
}
