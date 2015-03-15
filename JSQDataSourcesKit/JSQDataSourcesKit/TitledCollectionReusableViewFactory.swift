//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://www.jessesquires.com/JSQDataSourcesKit/
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

    ///  Configures the `TitledCollectionReusableView` for the specified data item, collection view, and index path.
    ///  **This closure is called each time the collection view requests updates for a section's supplementary views.**
    ///
    ///  :param: TitledCollectionReusableView The `TitledCollectionReusableView` to be configured at the index path.
    ///  :param: DataItem                     The data item at the index path.
    ///  :param: SupplementaryViewKind        An identifier that describes the type of the supplementary view.
    ///  :param: UICollectionView             The collection view requesting this information.
    ///  :param: NSIndexPath                  The index path at which the supplementary view will be displayed.
    ///
    ///  :returns: The configured `TitledCollectionReusableView` instance.
    public typealias DataConfigurationHandler = (TitledCollectionReusableView, DataItem, SupplementaryViewKind, UICollectionView, NSIndexPath) -> TitledCollectionReusableView

    ///  Configures the style attributes of the `TitledCollectionReusableView`.
    ///  **This closure is only called when a `TitledCollectionReusableView` is dequeued.**
    ///
    ///  :param: TitledCollectionReusableView The `TitledCollectionReusableView` to be configured at the index path.
    public typealias StyleConfigurationHandler = (TitledCollectionReusableView) -> Void

    private let dataConfigurator: DataConfigurationHandler

    private let styleConfigurator: StyleConfigurationHandler

    ///  Constructs a new `TitledCollectionReusableViewFactory`.
    ///
    ///  :param: dataConfigurator  The closure with which the factory will configure the `TitledCollectionReusableView` with the backing data item.
    ///  :param: styleConfigurator The closure with which the factory will configure the style attributes of new `TitledCollectionReusableView`.
    ///
    ///  :returns: A new `TitledCollectionReusableViewFactory` instance.
    public init(dataConfigurator: DataConfigurationHandler, styleConfigurator: StyleConfigurationHandler) {
        self.dataConfigurator = dataConfigurator
        self.styleConfigurator = styleConfigurator
    }

    ///  Creates and returns a new `TitledCollectionReusableView` instance, or dequeues an existing one for reuse.
    ///
    ///  :param: item           The model instance (data object) at `indexPath`.
    ///  :param: kind           An identifier that describes the type of the `TitledCollectionReusableView`.
    ///  :param: collectionView The collection view requesting this information.
    ///  :param: indexPath      The index path that specifies the location of the new supplementary view.
    ///
    ///  :returns: An initialized or dequeued `TitledCollectionReusableView` instance.
    public func supplementaryViewForItem(item: DataItem, kind: SupplementaryViewKind,
        inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> TitledCollectionReusableView {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: TitledCollectionReusableView.identifier, forIndexPath: indexPath) as! TitledCollectionReusableView
            styleConfigurator(view)
            return view
    }

    ///  Configures and returns the specified `TitledCollectionReusableView` instance.
    ///
    ///  :param: view           The `TitledCollectionReusableView` to configure.
    ///  :param: item           The model instance (data object) at `indexPath`.
    ///  :param: kind           An identifier that describes the type of the `TitledCollectionReusableView`.
    ///  :param: collectionView The collection view requesting this information.
    ///  :param: indexPath      The index path that specifies the location of `view` and `item`.
    ///
    ///  :returns: A configured `TitledCollectionReusableView` instance.
    public func configureSupplementaryView(view: TitledCollectionReusableView, forItem item: DataItem, kind: SupplementaryViewKind,
        inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> TitledCollectionReusableView {
            return dataConfigurator(view, item, kind, collectionView, indexPath)
    }
}
