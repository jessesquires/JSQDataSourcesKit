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


internal typealias NumberOfSectionsHandler = () -> Int
internal typealias NumberOfItemsInSectionHandler = (Int) -> Int

internal typealias CollectionCellForItemAtIndexPathHandler = (UICollectionView, NSIndexPath) -> UICollectionViewCell
internal typealias CollectionSupplementaryViewAtIndexPathHandler = (UICollectionView, String, NSIndexPath) -> UICollectionReusableView

internal typealias TableCellForRowAtIndexPathHandler = (UITableView, NSIndexPath) -> UITableViewCell
internal typealias TableTitleForHeaderInSectionHandler = (Int) -> String?
internal typealias TableTitleForFooterInSectionHandler = (Int) -> String?


/*
 Avoid making DataSourceProvider inherit from NSObject.
 Keep classes pure Swift.
 Keep responsibilies focused.
 */
@objc internal final class BridgedDataSource: NSObject {

    let numberOfSections: NumberOfSectionsHandler
    let numberOfItemsInSection: NumberOfItemsInSectionHandler

    var collectionCellForItemAtIndexPath: CollectionCellForItemAtIndexPathHandler?
    var collectionSupplementaryViewAtIndexPath: CollectionSupplementaryViewAtIndexPathHandler?

    var tableCellForRowAtIndexPath: TableCellForRowAtIndexPathHandler?
    var tableTitleForHeaderInSection: TableTitleForHeaderInSectionHandler?
    var tableTitleForFooterInSection: TableTitleForFooterInSectionHandler?

    init(numberOfSections: NumberOfSectionsHandler, numberOfItemsInSection: NumberOfItemsInSectionHandler) {
        self.numberOfSections = numberOfSections
        self.numberOfItemsInSection = numberOfItemsInSection
    }
}


extension BridgedDataSource: UICollectionViewDataSource {
    @objc func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }

    @objc func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection(section)
    }

    @objc func collectionView(collectionView: UICollectionView,
                              cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionCellForItemAtIndexPath!(collectionView, indexPath)
    }

    @objc func collectionView(collectionView: UICollectionView,
                              viewForSupplementaryElementOfKind kind: String,
                                                                atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionSupplementaryViewAtIndexPath!(collectionView, kind, indexPath)
    }
}


extension BridgedDataSource: UITableViewDataSource {
    @objc func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections()
    }

    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItemsInSection(section)
    }

    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableCellForRowAtIndexPath!(tableView, indexPath)
    }

    @objc func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let closure = tableTitleForHeaderInSection {
            return closure(section)
        }
        return nil
    }

    @objc func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let closure = tableTitleForFooterInSection {
            return closure(section)
        }
        return nil
    }
}
