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
import JSQDataSourcesKit
import UIKit
import XCTest

final class DataSourceProviderSubscriptTests: XCTestCase {

    func test_dataSourceProvider_returnsExpectedDataFrom_intSubscript() {
        // GIVEN: some collection view sections
        let section0 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel())
        let section1 = Section(items: FakeViewModel(), FakeViewModel())
        let section2 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel())
        let dataSource = DataSource([section0, section1, section2])

        // GIVEN: a cell config
        let config = ReusableViewConfig(reuseIdentifier: "cellId") { (cell, _: FakeViewModel?, _, _, _) -> FakeCollectionCell in
            cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider = DataSourceProvider(dataSource: dataSource, cellConfig: config, supplementaryConfig: config)

        // WHEN: we ask for a section at a specific index
        let section = dataSourceProvider.dataSource[1]

        // THEN: we receive the expected section
        XCTAssertEqual(section.items, section1.items, "Section returned from subscript should equal expected section")
    }

    func test_dataSourceProvider_SetsExpectedDataAt_intSubscript() {
        // GIVEN: some collection view sections
        let section0 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel())
        let section1 = Section(items: FakeViewModel(), FakeViewModel())
        let section2 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel())
        let dataSource = DataSource([section0, section1, section2])

        // GIVEN: a cell config
        let config = ReusableViewConfig(reuseIdentifier: "cellId") { (cell, _: FakeViewModel?, _, _, _) -> FakeCollectionCell in
            cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider = DataSourceProvider(dataSource: dataSource, cellConfig: config, supplementaryConfig: config)
        let count = dataSourceProvider.dataSource.sections.count

        // WHEN: we set a section at a specific index
        let index = 0
        let expectedSection = Section(items: FakeViewModel(), FakeViewModel())
        dataSourceProvider.dataSource[index] = expectedSection

        // THEN: the section at the specified index is replaced with the new section
        XCTAssertEqual(dataSourceProvider.dataSource[index].items, expectedSection.items, "Section set at subscript should equal expected section")
        XCTAssertEqual(count, dataSourceProvider.dataSource.sections.count, "Number of sections should remain unchanged")
    }

    func test_dataSourceProvider_returnsExpectedDataFrom_indexPathSubscript() {
        // GIVEN: some collection view sections
        let section0 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel())
        let section1 = Section(items: FakeViewModel(), FakeViewModel())
        let dataSource = DataSource([section0, section1])

        // GIVEN: a cell config
        let config = ReusableViewConfig(reuseIdentifier: "cellId") { (cell, _: FakeViewModel?, _, _, _) -> FakeCollectionCell in
            cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider = DataSourceProvider(dataSource: dataSource, cellConfig: config, supplementaryConfig: config)

        // WHEN: we ask for an item at a specific index path
        let item1 = dataSourceProvider.dataSource[IndexPath(item: 2, section: 0)]
        let item2 = dataSourceProvider.dataSource[IndexPath(item: 0, section: 1)]

        // THEN: we receive the expected item
        XCTAssertEqual(item1, section0[2], "Item returned from subscript should equal expected item")
        XCTAssertEqual(item2, section1[0], "Item returned from subscript should equal expected item")
    }

    func test_dataSourceProvider_SetsExpectedDataAt_indexPathSubscript() {
        // GIVEN: some collection view sections
        let section0 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel())
        let section1 = Section(items: FakeViewModel(), FakeViewModel())
        let dataSource = DataSource([section0, section1])

        // GIVEN: a cell config
        let config = ReusableViewConfig(reuseIdentifier: "cellId") { (cell, _: FakeViewModel?, _, _, _) -> FakeCollectionCell in
            cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider = DataSourceProvider(dataSource: dataSource, cellConfig: config, supplementaryConfig: config)

        // WHEN: we set an item at a specific index path
        let indexPath = IndexPath(item: 2, section: 0)
        let expectedItem = FakeViewModel()

        dataSourceProvider.dataSource[indexPath] = expectedItem

        // THEN: the item at the specified index path is replaced with the new item
        XCTAssertEqual(dataSourceProvider.dataSource[indexPath], expectedItem, "Item set at subscript should equal expected item")
        XCTAssertEqual(2, dataSourceProvider.dataSource.sections.count, "Number of sections should remain unchanged")
        XCTAssertEqual(3, section0.count, "Number of items in section should remain unchanged")
    }
}
