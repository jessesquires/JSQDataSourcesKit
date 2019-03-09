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

/// A `DataSourceProvider` is responsible for providing a data source object for a table view or collection view.
public final class DataSourceProvider < DataSource: DataSourceProtocol,
    CellConfig: ReusableViewConfigProtocol,
    SupplementaryConfig: ReusableViewConfigProtocol>
where CellConfig.Item == DataSource.Item, SupplementaryConfig.Item == DataSource.Item {

    // MARK: Properties

    /// The data source.
    public var dataSource: DataSource

    /// The cell configuration.
    public let cellConfig: CellConfig

    /// The supplementary view configuration.
    public let supplementaryConfig: SupplementaryConfig

    private var bridgedDataSource: BridgedDataSource?

    private var tableEditingController: TableEditingController<DataSource>?

    // MARK: Initialization

    /// Initializes a new data source provider.
    ///
    /// - Parameters:
    ///   - dataSource: The data source.
    ///   - cellConfig: The cell configuration.
    ///   - supplementaryConfig: The supplementary view configuration.
    ///
    /// - Warning: Table views do not have supplementary views, but this parameter is still required in order to satisfy
    /// the generic constraints for Swift. You can simply pass the same `cellConfig` here. The parameter will be ignored.
    /// The same applies to collection views that do not have supplementary views. Again, the parameter will be ignored.
    public init(dataSource: DataSource,
                cellConfig: CellConfig,
                supplementaryConfig: SupplementaryConfig) {
        self.dataSource = dataSource
        self.cellConfig = cellConfig
        self.supplementaryConfig = supplementaryConfig
    }
}

extension DataSourceProvider where CellConfig.View: UITableViewCell {

    /// Initializes a new data source provider.
    ///
    /// - Parameters:
    ///   - dataSource: The data source.
    ///   - cellConfig: The cell configuration.
    ///   - supplementaryConfig: The supplementary view configuration.
    ///   - tableEditingController: The table editing controller.
    ///
    /// - Warning: Table views do not have supplementary views, but this parameter is still required in order to satisfy
    /// the generic constraints for Swift. You can simply pass the same `cellConfig` here. The parameter will be ignored.
    /// The same applies to collection views that do not have supplementary views. Again, the parameter will be ignored.
    public convenience init(dataSource: DataSource,
                            cellConfig: CellConfig,
                            supplementaryConfig: SupplementaryConfig,
                            tableEditingController: TableEditingController<DataSource>? = nil) {
        self.init(dataSource: dataSource, cellConfig: cellConfig, supplementaryConfig: supplementaryConfig)
        self.tableEditingController = tableEditingController
    }

    // MARK: UITableViewDataSource

    /// Returns the `UITableViewDataSource` object.
    public var tableViewDataSource: UITableViewDataSource {
        if bridgedDataSource == nil {
            bridgedDataSource = tableViewBridgedDataSource()
        }
        return bridgedDataSource!
    }

    private func tableViewBridgedDataSource() -> BridgedDataSource {
        let dataSource = BridgedDataSource(
            numberOfSections: { [unowned self] () -> Int in
                self.dataSource.numberOfSections()
            },
            numberOfItemsInSection: { [unowned self] section -> Int in
                self.dataSource.numberOfItems(inSection: section)
        })

        dataSource.tableCellForRowAtIndexPath = { [unowned self] tableView, indexPath -> UITableViewCell in
            let item = self.dataSource.item(atIndexPath: indexPath)!
            return self.cellConfig.tableCellFor(item: item, tableView: tableView, indexPath: indexPath)
        }

        dataSource.tableTitleForHeaderInSection = { [unowned self] section -> String? in
            self.dataSource.headerTitle(inSection: section)
        }

        dataSource.tableTitleForFooterInSection = { [unowned self] section -> String? in
            self.dataSource.footerTitle(inSection: section)
        }

        dataSource.tableCanEditRow = { [unowned self] tableView, indexPath -> Bool in
            guard let controller = self.tableEditingController else { return false }
            let item = self.dataSource.item(atIndexPath: indexPath)!
            return controller.canEditRow(item, tableView, indexPath)
        }

        dataSource.tableCommitEditingStyleForRow = { [unowned self] tableView, editingStyle, indexPath in
            self.tableEditingController?.commitEditing(&self.dataSource, tableView, editingStyle, indexPath)
        }

        return dataSource
    }
}

extension DataSourceProvider where CellConfig.View: UICollectionViewCell, SupplementaryConfig.View: UICollectionReusableView {

    // MARK: UICollectionViewDataSource

    /// Returns the `UICollectionViewDataSource` object.
    public var collectionViewDataSource: UICollectionViewDataSource {
        if bridgedDataSource == nil {
            bridgedDataSource = collectionViewBridgedDataSource()
        }
        return bridgedDataSource!
    }

    private func collectionViewBridgedDataSource() -> BridgedDataSource {

        let dataSource = BridgedDataSource(
            numberOfSections: { [unowned self] () -> Int in
                self.dataSource.numberOfSections()
            },
            numberOfItemsInSection: { [unowned self] section -> Int in
                self.dataSource.numberOfItems(inSection: section)
        })

        dataSource.collectionCellForItemAtIndexPath = { [unowned self] collectionView, indexPath -> UICollectionViewCell in
            let item = self.dataSource.item(atIndexPath: indexPath)!
            return self.cellConfig.collectionCellFor(item: item, collectionView: collectionView, indexPath: indexPath)
        }

        dataSource.collectionSupplementaryViewAtIndexPath = { [unowned self] collectionView, kind, indexPath -> UICollectionReusableView in
            var item: SupplementaryConfig.Item?
            if indexPath.section < self.dataSource.numberOfSections() {
                if indexPath.item < self.dataSource.numberOfItems(inSection: indexPath.section) {
                    item = self.dataSource.item(atIndexPath: indexPath)
                }
            }
            return self.supplementaryConfig.supplementaryViewFor(item: item,
                                                                 kind: kind,
                                                                 collectionView: collectionView,
                                                                 indexPath: indexPath)
        }

        return dataSource
    }
}
