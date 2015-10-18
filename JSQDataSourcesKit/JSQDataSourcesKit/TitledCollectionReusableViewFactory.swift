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


/**
A `TitledCollectionReusableViewFactory` is specialized supplementary view factory
that conforms to `CollectionSupplementaryViewFactoryType`.

This factory is responsible for producing and configuring `TitledCollectionReusableView` instances.
*/
public struct TitledCollectionReusableViewFactory <Item>: CollectionSupplementaryViewFactoryType {

    // MARK: Typealiases

    /**
    Configures the `TitledCollectionReusableView` for the specified data item, collection view, and index path.

    - parameter TitledCollectionReusableView: The `TitledCollectionReusableView` to be configured at the index path.
    - parameter Item:                         The item at the index path.
    - parameter SupplementaryViewKind:        An identifier that describes the type of the supplementary view.
    - parameter UICollectionView:             The collection view requesting this information.
    - parameter NSIndexPath:                  The index path at which the supplementary view will be displayed.

    - returns: The configured `TitledCollectionReusableView` instance.
    */
    public typealias DataConfigurationHandler = (TitledCollectionReusableView, Item, SupplementaryViewKind, UICollectionView, NSIndexPath) -> TitledCollectionReusableView

    /**
    Configures the style attributes of the `TitledCollectionReusableView`.

    - parameter TitledCollectionReusableView: The `TitledCollectionReusableView` to be configured at the index path.
    */
    public typealias StyleConfigurationHandler = (TitledCollectionReusableView) -> Void


    // MARK: Private Properties

    private let dataConfigurator: DataConfigurationHandler

    private let styleConfigurator: StyleConfigurationHandler


    // MARK: Initialization

    /**
    Constructs a new `TitledCollectionReusableViewFactory`.

    - parameter dataConfigurator:  The closure with which the factory will configure the `TitledCollectionReusableView` with the backing data item.
    - parameter styleConfigurator: The closure with which the factory will configure the style attributes of new `TitledCollectionReusableView`.

    - returns: A new `TitledCollectionReusableViewFactory` instance.
    */
    public init(dataConfigurator: DataConfigurationHandler, styleConfigurator: StyleConfigurationHandler) {
        self.dataConfigurator = dataConfigurator
        self.styleConfigurator = styleConfigurator
    }


    // MARK: CollectionSupplementaryViewFactoryType

    /// :nodoc:
    public func supplementaryViewForItem(
        item: Item,
        kind: SupplementaryViewKind,
        inCollectionView collectionView: UICollectionView,
        atIndexPath indexPath: NSIndexPath) -> TitledCollectionReusableView {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier: TitledCollectionReusableView.identifier,
                forIndexPath: indexPath) as! TitledCollectionReusableView
            styleConfigurator(view)
            return view
    }

    /// :nodoc:
    public func configureSupplementaryView(
        view: TitledCollectionReusableView,
        forItem item: Item,
        kind: SupplementaryViewKind,
        inCollectionView collectionView: UICollectionView,
        atIndexPath indexPath: NSIndexPath) -> TitledCollectionReusableView {
            return dataConfigurator(view, item, kind, collectionView, indexPath)
    }
}
