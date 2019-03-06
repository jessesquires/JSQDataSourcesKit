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
import XCTest

@testable import JSQDataSourcesKit

final class BridgedDataSourceTests: TestCase {

    func test_thatBridgedDataSource_implements_collectionViewDataSource() {
        // GIVEN: a data source
        let dataSource = BridgedDataSource(
            numberOfSections: { () -> Int in
                5
            },
            numberOfItemsInSection: { _ -> Int in
                3
        })

        dataSource.collectionCellForItemAtIndexPath = { UICollectionView, NSIndexPath -> UICollectionViewCell in
            UICollectionViewCell()
        }

        dataSource.collectionSupplementaryViewAtIndexPath = { UICollectionView, String, NSIndexPath -> UICollectionReusableView in
            UICollectionReusableView()
        }

        // WHEN: we query the collectionViewDataSource methods
        // THEN: we receive the expected data
        let sections = dataSource.numberOfSections(in: collectionView)
        XCTAssertEqual(sections, 5)

        for s in 0..<sections {
            let items = dataSource.collectionView(collectionView, numberOfItemsInSection: s)
            XCTAssertEqual(items, 3)
        }

        let indexPath = IndexPath(item: 0, section: 0)
        let cell = dataSource.collectionView(collectionView, cellForItemAt: indexPath)
        XCTAssertNotNil(cell)

        let view = dataSource.collectionView(collectionView, viewForSupplementaryElementOfKind: fakeSupplementaryViewKind, at: indexPath)
        XCTAssertNotNil(view)
    }

    func test_thatBridgedDataSource_implements_tableViewDataSource() {
        // GIVEN: a data source
        let dataSource = BridgedDataSource(
            numberOfSections: { () -> Int in
                5
            },
            numberOfItemsInSection: { _ -> Int in
                3
        })

        dataSource.tableCellForRowAtIndexPath = { UITableView, NSIndexPath -> UITableViewCell in
            UITableViewCell()
        }

        dataSource.tableTitleForHeaderInSection = { Int -> String? in
            "header"
        }

        dataSource.tableTitleForFooterInSection = { Int -> String? in
            "footer"
        }

        // WHEN: we query the tableViewDataSource methods
        // THEN: we receive the expected data
        let sections = dataSource.numberOfSections(in: tableView)
        XCTAssertEqual(sections, 5)

        for s in 0..<sections {
            let items = dataSource.tableView(tableView, numberOfRowsInSection: s)
            XCTAssertEqual(items, 3)
        }

        let indexPath = IndexPath(item: 0, section: 0)
        let cell = dataSource.tableView(tableView, cellForRowAt: indexPath)
        XCTAssertNotNil(cell)

        let header = dataSource.tableView(tableView, titleForHeaderInSection: 1)
        XCTAssertEqual(header, "header")

        let footer = dataSource.tableView(tableView, titleForFooterInSection: 2)
        XCTAssertEqual(footer, "footer")
    }

    func test_thatBridgedDataSource_implements_tableViewDataSource_withoutSectionHeadersFooters() {
        // GIVEN: a data source
        let dataSource = BridgedDataSource(
            numberOfSections: { () -> Int in
                5
            },
            numberOfItemsInSection: { _ -> Int in
                3
        })

        dataSource.tableCellForRowAtIndexPath = { UITableView, NSIndexPath -> UITableViewCell in
            UITableViewCell()
        }

        // WHEN: we query the tableViewDataSource methods
        // THEN: we receive the expected data
        let sections = dataSource.numberOfSections(in: tableView)
        XCTAssertEqual(sections, 5)

        for s in 0..<sections {
            let items = dataSource.tableView(tableView, numberOfRowsInSection: s)
            XCTAssertEqual(items, 3)
        }

        let indexPath = IndexPath(item: 0, section: 0)
        let cell = dataSource.tableView(tableView, cellForRowAt: indexPath)
        XCTAssertNotNil(cell)

        let header = dataSource.tableView(tableView, titleForHeaderInSection: 1)
        XCTAssertNil(header)

        let footer = dataSource.tableView(tableView, titleForFooterInSection: 2)
        XCTAssertNil(footer)
    }
}
