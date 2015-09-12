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
//  Copyright (c) 2015 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation
import UIKit
import XCTest

import JSQDataSourcesKit


class TableViewDataSourceSubscriptTests: XCTestCase {

    func test_ThatTableViewDataSourceProvider_ReturnsExpectedDataFromSubscript() {

        // GIVEN: some table view sections
        let section0 = TableViewSection(dataItems: [FakeTableModel(), FakeTableModel(), FakeTableModel()], headerTitle: "Header", footerTitle: "Footer")
        let section1 = TableViewSection(dataItems: [FakeTableModel()], headerTitle: "Header Title")
        let section2 = TableViewSection(dataItems: [FakeTableModel(), FakeTableModel()], footerTitle: "Footer")

        // GIVEN: a cell factory
        let factory = TableViewCellFactory(reuseIdentifier: "cellid") { (cell: FakeTableCell, model: FakeTableModel, tableView: UITableView, indexPath: NSIndexPath) -> FakeTableCell in
            return cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider = TableViewDataSourceProvider(sections: [section0, section1, section2], cellFactory: factory)

        // WHEN: we ask for a section at a specific index
        let section = dataSourceProvider[2]

        // THEN: we receive the expected section
        XCTAssertEqual(section.dataItems, section2.dataItems, "Section returned from subscript should equal expected section")
        XCTAssertTrue(section.headerTitle == section2.headerTitle, "Section returned from subscript should equal expected section")
        XCTAssertTrue(section.footerTitle == section2.footerTitle, "Section returned from subscript should equal expected section")
    }

    func test_ThatTableViewDataSourceProvider_SetsExpectedDataAtSubscript() {

        // GIVEN: some table view sections
        let section0 = TableViewSection(dataItems: [FakeTableModel(), FakeTableModel(), FakeTableModel()], headerTitle: "Header", footerTitle: "Footer")
        let section1 = TableViewSection(dataItems: [FakeTableModel()], headerTitle: "Header Title")

        // GIVEN: a cell factory
        let factory = TableViewCellFactory(reuseIdentifier: "reuseId") { (cell: UITableViewCell, model: FakeTableModel, view: UITableView, index: NSIndexPath) -> UITableViewCell in
            return cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider = TableViewDataSourceProvider(sections: [section0, section1], cellFactory: factory)
        let count = dataSourceProvider.sections.count

        // WHEN: we set a section at a specific index
        let index = 1
        let expectedSection = TableViewSection(dataItems: [FakeTableModel(), FakeTableModel()], footerTitle: "Footer")
        dataSourceProvider[index] = expectedSection

        // THEN: the section at the specified index is replaced with the new section
        XCTAssertEqual(dataSourceProvider[index].dataItems, expectedSection.dataItems, "Section set at subscript should equal expected section")
        XCTAssertTrue(dataSourceProvider[index].headerTitle == expectedSection.headerTitle, "Section set at subscript should equal expected section")
        XCTAssertTrue(dataSourceProvider[index].footerTitle == expectedSection.footerTitle, "Section set at subscript should equal expected section")

        XCTAssertEqual(count, dataSourceProvider.sections.count, "Number of sections should remain unchanged")
    }
    
}
