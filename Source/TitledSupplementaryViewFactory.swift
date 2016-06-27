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
 A `TitledSupplementaryViewFactory` is a specialized supplementary view factory that conforms to `ReusableViewFactoryProtocol`.

 This factory is responsible for producing and configuring `TitledSupplementaryView` instances.
 */
public struct TitledSupplementaryViewFactory <Item>: ReusableViewFactoryProtocol {

    // MARK: Typealiases

    /**
     Configures the `TitledSupplementaryView` for the specified data item, collection view, and index path.

     - parameter view:           The `TitledSupplementaryView` to be configured at the index path.
     - parameter item:           The item at the index path, or `nil`.
     - parameter type:           The type of reusable view.
     - parameter collectionView: The collection view requesting this information.
     - parameter indexPath:      The index path at which the supplementary view will be displayed.

     - returns: The configured `TitledSupplementaryView` instance.
     */
    public typealias DataConfigurationHandler = (view: TitledSupplementaryView,
        item: Item?,
        type: ReusableViewType,
        collectionView: UICollectionView,
        indexPath: NSIndexPath) -> TitledSupplementaryView

    /**
     Configures the style attributes of the `TitledSupplementaryView`.

     - parameter TitledSupplementaryView: The `TitledSupplementaryView` to be configured at the index path.
     */
    public typealias StyleConfigurationHandler = (TitledSupplementaryView) -> Void


    // MARK: Private Properties

    private let dataConfigurator: DataConfigurationHandler

    private let styleConfigurator: StyleConfigurationHandler


    // MARK: Initialization

    /**
     Constructs a new `TitledSupplementaryView`.

     - parameter dataConfigurator:  The closure with which the factory will configure the `TitledSupplementaryView` with the backing data item.
     - parameter styleConfigurator: The closure with which the factory will configure the style attributes of new `TitledSupplementaryView`.

     - returns: A new `TitledSupplementaryView` instance.
     */
    public init(dataConfigurator: DataConfigurationHandler, styleConfigurator: StyleConfigurationHandler) {
        self.dataConfigurator = dataConfigurator
        self.styleConfigurator = styleConfigurator
    }


    // MARK: ReusableViewFactoryProtocol

    /// :nodoc:
    public func reuseIdentiferFor(item item: Item?, type: ReusableViewType, indexPath: NSIndexPath) -> String {
        return TitledSupplementaryView.identifier
    }

    /// :nodoc:
    public func configure(view view: TitledSupplementaryView, item: Item?, type: ReusableViewType, parentView: UICollectionView, indexPath: NSIndexPath) -> TitledSupplementaryView {
        styleConfigurator(view)
        dataConfigurator(view: view, item: item, type: type, collectionView: parentView, indexPath: indexPath)
        return view
    }
}
