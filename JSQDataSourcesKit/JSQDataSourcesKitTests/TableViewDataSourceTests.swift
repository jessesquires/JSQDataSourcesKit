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

private struct FakeTableModel: Equatable {
    let name = NSProcessInfo.processInfo().globallyUniqueString
}


private func ==(lhs: FakeTableModel, rhs: FakeTableModel) -> Bool {
    return lhs.name == rhs.name
}


private class FakeTableCell: UITableViewCell { }


private class FakeTableView: UITableView {

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
    
    private let fakeTableView = FakeTableView(frame: CGRect(x: 0, y: 0, width: 320, height: 600), style: .Plain)
    let dequeueCellExpectationName = "tableview_dequeue_cell_expectation"

    override func setUp() {
        super.setUp()

        fakeTableView.registerClass(FakeTableCell.self, forCellReuseIdentifier: fakeReuseId)
    }

    override func tearDown() {
        super.tearDown()
    }


    // MARK: tests

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

    func test_ThatTableViewDataSourceProviderReturnsExpectedDataFromSubscript() {

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

    func test_ThatTableViewDataSourceProviderSetsExpectedDataAtSubscript() {

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

    func test_ThatTableViewDataSourceReturnsExpectedData_ForSingleSection() {

        // GIVEN: a single TableViewSection with data items
        let expectedModel = FakeTableModel()
        let expectedIndexPath = NSIndexPath(forRow: 2, inSection: 0)

        let section0 = TableViewSection(dataItems: [FakeTableModel(), FakeTableModel(), expectedModel, FakeTableModel(), FakeTableModel()], headerTitle: "Header", footerTitle: "Footer")
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
        let numSections = dataSource.numberOfSectionsInTableView?(self.fakeTableView)
        let numRows = dataSource.tableView(self.fakeTableView, numberOfRowsInSection: 0)
        let cell = dataSource.tableView(self.fakeTableView, cellForRowAtIndexPath: expectedIndexPath)
        let header = dataSource.tableView?(self.fakeTableView, titleForHeaderInSection: 0)
        let footer = dataSource.tableView?(self.fakeTableView, titleForFooterInSection: 0)

        // THEN: we receive the expected return values
        XCTAssertNotNil(numSections, "Number of sections should not be nil")
        XCTAssertEqual(numSections!, dataSourceProvider.sections.count, "Data source should return expected number of sections")

        XCTAssertEqual(numRows, section0.count, "Data source should return expected number of rows for section 0")

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

    func test_ThatTableViewDataSourceReturnsExpectedData_ForMultipleSections() {

        // GIVEN: some table view sections
        let section0 = TableViewSection(dataItems: [FakeTableModel(), FakeTableModel(), FakeTableModel()], headerTitle: "Header", footerTitle: "Footer")
        let section1 = TableViewSection(dataItems: [FakeTableModel()], headerTitle: "Header Title")
        let section2 = TableViewSection(dataItems: [FakeTableModel(), FakeTableModel()], footerTitle: "Footer")
        let section3 = TableViewSection(dataItems: [FakeTableModel(), FakeTableModel(), FakeTableModel(), FakeTableModel(), FakeTableModel()])
        let allSections = [section0, section1, section2, section3]

        var factoryExpectation = self.expectationWithDescription("factory_\(__FUNCTION__)")

        // GIVEN: a cell factory
        let factory = TableViewCellFactory(reuseIdentifier: self.fakeReuseId) { (cell: FakeTableCell, model: FakeTableModel, tableView: UITableView, indexPath: NSIndexPath) -> FakeTableCell in
            XCTAssertEqual(cell.reuseIdentifier!, self.fakeReuseId, "Dequeued cell should have expected identifier")
            XCTAssertEqual(tableView, self.fakeTableView, "TableView should equal the tableView for the data source")

            XCTAssertEqual(model, allSections[indexPath.section][indexPath.row], "Model object should equal expected value")

            factoryExpectation.fulfill()

            return cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider = TableViewDataSourceProvider(sections: allSections, cellFactory: factory, tableView: self.fakeTableView)
        let dataSource = dataSourceProvider.dataSource

        // WHEN: we call the table view data source methods
        let numSections = dataSource.numberOfSectionsInTableView?(self.fakeTableView)

        // THEN: we receive the expected return values
        XCTAssertNotNil(numSections, "Number of sections should not be nil")
        XCTAssertEqual(numSections!, dataSourceProvider.sections.count, "Data source should return expected number of sections")

        for sectionIndex in 0..<dataSourceProvider.sections.count {

            for rowIndex in 0..<dataSourceProvider[sectionIndex].dataItems.count {

                let expectationName = "\(__FUNCTION__)_\(sectionIndex)_\(rowIndex)"
                self.fakeTableView.dequeueCellExpectation = self.expectationWithDescription(self.dequeueCellExpectationName + expectationName)

                // WHEN: we call the table view data source methods
                let numRows = dataSource.tableView(self.fakeTableView, numberOfRowsInSection: sectionIndex)
                let header = dataSource.tableView?(self.fakeTableView, titleForHeaderInSection: sectionIndex)
                let footer = dataSource.tableView?(self.fakeTableView, titleForFooterInSection: sectionIndex)

                let cell = dataSource.tableView(self.fakeTableView, cellForRowAtIndexPath: NSIndexPath(forRow: rowIndex, inSection: sectionIndex))

                // THEN: we receive the expected return values
                XCTAssertEqual(numRows, dataSourceProvider[sectionIndex].count, "Data source should return expected number of rows for section \(sectionIndex)")

                XCTAssertNotNil(cell.reuseIdentifier, "Cell reuse identifier should not be nil")
                XCTAssertEqual(cell.reuseIdentifier!, self.fakeReuseId, "Data source should return cells with the expected identifier")

                XCTAssertTrue(header == dataSourceProvider[sectionIndex].headerTitle, "Data source should return expected header title for section \(sectionIndex)")
                XCTAssertTrue(footer == dataSourceProvider[sectionIndex].footerTitle, "Data source should return expected footer title for section \(sectionIndex)")

                // THEN: the tableView calls `dequeueReusableCellWithIdentifier`
                // THEN: the cell factory calls its `CellConfigurationHandler`
                self.waitForExpectationsWithTimeout(1, handler: { (error) -> Void in
                    XCTAssertNil(error, "Expectations should not error")
                })
                
                // reset expectation names for next loop, ignore last item
                if !(sectionIndex == dataSourceProvider.sections.count - 1 && rowIndex == dataSourceProvider[sectionIndex].count - 1) {
                    factoryExpectation = self.expectationWithDescription("factory_" + expectationName)
                }
            }
        }
    }
    
}
