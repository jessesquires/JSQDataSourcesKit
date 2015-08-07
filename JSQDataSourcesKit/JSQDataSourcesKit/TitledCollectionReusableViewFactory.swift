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
//  Copyright (c) 2015 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation
import UIKit


///  A `TitledCollectionReusableViewFactory` is specialized supplementary view factory that conforms to `CollectionSupplementaryViewFactoryType`.
///  This factory is responsible for producing and configuring `TitledCollectionReusableView` instances.
///  <br/><br/>
///  **The factory has the following type parameters:**
///  <br/>
///  ````
///  <DataItem>
///  ````
public struct TitledCollectionReusableViewFactory <DataItem>: CollectionSupplementaryViewFactoryType {

    // MARK: Typealiases

    ///  Configures the `TitledCollectionReusableView` for the specified data item, collection view, and index path.
    ///  **This closure is called each time the collection view requests updates for a section's supplementary views.**
    ///
    ///  - parameter TitledCollectionReusableView: The `TitledCollectionReusableView` to be configured at the index path.
    ///  - parameter DataItem:                     The data item at the index path.
    ///  - parameter SupplementaryViewKind:        An identifier that describes the type of the supplementary view.
    ///  - parameter UICollectionView:             The collection view requesting this information.
    ///  - parameter NSIndexPath:                  The index path at which the supplementary view will be displayed.
    ///
    ///  - returns: The configured `TitledCollectionReusableView` instance.
    public typealias DataConfigurationHandler = (TitledCollectionReusableView, DataItem, SupplementaryViewKind, UICollectionView, NSIndexPath) -> TitledCollectionReusableView

    ///  Configures the style attributes of the `TitledCollectionReusableView`.
    ///  **This closure is only called when a `TitledCollectionReusableView` is dequeued.**
    ///
    ///  - parameter TitledCollectionReusableView: The `TitledCollectionReusableView` to be configured at the index path.
    public typealias StyleConfigurationHandler = (TitledCollectionReusableView) -> Void

    // MARK: Private Properties

    private let dataConfigurator: DataConfigurationHandler

    private let styleConfigurator: StyleConfigurationHandler

    // MARK: Initialization

    ///  Constructs a new `TitledCollectionReusableViewFactory`.
    ///
    ///  - parameter dataConfigurator:  The closure with which the factory will configure the `TitledCollectionReusableView` with the backing data item.
    ///  - parameter styleConfigurator: The closure with which the factory will configure the style attributes of new `TitledCollectionReusableView`.
    ///
    ///  - returns: A new `TitledCollectionReusableViewFactory` instance.
    public init(dataConfigurator: DataConfigurationHandler, styleConfigurator: StyleConfigurationHandler) {
        self.dataConfigurator = dataConfigurator
        self.styleConfigurator = styleConfigurator
    }

    // MARK: Methods

    ///  Creates and returns a new `TitledCollectionReusableView` instance, or dequeues an existing one for reuse.
    ///
    ///  - parameter item:           The model instance (data object) at `indexPath`.
    ///  - parameter kind:           An identifier that describes the type of the `TitledCollectionReusableView`.
    ///  - parameter collectionView: The collection view requesting this information.
    ///  - parameter indexPath:      The index path that specifies the location of the new supplementary view.
    ///
    ///  - returns: An initialized or dequeued `TitledCollectionReusableView` instance.
    public func supplementaryViewForItem(item: DataItem, kind: SupplementaryViewKind,
        inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> TitledCollectionReusableView {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: TitledCollectionReusableView.identifier, forIndexPath: indexPath) as! TitledCollectionReusableView
            styleConfigurator(view)
            return view
    }

    ///  Configures and returns the specified `TitledCollectionReusableView` instance.
    ///
    ///  - parameter view:           The `TitledCollectionReusableView` to configure.
    ///  - parameter item:           The model instance (data object) at `indexPath`.
    ///  - parameter kind:           An identifier that describes the type of the `TitledCollectionReusableView`.
    ///  - parameter collectionView: The collection view requesting this information.
    ///  - parameter indexPath:      The index path that specifies the location of `view` and `item`.
    ///
    ///  - returns: A configured `TitledCollectionReusableView` instance.
    public func configureSupplementaryView(view: TitledCollectionReusableView, forItem item: DataItem, kind: SupplementaryViewKind,
        inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> TitledCollectionReusableView {
            return dataConfigurator(view, item, kind, collectionView, indexPath)
    }
}
