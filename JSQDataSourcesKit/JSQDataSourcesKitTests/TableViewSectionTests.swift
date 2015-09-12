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


class TableViewSectionTests: XCTestCase {

    func test_ThatTableViewSectionReturnsExpectedDataFromSubscript() {

        // GIVEN: a model and a table view section
        let expectedModel = FakeTableModel()
        let section = TableViewSection(dataItems: [FakeTableModel(), FakeTableModel(), expectedModel, FakeTableModel(), FakeTableModel()])

        // WHEN: we ask for an item at a specific index
        let item = section[2]

        // THEN: we receive the expected item
        XCTAssertEqual(item, expectedModel, "Model returned from subscript should equal expected model")
    }

    func test_ThatTableViewSectionSetsExpectedDataAtSubscript() {

        // GIVEN: a table view section
        var section = TableViewSection(dataItems: [FakeTableModel(), FakeTableModel(), FakeTableModel(), FakeTableModel()])
        let count = section.dataItems.count

        // WHEN: we set an item at a specific index
        let index = 1
        let expectedModel = FakeTableModel()
        section[index] = expectedModel

        // THEN: the item at the specified index is replaced with the new item
        XCTAssertEqual(section[index], expectedModel, "Model set at subscript should equal expected model")
        XCTAssertEqual(count, section.count, "Section count should remain unchanged")
    }

    func test_ThatTableViewSectionReturnsExpectedCount() {

        // GIVEN: items and a table view section
        let items = [FakeTableModel(), FakeTableModel(), FakeTableModel(), FakeTableModel()]
        let section = TableViewSection(dataItems: items)

        // WHEN: we ask the section for its count
        let count = section.count

        // THEN: we receive the expected count
        XCTAssertEqual(count, items.count, "Count should equal expected count")
        XCTAssertEqual(count, section.dataItems.count, "Count should equal expected count")
    }
    
}
