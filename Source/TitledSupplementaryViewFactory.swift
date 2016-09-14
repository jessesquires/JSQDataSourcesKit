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
    public typealias ConfigurationHandler = (_ view: TitledSupplementaryView, _ item: Item?, _ type: ReusableViewType, _ collectionView: UICollectionView, _ indexPath: IndexPath) -> TitledSupplementaryView


    // MARK: Private Properties

    private let configurator: ConfigurationHandler


    // MARK: Initialization

    /**
     Constructs a new `TitledSupplementaryView`.

     - parameter configurator: The closure with which the factory will configure the `TitledSupplementaryView` with the backing data item.

     - returns: A new `TitledSupplementaryView` instance.
     */
    public init(configurator: @escaping ConfigurationHandler) {
        self.configurator = configurator
    }


    // MARK: ReusableViewFactoryProtocol

    /// :nodoc:
    public func reuseIdentiferFor(item: Item?, type: ReusableViewType, indexPath: IndexPath) -> String {
        return TitledSupplementaryView.identifier
    }

    /// :nodoc:
    public func configure(view: TitledSupplementaryView,
                               item: Item?,
                               type: ReusableViewType,
                               parentView: UICollectionView,
                               indexPath: IndexPath) -> TitledSupplementaryView {
        return configurator(view, item, type, parentView, indexPath)
    }
}
