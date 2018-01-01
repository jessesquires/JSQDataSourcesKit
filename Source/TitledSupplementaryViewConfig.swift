//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//
//  Documentation
//  https://jessesquires.github.io/JSQDataSourcesKit
//
//
//  GitHub
//  https://github.com/jessesquires/JSQDataSourcesKit
//
//
//  License
//  Copyright © 2015-present Jesse Squires
//  Released under an MIT license: https://opensource.org/licenses/MIT
//

import Foundation
import UIKit

/**
 A `TitledSupplementaryViewConfig` is a specialized supplementary view config that conforms to `ReusableViewConfigProtocol`.
 This config is responsible for producing and configuring `TitledSupplementaryView` instances.
 */
public struct TitledSupplementaryViewConfig <Item>: ReusableViewConfigProtocol {
    
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
    public typealias ConfigurationHandler = (TitledSupplementaryView, Item?, ReusableViewType, UICollectionView, IndexPath) -> TitledSupplementaryView
    
    
    // MARK: Private Properties
    
    private let configurator: ConfigurationHandler
    
    
    // MARK: Initialization
    
    /// Constructs a new `TitledSupplementaryView`.
    ///
    /// - Parameter configurator: The closure to configure the `TitledSupplementaryView` with the backing data item.
    public init(configurator: @escaping ConfigurationHandler) {
        self.configurator = configurator
    }
    
    
    // MARK: ReusableViewConfigProtocol
    
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
