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
//  Copyright © 2015 Jesse Squires
//  Released under an MIT license: https://opensource.org/licenses/MIT
//

import Foundation
import UIKit
import JSQDataSourcesKit

/*
 Example of a composed factory for supplementary views.
 Used for headers and footers in `FetchedCollectionViewController` in the demo
 */
public struct ComposedCollectionSupplementaryViewFactory <Item>: ReusableViewFactoryProtocol {

    public let headerViewFactory: TitledSupplementaryViewFactory<Item>

    public let footerViewFactory: TitledSupplementaryViewFactory<Item>

    public init(headerViewFactory: TitledSupplementaryViewFactory<Item>,
                footerViewFactory: TitledSupplementaryViewFactory<Item>) {
        self.headerViewFactory = headerViewFactory
        self.footerViewFactory = footerViewFactory
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
        case .supplementaryView(kind: UICollectionElementKindSectionHeader):
            return headerViewFactory.configure(view: view, item: item, type: type, parentView: parentView, indexPath: indexPath)
        case .supplementaryView(kind: UICollectionElementKindSectionFooter):
            return footerViewFactory.configure(view: view, item: item, type: type, parentView: parentView, indexPath: indexPath)
        default:
            fatalError("attempt to dequeue supplementary view with unknown kind: \(type)")
        }
    }
}
