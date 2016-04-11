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


public final class DataSourceProvider<SectionInfo: SectionInfoProtocol, CellFactory: CellFactoryProtocol
where CellFactory.Item == SectionInfo.Item>: CustomStringConvertible {

    public var sections: [SectionInfo]

    public let cellFactory: CellFactory

    private var bridgedDataSource: BridgedDataSource?

    public init(sections: [SectionInfo], cellFactory: CellFactory) {
        self.sections = sections
        self.cellFactory = cellFactory
    }

    public subscript (index: Int) -> SectionInfo {
        get {
            return sections[index]
        }
        set {
            sections[index] = newValue
        }
    }

    public subscript (indexPath: NSIndexPath) -> SectionInfo.Item {
        get {
            return sections[indexPath.section].items[indexPath.item]
        }
        set {
            sections[indexPath.section].items[indexPath.item] = newValue
        }
    }


    // MARK: CustomStringConvertible

    /// :nodoc:
    public var description: String {
        get {
            return "<\(DataSourceProvider.self): sections=\(sections)>"
        }
    }
}


public extension DataSourceProvider where CellFactory.Cell: UITableViewCell {

    public var tableViewDataSource: UITableViewDataSource {
        if bridgedDataSource == nil {
            bridgedDataSource = tableViewBridgedDataSource()
        }
        return bridgedDataSource!
    }

    private func tableViewBridgedDataSource() -> BridgedDataSource {
        let dataSource = BridgedDataSource(
            numberOfSections: { [unowned self] () -> Int in
                return self.sections.count
            },
            numberOfItemsInSection: { [unowned self] (section) -> Int in
                return self.sections[section].items.count
            })

        dataSource.tableCellForRowAtIndexPath = { [unowned self] (tableView, indexPath) -> UITableViewCell in
            let item = self.sections[indexPath.section].items[indexPath.row]
            return self.cellFactory.cellFor(item: item, parentView: tableView, indexPath: indexPath)
        }

        dataSource.tableTitleForHeaderInSection = { [unowned self] (section) -> String? in
            return self.sections[section].headerTitle
        }

        dataSource.tableTitleForFooterInSection = { [unowned self] (section) -> String? in
            return self.sections[section].footerTitle
        }

        return dataSource
    }
}


public extension DataSourceProvider where CellFactory.Cell: UICollectionViewCell {

    public var collectionViewDataSource: UICollectionViewDataSource {
        if bridgedDataSource == nil {
            bridgedDataSource = collectionViewBridgedDataSource()
        }
        return bridgedDataSource!
    }

    private func collectionViewBridgedDataSource() -> BridgedDataSource {

        let dataSource = BridgedDataSource(
            numberOfSections: { [unowned self] () -> Int in
                return self.sections.count
            },
            numberOfItemsInSection: { [unowned self] (section) -> Int in
                return self.sections[section].items.count
            })

        dataSource.collectionCellForItemAtIndexPath = { [unowned self] (collectionView, indexPath) -> UICollectionViewCell in
            let item = self.sections[indexPath.section].items[indexPath.row]
            return self.cellFactory.cellFor(item: item, parentView: collectionView, indexPath: indexPath)
        }

        // TODO: figure out supplementary views

        //        dataSource.collectionSupplementaryViewAtIndexPath = { [unowned self] (collectionView, kind, indexPath) -> UICollectionReusableView in
        //            let factory = self.supplementaryViewFactory!
        //            var item: Item?
        //            if indexPath.section < self.sections.count {
        //                if indexPath.item < self.sections[indexPath.section].items.count {
        //                    item = self.sections[indexPath.section].items[indexPath.item]
        //                }
        //            }
        //
        //            let view = factory.supplementaryViewFor(item: item, kind: kind, collectionView: collectionView, indexPath: indexPath)
        //            return factory.configureSupplementaryView(view, item: item, kind: kind, collectionView: collectionView, indexPath: indexPath)
        //        }
        
        return dataSource
    }
}
