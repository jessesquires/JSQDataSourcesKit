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
import JSQDataSourcesKit
import UIKit

/*
 Example of a composed config for supplementary views.
 Used for headers and footers in `FetchedCollectionViewController` in the demo
 */
public struct ComposedCollectionSupplementaryViewConfig <Item>: ReusableViewConfigProtocol {

    public let headerConfig: TitledSupplementaryViewConfig<Item>

    public let footerConfig: TitledSupplementaryViewConfig<Item>

    public init(headerConfig: TitledSupplementaryViewConfig<Item>,
                footerConfig: TitledSupplementaryViewConfig<Item>) {
        self.headerConfig = headerConfig
        self.footerConfig = footerConfig
    }

    public func reuseIdentiferFor(item: Item?, type: ReusableViewType, indexPath: IndexPath) -> String {
        return TitledSupplementaryView.identifier
    }

    public func configure(view: TitledSupplementaryView,
                          item: Item?,
                          type: ReusableViewType,
                          parentView: UICollectionView,
                          indexPath: IndexPath) -> TitledSupplementaryView {
        switch type {
        case .supplementaryView(kind: UICollectionView.elementKindSectionHeader):
            return headerConfig.configure(view: view, item: item, type: type, parentView: parentView, indexPath: indexPath)

        case .supplementaryView(kind: UICollectionView.elementKindSectionFooter):
            return footerConfig.configure(view: view, item: item, type: type, parentView: parentView, indexPath: indexPath)

        default:
            fatalError("attempt to dequeue supplementary view with unknown kind: \(type)")
        }
    }
}
