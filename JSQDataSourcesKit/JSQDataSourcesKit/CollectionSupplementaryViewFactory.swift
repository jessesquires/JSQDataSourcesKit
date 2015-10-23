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
public struct CollectionSupplementaryViewFactory <SupplementaryView: UICollectionReusableView, Item>: CollectionSupplementaryViewFactoryType, CustomStringConvertible {

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

    - note: Clients are responsible for registering a view for this identifier and a supplementary view kind with the collection view.
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


    // MARK: CollectionSupplementaryViewFactoryType

    /// :nodoc:
    public func supplementaryViewForItem(
        item: Item,
        kind: SupplementaryViewKind,
        inCollectionView collectionView: UICollectionView,
        atIndexPath indexPath: NSIndexPath) -> SupplementaryView {
            return collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier: reuseIdentifier,
                forIndexPath: indexPath) as! SupplementaryView
    }

    /// :nodoc:
    public func configureSupplementaryView(
        view: SupplementaryView,
        forItem item: Item,
        kind: SupplementaryViewKind,
        inCollectionView collectionView: UICollectionView,
        atIndexPath indexPath: NSIndexPath) -> SupplementaryView {
            return supplementaryViewConfigurator(view, item, kind, collectionView, indexPath)
    }


    // MARK: CustomStringConvertible

    /// :nodoc:
    public var description: String {
        get {
            return "<\(CollectionSupplementaryViewFactory.self): \(reuseIdentifier)>"
        }
    }
}
