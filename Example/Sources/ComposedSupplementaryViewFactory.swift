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
import JSQDataSourcesKit

/*
 Example of a composed factory for supplementary views.
 Used for headers and footers in `FetchedCollectionViewController` in the demo
 */
public struct ComposedCollectionSupplementaryViewFactory <Item>: ReusableViewFactoryProtocol {

    public let headerViewFactory: TitledCollectionReusableViewFactory<Item>

    public let footerViewFactory: TitledCollectionReusableViewFactory<Item>

    public init(headerViewFactory: TitledCollectionReusableViewFactory<Item>,
                footerViewFactory: TitledCollectionReusableViewFactory<Item>) {
        self.headerViewFactory = headerViewFactory
        self.footerViewFactory = footerViewFactory
    }

    public func reuseIdentiferFor(item item: Item?, type: ReusableViewType, indexPath: NSIndexPath) -> String {
        return TitledCollectionReusableView.identifier
    }

    public func configure(view view: TitledCollectionReusableView,
                               item: Item?,
                               type: ReusableViewType,
                               parentView: UICollectionView,
                               indexPath: NSIndexPath) -> TitledCollectionReusableView {
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
