//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQDataSourcesKit
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

import UIKit
import Foundation
import XCTest
import JSQDataSourcesKit


// MARK: fakes

struct FakeTableModel: Equatable {
    let name = NSProcessInfo.processInfo().globallyUniqueString
}


func ==(lhs: FakeTableModel, rhs: FakeTableModel) -> Bool {
    return lhs.name == rhs.name
}

class FakeTableCell: UITableViewCell { }


class FakeTableView: UITableView {

    var dequeueCellExpectation: XCTestExpectation?

    override func dequeueReusableCellWithIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> AnyObject {
        self.dequeueCellExpectation?.fulfill()
        return super.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
    }
}


// MARK: test case

class TableViewDataSourceTests: XCTestCase {


    // MARK: setup

    let fakeReuseId = "fakeCellId"
    let fakeTableView = FakeTableView(frame: CGRect(x: 0, y: 0, width: 320, height: 600), style: .Plain)
    let dequeueCellExpectationName = "tableview_dequeue_cell_expectation"

    override func setUp() {
        super.setUp()

        self.fakeTableView.registerClass(FakeTableCell.self, forCellReuseIdentifier: self.fakeReuseId)
    }

    override func tearDown() {
        super.tearDown()
    }


    // MARK: tests

    func test_ThatTableViewSectionInfoReturnsExpectedDataFromSubscript() {

        // GIVEN: a model and section
        let expectedModel = FakeTableModel()
        let section = TableViewSection(dataItems: [ FakeTableModel(), FakeTableModel(), expectedModel, FakeTableModel(), FakeTableModel()], headerTitle: "Header", footerTitle: "Footer")

        // WHEN: we ask for an item at a specific index
        let item = section[2]

        // THEN: we receive the expected item
        XCTAssertEqual(item, expectedModel, "Model returned from subscript should equal expected model")
    }

    func test_ThatTableViewDataSourceReturnsExpectedData_ForSingleSection() {

        // GIVEN: a single TableViewSection with data items
        let expectedModel = FakeTableModel()
        let expectedIndexPath = NSIndexPath(forRow: 2, inSection: 0)

        let section0 = TableViewSection(dataItems: [ FakeTableModel(), FakeTableModel(), expectedModel, FakeTableModel(), FakeTableModel()], headerTitle: "Header", footerTitle: "Footer")
        let allSections = [section0]

        let factoryExpectation = self.expectationWithDescription("\(__FUNCTION__)")
        self.fakeTableView.dequeueCellExpectation = self.expectationWithDescription(self.dequeueCellExpectationName + "_\(__FUNCTION__)")

        // GIVEN: a cell factory
        let factory = TableViewCellFactory(reuseIdentifier: self.fakeReuseId) { (cell: FakeTableCell, model: FakeTableModel, tableView: UITableView, indexPath: NSIndexPath) -> FakeTableCell in
            XCTAssertEqual(cell.reuseIdentifier!, self.fakeReuseId, "Dequeued cell should have expected identifier")
            XCTAssertEqual(tableView, self.fakeTableView, "TableView should equal the tableView for the data source")

            XCTAssertEqual(model, expectedModel, "Model object should equal expected value")
            XCTAssertEqual(indexPath, expectedIndexPath, "IndexPath should equal expected value")

            factoryExpectation.fulfill()

            return cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider = TableViewDataSourceProvider(sections: allSections, cellFactory: factory, tableView: self.fakeTableView)
        let dataSource = dataSourceProvider.dataSource

        // WHEN: we call the table view data source methods
        let sections = dataSource.numberOfSectionsInTableView?(self.fakeTableView)
        let rows = dataSource.tableView(self.fakeTableView, numberOfRowsInSection: 0)
        let cell = dataSource.tableView(self.fakeTableView, cellForRowAtIndexPath: expectedIndexPath)
        let header = dataSource.tableView?(self.fakeTableView, titleForHeaderInSection: 0)
        let footer = dataSource.tableView?(self.fakeTableView, titleForFooterInSection: 0)

        // THEN: we receive the expected return values
        XCTAssertNotNil(sections, "Number of sections should not be nil")
        XCTAssertEqual(sections!, dataSourceProvider.sections.count, "Data source should return expected number of sections")

        XCTAssertEqual(rows, section0.count, "Data source should return expected number of rows for section 0")

        XCTAssertNotNil(cell.reuseIdentifier, "Cell reuse identifier should not be nil")
        XCTAssertEqual(cell.reuseIdentifier!, self.fakeReuseId, "Data source should return cells with the expected identifier")

        XCTAssertNotNil(header, "Header should not be nil")
        XCTAssertNotNil(section0.headerTitle, "Section 0 header title should not be nil")
        XCTAssertEqual(header!, section0.headerTitle!, "Data source should return expected header title")

        XCTAssertNotNil(footer, "Footer should not be nil")
        XCTAssertNotNil(section0.footerTitle, "Section 0 footer title should not be nil")
        XCTAssertEqual(footer!, section0.footerTitle!, "Data source should return expected footer title")

        // THEN: the tableView calls `dequeueReusableCellWithIdentifier`
        // THEN: the cell factory calls its `CellConfigurationHandler`
        self.waitForExpectationsWithTimeout(1, handler: { (error) -> Void in
            XCTAssertNil(error, "Expectations should not error")
        })
        
    }
    
    func test_test_ThatTableViewDataSourceReturnsExpectedData_ForMultipleSections() {
        
    }
    
}
