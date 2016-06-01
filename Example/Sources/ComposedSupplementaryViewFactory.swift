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
public struct ComposedCollectionSupplementaryViewFactory <Item>: SupplementaryViewFactoryProtocol {

    public let headerViewFactory: TitledCollectionReusableViewFactory<Item>

    public let footerViewFactory: TitledCollectionReusableViewFactory<Item>

    public init(headerViewFactory: TitledCollectionReusableViewFactory<Item>,
                footerViewFactory: TitledCollectionReusableViewFactory<Item>) {
        self.headerViewFactory = headerViewFactory
        self.footerViewFactory = footerViewFactory
    }

    public func reuseIdentiferFor(item item: Item?, kind: String, indexPath: NSIndexPath) -> String {
        return TitledCollectionReusableView.identifier
    }

    public func configure(view view: TitledCollectionReusableView,
                               item: Item?,
                               kind: String,
                               parentView: UICollectionView,
                               indexPath: NSIndexPath) -> TitledCollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            return headerViewFactory.configure(view: view, item: item, kind: kind, parentView: parentView, indexPath: indexPath)
        case UICollectionElementKindSectionFooter:
            return footerViewFactory.configure(view: view, item: item, kind: kind, parentView: parentView, indexPath: indexPath)
        default:
            fatalError("attempt to dequeue supplementary view with unknown kind: \(kind)")
        }
    }
}
