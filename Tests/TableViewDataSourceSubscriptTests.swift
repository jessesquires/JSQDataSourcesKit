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


final class TableViewDataSourceSubscriptTests: XCTestCase {

    func test_ThatTableViewDataSourceProvider_ReturnsExpectedDataFrom_IntSubscript() {

        // GIVEN: some table view sections
        let section0 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), headerTitle: "Header", footerTitle: "Footer")
        let section1 = Section(items: FakeViewModel(), headerTitle: "Header Title")
        let section2 = Section(items: FakeViewModel(), FakeViewModel(), footerTitle: "Footer")

        // GIVEN: a cell factory
        let factory = CellFactory(reuseIdentifier: "cellid") { (cell, model: FakeViewModel, tableView, indexPath) -> FakeTableCell in
            return cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider = TableViewDataSourceProvider(sections: [section0, section1, section2], cellFactory: factory)

        // WHEN: we ask for a section at a specific index
        let section = dataSourceProvider[2]

        // THEN: we receive the expected section
        XCTAssertEqual(section.items, section2.items, "Section returned from subscript should equal expected section")
        XCTAssertTrue(section.headerTitle == section2.headerTitle, "Section returned from subscript should equal expected section")
        XCTAssertTrue(section.footerTitle == section2.footerTitle, "Section returned from subscript should equal expected section")
    }

    func test_ThatTableViewDataSourceProvider_SetsExpectedDataAt_IntSubscript() {

        // GIVEN: some table view sections
        let section0 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), headerTitle: "Header", footerTitle: "Footer")
        let section1 = Section(items: FakeViewModel(), headerTitle: "Header Title")

        // GIVEN: a cell factory
        let factory = CellFactory(reuseIdentifier: "cellid") { (cell, model: FakeViewModel, tableView, indexPath) -> FakeTableCell in
            return cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider = TableViewDataSourceProvider(sections: [section0, section1], cellFactory: factory)
        let count = dataSourceProvider.sections.count

        // WHEN: we set a section at a specific index
        let index = 1
        let expectedSection = Section(items: FakeViewModel(), FakeViewModel(), footerTitle: "Footer")
        dataSourceProvider[index] = expectedSection

        // THEN: the section at the specified index is replaced with the new section
        XCTAssertEqual(dataSourceProvider[index].items, expectedSection.items, "Section set at subscript should equal expected section")
        XCTAssertTrue(dataSourceProvider[index].headerTitle == expectedSection.headerTitle, "Section set at subscript should equal expected section")
        XCTAssertTrue(dataSourceProvider[index].footerTitle == expectedSection.footerTitle, "Section set at subscript should equal expected section")

        XCTAssertEqual(count, dataSourceProvider.sections.count, "Number of sections should remain unchanged")
    }

    func test_ThatTableViewDataSourceProvider_ReturnsExpectedDataFrom_IndexPathSubscript() {

        // GIVEN: some table view sections
        let section0 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel())
        let section1 = Section(items: FakeViewModel())

        // GIVEN: a cell factory
        let factory = CellFactory(reuseIdentifier: "cellid") { (cell, model: FakeViewModel, tableView, indexPath) -> FakeTableCell in
            return cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider = TableViewDataSourceProvider(sections: [section0, section1], cellFactory: factory)

        // WHEN: we ask for an item at a specific index path
        let indexPath = NSIndexPath(forRow: 2, inSection: 0)
        let item = dataSourceProvider[indexPath]

        // THEN: we receive the expected item
        XCTAssertEqual(item, section0[2], "Item returned from subscript should equal expected item")
    }

    func test_ThatTableViewDataSourceProvider_SetsExpectedDataAt_IndexPathSubscript() {

        // GIVEN: some table view sections
        let section0 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel())
        let section1 = Section(items: FakeViewModel())

        // GIVEN: a cell factory
        let factory = CellFactory(reuseIdentifier: "cellid") { (cell, model: FakeViewModel, tableView, indexPath) -> FakeTableCell in
            return cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider = TableViewDataSourceProvider(sections: [section0, section1], cellFactory: factory)

        // WHEN: we set an item at a specific index path
        let indexPath = NSIndexPath(forRow: 0, inSection: 1)
        let expectedItem = FakeViewModel()

        dataSourceProvider[indexPath] = expectedItem

        // THEN: the item at the specified index path is replaced with the new item
        XCTAssertEqual(dataSourceProvider[indexPath], expectedItem, "Item set at subscript should equal expected item")

        XCTAssertEqual(2, dataSourceProvider.sections.count, "Number of sections should remain unchanged")
        XCTAssertEqual(1, section1.count, "Number of items in section should remain unchanged")
    }
}
