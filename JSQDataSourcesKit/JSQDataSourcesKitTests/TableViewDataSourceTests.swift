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


class TableViewDataSourceTests: XCTestCase {

    let fakeReuseId = "fakeCellId"
    
    private let fakeTableView = FakeTableView(frame: CGRect(x: 0, y: 0, width: 320, height: 600), style: .Plain)
    let dequeueCellExpectationName = "tableview_dequeue_cell_expectation"

    override func setUp() {
        super.setUp()

        fakeTableView.registerClass(FakeTableCell.self, forCellReuseIdentifier: fakeReuseId)
    }
  
    func test_ThatTableViewDataSource_ReturnsExpectedData_ForSingleSection() {

        // GIVEN: a single TableViewSection with data items
        let expectedModel = FakeTableModel()
        let expectedIndexPath = NSIndexPath(forRow: 2, inSection: 0)

        let section0 = TableViewSection(items: FakeTableModel(), FakeTableModel(), expectedModel, FakeTableModel(), FakeTableModel(), headerTitle: "Header", footerTitle: "Footer")
        let allSections = [section0]

        let factoryExpectation = expectationWithDescription("\(__FUNCTION__)")
        fakeTableView.dequeueCellExpectation = expectationWithDescription(dequeueCellExpectationName + "_\(__FUNCTION__)")

        // GIVEN: a cell factory
        let factory = TableViewCellFactory(reuseIdentifier: fakeReuseId) { (cell: FakeTableCell, model: FakeTableModel, tableView: UITableView, indexPath: NSIndexPath) -> FakeTableCell in
            XCTAssertEqual(cell.reuseIdentifier!, self.fakeReuseId, "Dequeued cell should have expected identifier")
            XCTAssertEqual(tableView, self.fakeTableView, "TableView should equal the tableView for the data source")

            XCTAssertEqual(model, expectedModel, "Model object should equal expected value")
            XCTAssertEqual(indexPath, expectedIndexPath, "IndexPath should equal expected value")

            factoryExpectation.fulfill()

            return cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider = TableViewDataSourceProvider(sections: allSections, cellFactory: factory, tableView: fakeTableView)
        let dataSource = dataSourceProvider.dataSource

        // WHEN: we call the table view data source methods
        let numSections = dataSource.numberOfSectionsInTableView?(fakeTableView)
        let numRows = dataSource.tableView(fakeTableView, numberOfRowsInSection: 0)
        let cell = dataSource.tableView(fakeTableView, cellForRowAtIndexPath: expectedIndexPath)
        let header = dataSource.tableView?(fakeTableView, titleForHeaderInSection: 0)
        let footer = dataSource.tableView?(fakeTableView, titleForFooterInSection: 0)

        // THEN: we receive the expected return values
        XCTAssertNotNil(numSections, "Number of sections should not be nil")
        XCTAssertEqual(numSections!, dataSourceProvider.sections.count, "Data source should return expected number of sections")

        XCTAssertEqual(numRows, section0.count, "Data source should return expected number of rows for section 0")

        XCTAssertNotNil(cell.reuseIdentifier, "Cell reuse identifier should not be nil")
        XCTAssertEqual(cell.reuseIdentifier!, fakeReuseId, "Data source should return cells with the expected identifier")

        XCTAssertNotNil(header, "Header should not be nil")
        XCTAssertNotNil(section0.headerTitle, "Section 0 header title should not be nil")
        XCTAssertEqual(header!, section0.headerTitle!, "Data source should return expected header title")

        XCTAssertNotNil(footer, "Footer should not be nil")
        XCTAssertNotNil(section0.footerTitle, "Section 0 footer title should not be nil")
        XCTAssertEqual(footer!, section0.footerTitle!, "Data source should return expected footer title")

        // THEN: the tableView calls `dequeueReusableCellWithIdentifier`
        // THEN: the cell factory calls its `ConfigurationHandler`
        waitForExpectationsWithTimeout(DefaultTimeout, handler: { (error) -> Void in
            XCTAssertNil(error, "Expectations should not error")
        })
    }

    func test_ThatTableViewDataSource_ReturnsExpectedData_ForMultipleSections() {

        // GIVEN: some table view sections
        let section0 = TableViewSection(items: FakeTableModel(), FakeTableModel(), FakeTableModel(), headerTitle: "Header", footerTitle: "Footer")
        let section1 = TableViewSection(items: FakeTableModel(), headerTitle: "Header Title")
        let section2 = TableViewSection(items: FakeTableModel(), FakeTableModel(), footerTitle: "Footer")
        let section3 = TableViewSection(items: FakeTableModel(), FakeTableModel(), FakeTableModel(), FakeTableModel(), FakeTableModel())
        let allSections = [section0, section1, section2, section3]

        var factoryExpectation = expectationWithDescription("factory_\(__FUNCTION__)")

        // GIVEN: a cell factory
        let factory = TableViewCellFactory(reuseIdentifier: fakeReuseId) { (cell: FakeTableCell, model: FakeTableModel, tableView: UITableView, indexPath: NSIndexPath) -> FakeTableCell in
            XCTAssertEqual(cell.reuseIdentifier!, self.fakeReuseId, "Dequeued cell should have expected identifier")
            XCTAssertEqual(tableView, self.fakeTableView, "TableView should equal the tableView for the data source")

            XCTAssertEqual(model, allSections[indexPath.section][indexPath.row], "Model object should equal expected value")

            factoryExpectation.fulfill()

            return cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider = TableViewDataSourceProvider(sections: allSections, cellFactory: factory, tableView: fakeTableView)
        let dataSource = dataSourceProvider.dataSource

        // WHEN: we call the table view data source methods
        let numSections = dataSource.numberOfSectionsInTableView?(fakeTableView)

        // THEN: we receive the expected return values
        XCTAssertNotNil(numSections, "Number of sections should not be nil")
        XCTAssertEqual(numSections!, dataSourceProvider.sections.count, "Data source should return expected number of sections")

        for sectionIndex in 0..<dataSourceProvider.sections.count {

            for rowIndex in 0..<dataSourceProvider[sectionIndex].items.count {

                let expectationName = "\(__FUNCTION__)_\(sectionIndex)_\(rowIndex)"
                fakeTableView.dequeueCellExpectation = expectationWithDescription(dequeueCellExpectationName + expectationName)

                // WHEN: we call the table view data source methods
                let numRows = dataSource.tableView(fakeTableView, numberOfRowsInSection: sectionIndex)
                let header = dataSource.tableView?(fakeTableView, titleForHeaderInSection: sectionIndex)
                let footer = dataSource.tableView?(fakeTableView, titleForFooterInSection: sectionIndex)

                let cell = dataSource.tableView(fakeTableView, cellForRowAtIndexPath: NSIndexPath(forRow: rowIndex, inSection: sectionIndex))

                // THEN: we receive the expected return values
                XCTAssertEqual(numRows, dataSourceProvider[sectionIndex].count, "Data source should return expected number of rows for section \(sectionIndex)")

                XCTAssertNotNil(cell.reuseIdentifier, "Cell reuse identifier should not be nil")
                XCTAssertEqual(cell.reuseIdentifier!, fakeReuseId, "Data source should return cells with the expected identifier")

                XCTAssertTrue(header == dataSourceProvider[sectionIndex].headerTitle, "Data source should return expected header title for section \(sectionIndex)")
                XCTAssertTrue(footer == dataSourceProvider[sectionIndex].footerTitle, "Data source should return expected footer title for section \(sectionIndex)")

                // THEN: the tableView calls `dequeueReusableCellWithIdentifier`
                // THEN: the cell factory calls its `ConfigurationHandler`
                waitForExpectationsWithTimeout(DefaultTimeout, handler: { (error) -> Void in
                    XCTAssertNil(error, "Expectations should not error")
                })
                
                // reset expectation names for next loop, ignore last item
                if !(sectionIndex == dataSourceProvider.sections.count - 1 && rowIndex == dataSourceProvider[sectionIndex].count - 1) {
                    factoryExpectation = expectationWithDescription("factory_" + expectationName)
                }
            }
        }
    }
    
}
