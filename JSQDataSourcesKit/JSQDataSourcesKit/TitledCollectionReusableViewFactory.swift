//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQDataSourcesKit
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


public struct TitledCollectionReusableViewFactory <DataItem>: CollectionSupplementaryViewFactoryType {

    public typealias DataConfigurationHandler = (TitledCollectionReusableView, DataItem, SupplementaryViewKind, UICollectionView, NSIndexPath) -> TitledCollectionReusableView

    public typealias StyleConfigurationHandler = (TitledCollectionReusableView) -> Void

    private let dataConfigurator: DataConfigurationHandler

    private let styleConfigurator: StyleConfigurationHandler

    public init(dataConfigurator: DataConfigurationHandler, styleConfigurator: StyleConfigurationHandler) {
        self.dataConfigurator = dataConfigurator
        self.styleConfigurator = styleConfigurator
    }

    public func supplementaryViewForItem(item: DataItem, kind: SupplementaryViewKind,
        inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> TitledCollectionReusableView {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: TitledCollectionReusableView.identifier, forIndexPath: indexPath) as! TitledCollectionReusableView
            styleConfigurator(view)
            return view
    }

    public func configureSupplementaryView(view: TitledCollectionReusableView, forItem item: DataItem, kind: SupplementaryViewKind,
        inCollectionView collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> TitledCollectionReusableView {
            return dataConfigurator(view, item, kind, collectionView, indexPath)
    }
}
