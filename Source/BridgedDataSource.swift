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

internal typealias CollectionCellForItemAtIndexPathHandler = (UICollectionView, IndexPath) -> UICollectionViewCell
internal typealias CollectionSupplementaryViewAtIndexPathHandler = (UICollectionView, String, IndexPath) -> UICollectionReusableView

internal typealias TableCellForRowAtIndexPathHandler = (UITableView, IndexPath) -> UITableViewCell
internal typealias TableTitleForHeaderInSectionHandler = (Int) -> String?
internal typealias TableTitleForFooterInSectionHandler = (Int) -> String?


/*
 This class is responsible for implementing the `UICollectionViewDataSource` and `UITableViewDataSource` protocols.
 It avoids making `DataSourceProvider` inherit from `NSObject`, and keeps classes small and focused.
 */
@objc internal final class BridgedDataSource: NSObject {

    let numberOfSections: NumberOfSectionsHandler
    let numberOfItemsInSection: NumberOfItemsInSectionHandler

    var collectionCellForItemAtIndexPath: CollectionCellForItemAtIndexPathHandler?
    var collectionSupplementaryViewAtIndexPath: CollectionSupplementaryViewAtIndexPathHandler?

    var tableCellForRowAtIndexPath: TableCellForRowAtIndexPathHandler?
    var tableTitleForHeaderInSection: TableTitleForHeaderInSectionHandler?
    var tableTitleForFooterInSection: TableTitleForFooterInSectionHandler?

    init(numberOfSections: @escaping NumberOfSectionsHandler,
         numberOfItemsInSection: @escaping NumberOfItemsInSectionHandler) {
        self.numberOfSections = numberOfSections
        self.numberOfItemsInSection = numberOfItemsInSection
    }
}


extension BridgedDataSource: UICollectionViewDataSource {
    @objc func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }

    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection(section)
    }

    @objc func collectionView(_ collectionView: UICollectionView,
                              cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionCellForItemAtIndexPath!(collectionView, indexPath)
    }

    @objc func collectionView(_ collectionView: UICollectionView,
                              viewForSupplementaryElementOfKind kind: String,
                              at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionSupplementaryViewAtIndexPath!(collectionView, kind, indexPath)
    }
}


extension BridgedDataSource: UITableViewDataSource {
    @objc func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections()
    }

    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItemsInSection(section)
    }

    @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableCellForRowAtIndexPath!(tableView, indexPath)
    }

    @objc func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let closure = tableTitleForHeaderInSection {
            return closure(section)
        }
        return nil
    }

    @objc func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let closure = tableTitleForFooterInSection {
            return closure(section)
        }
        return nil
    }
}
