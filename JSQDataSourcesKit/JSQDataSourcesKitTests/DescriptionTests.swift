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
import XCTest

import JSQDataSourcesKit


class DescriptionTests: XCTestCase {
    
    func test_CollectionViewDataSource_Descriptions() {
        print("\(__FUNCTION__)\n")
        let fakeCollectionView = FakeCollectionView(frame: CGRect.zero, collectionViewLayout: FakeFlowLayout())

        let section = CollectionViewSection(items: FakeCollectionModel(), FakeCollectionModel())
        print(section, "\n")

        let cellFactory = CollectionViewCellFactory(reuseIdentifier: "cellId") {
            (cell, model: FakeCollectionModel, view, indexPath) -> FakeCollectionCell in
            return cell
        }
        print(cellFactory, "\n")

        let supplementaryViewFactory = CollectionSupplementaryViewFactory(reuseIdentifier: "supplementaryId") {
            (view, model: FakeCollectionModel, kind, collectionView, indexPath) -> FakeCollectionSupplementaryView in
                return view
        }
        print(supplementaryViewFactory, "\n")

        let titledSupplementaryViewFactory = TitledCollectionReusableViewFactory(dataConfigurator: {
            (view, item: FakeCollectionModel, kind, cv, indexPath) -> TitledCollectionReusableView in
            return view
            }) { (view) -> Void in
        }
        print(titledSupplementaryViewFactory, "\n")

        let dataSourceProvider = CollectionViewDataSourceProvider(
            sections: [section],
            cellFactory: cellFactory,
            supplementaryViewFactory: supplementaryViewFactory,
            collectionView: fakeCollectionView)

        print(dataSourceProvider, "\n")
    }

    func test_TableViewDataSource_Descriptions() {
        print("\(__FUNCTION__)\n")
        let fakeTableView = FakeTableView(frame: CGRect.zero)

        let section = TableViewSection(items: FakeTableModel(), FakeTableModel())
        print(section, "\n")

        let cellFactory = TableViewCellFactory(reuseIdentifier: "cellId") {
            (cell, model: FakeTableModel, view, indexPath) -> FakeTableCell in
            return cell
        }
        print(cellFactory, "\n")

        let dataSourceProvider = TableViewDataSourceProvider(
            sections: [section],
            cellFactory: cellFactory,
            tableView: fakeTableView)

        print(dataSourceProvider, "\n")
    }
    
}
