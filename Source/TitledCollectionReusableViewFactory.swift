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
 A `TitledCollectionReusableViewFactory` is a specialized supplementary view factory that conforms to `ReusableViewFactoryProtocol`.

 This factory is responsible for producing and configuring `TitledCollectionReusableView` instances.
 */
public struct TitledCollectionReusableViewFactory <Item>: ReusableViewFactoryProtocol {

    // MARK: Typealiases

    /**
     Configures the `TitledCollectionReusableView` for the specified data item, collection view, and index path.

     - parameter TitledCollectionReusableView: The `TitledCollectionReusableView` to be configured at the index path.
     - parameter Item:                         The item at the index path, or `nil`.
     - parameter SupplementaryViewKind:        An identifier that describes the type of the supplementary view.
     - parameter UICollectionView:             The collection view requesting this information.
     - parameter NSIndexPath:                  The index path at which the supplementary view will be displayed.

     - returns: The configured `TitledCollectionReusableView` instance.
     */
    public typealias DataConfigurationHandler = (TitledCollectionReusableView, Item?, ReusableViewType, UICollectionView, NSIndexPath) -> TitledCollectionReusableView

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


    // MARK: ReusableViewFactoryProtocol

    /// :nodoc:
    public func reuseIdentiferFor(item item: Item?, type: ReusableViewType, indexPath: NSIndexPath) -> String {
        return TitledCollectionReusableView.identifier
    }

    /// :nodoc:
    public func configure(view view: TitledCollectionReusableView, item: Item?, type: ReusableViewType, parentView: UICollectionView, indexPath: NSIndexPath) -> TitledCollectionReusableView {
        styleConfigurator(view)
        dataConfigurator(view, item, type, parentView, indexPath)
        return view
    }
}
