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
import JSQDataSourcesKit

/**
*   Example of a composed factory for supplementary views.
*   Used for headers and footers in `FetchedCollectionViewController` in the demo
*/

public struct ComposedCollectionSupplementaryViewFactory <DataItem>: CollectionSupplementaryViewFactoryType {

    public let headerViewFactory: TitledCollectionReusableViewFactory<DataItem>

    public let footerViewFactory: TitledCollectionReusableViewFactory<DataItem>

    public init(headerViewFactory: TitledCollectionReusableViewFactory<DataItem>, footerViewFactory: TitledCollectionReusableViewFactory<DataItem>) {
        self.headerViewFactory = headerViewFactory
        self.footerViewFactory = footerViewFactory
    }

    public func supplementaryViewForItem(item: DataItem, kind: SupplementaryViewKind,
        inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> TitledCollectionReusableView {

            switch kind {
            case UICollectionElementKindSectionHeader:
                return headerViewFactory.supplementaryViewForItem(item, kind: kind, inCollectionView: collectionView, atIndexPath: indexPath)
            case UICollectionElementKindSectionFooter:
                return footerViewFactory.supplementaryViewForItem(item, kind: kind, inCollectionView: collectionView, atIndexPath: indexPath)
            default:
                // this will never be called, but cannot return nil
                return TitledCollectionReusableView()
            }
    }

    public func configureSupplementaryView(view: TitledCollectionReusableView, forItem item: DataItem, kind: SupplementaryViewKind,
        inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> TitledCollectionReusableView {

            switch kind {
            case UICollectionElementKindSectionHeader:
                return headerViewFactory.configureSupplementaryView(view, forItem: item, kind: kind, inCollectionView: collectionView, atIndexPath: indexPath)
            case UICollectionElementKindSectionFooter:
                return footerViewFactory.configureSupplementaryView(view, forItem: item, kind: kind, inCollectionView: collectionView, atIndexPath: indexPath)
            default:
                return view
            }
    }
}
