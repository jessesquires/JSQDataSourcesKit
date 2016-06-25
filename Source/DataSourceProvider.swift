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


public final class DataSourceProvider<DataSource: DataSourceProtocol, CellFactory: ReusableViewFactoryProtocol, SupplementaryFactory: ReusableViewFactoryProtocol
    where
CellFactory.Item == DataSource.Item, SupplementaryFactory.Item == DataSource.Item> {

    public var dataSource: DataSource

    public let cellFactory: CellFactory

    public let supplementaryFactory: SupplementaryFactory

    private var bridgedDataSource: BridgedDataSource?

    public init(dataSource: DataSource, cellFactory: CellFactory, supplementaryFactory: SupplementaryFactory) {
        self.dataSource = dataSource
        self.cellFactory = cellFactory
        self.supplementaryFactory = supplementaryFactory
    }
}


public extension DataSourceProvider where CellFactory.View: UITableViewCell {

    public var tableViewDataSource: UITableViewDataSource {
        if bridgedDataSource == nil {
            bridgedDataSource = tableViewBridgedDataSource()
        }
        return bridgedDataSource!
    }

    private func tableViewBridgedDataSource() -> BridgedDataSource {
        let dataSource = BridgedDataSource(
            numberOfSections: { [unowned self] () -> Int in
                return self.dataSource.numberOfSections()
            },
            numberOfItemsInSection: { [unowned self] (section) -> Int in
                return self.dataSource.numberOfItems(inSection: section)
            })

        dataSource.tableCellForRowAtIndexPath = { [unowned self] (tableView, indexPath) -> UITableViewCell in
            let item = self.dataSource.item(atIndexPath: indexPath)!
            return self.cellFactory.tableCellFor(item: item, tableView: tableView, indexPath: indexPath)
        }

        dataSource.tableTitleForHeaderInSection = { [unowned self] (section) -> String? in
            return self.dataSource.headerTitle(inSection: section)
        }

        dataSource.tableTitleForFooterInSection = { [unowned self] (section) -> String? in
            return self.dataSource.footerTitle(inSection: section)
        }

        return dataSource
    }
}


public extension DataSourceProvider where CellFactory.View: UICollectionViewCell, SupplementaryFactory.View: UICollectionReusableView {

    public var collectionViewDataSource: UICollectionViewDataSource {
        if bridgedDataSource == nil {
            bridgedDataSource = collectionViewBridgedDataSource()
        }
        return bridgedDataSource!
    }

    private func collectionViewBridgedDataSource() -> BridgedDataSource {

        let dataSource = BridgedDataSource(
            numberOfSections: { [unowned self] () -> Int in
                return self.dataSource.numberOfSections()
            },
            numberOfItemsInSection: { [unowned self] (section) -> Int in
                return self.dataSource.numberOfItems(inSection: section)
            })

        dataSource.collectionCellForItemAtIndexPath = { [unowned self] (collectionView, indexPath) -> UICollectionViewCell in
            let item = self.dataSource.item(atIndexPath: indexPath)!
            return self.cellFactory.collectionCellFor(item: item, collectionView: collectionView, indexPath: indexPath)
        }

        dataSource.collectionSupplementaryViewAtIndexPath = { [unowned self] (collectionView, kind, indexPath) -> UICollectionReusableView in
            var item: SupplementaryFactory.Item?
            if indexPath.section < self.dataSource.numberOfSections() {
                if indexPath.item < self.dataSource.numberOfItems(inSection: indexPath.section) {
                    item = self.dataSource.item(atIndexPath: indexPath)
                }
            }
            return self.supplementaryFactory.supplementaryViewFor(item: item, kind: kind, collectionView: collectionView, indexPath: indexPath)
        }
        
        return dataSource
    }
}
