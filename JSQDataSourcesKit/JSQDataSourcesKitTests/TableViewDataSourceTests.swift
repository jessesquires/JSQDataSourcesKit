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

func ==(lhs: FakeTableModel, rhs: FakeTableModel) -> Bool {
    return lhs.name == rhs.name
}

struct FakeTableModel: Equatable {
    let name = NSProcessInfo.processInfo().globallyUniqueString
}


class FakeTableCell: UITableViewCell { }


class FakeTableView: UITableView {

    var dequeueCellExpectation: XCTestExpectation?
    var fakeCell: FakeTableCell?

    override func dequeueReusableCellWithIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> AnyObject {
        self.dequeueCellExpectation?.fulfill()
        return self.fakeCell!
    }
}


class TableViewDataSourceTests: XCTestCase {

    var fakeModel = FakeTableModel()

    var fakeReuseId = "fakeCellId"

    var fakeCell: FakeTableCell {
        get {
            return FakeTableCell(style: .Default, reuseIdentifier: self.fakeReuseId)
        }
    }

    var fakeTableView = FakeTableView(frame: CGRect(x: 0, y: 0, width: 320, height: 600), style: .Plain)

    var fakeIndexPath: NSIndexPath!


    override func setUp() {
        super.setUp()

        self.fakeTableView.registerClass(FakeTableCell.self, forCellReuseIdentifier: self.fakeReuseId)
        self.fakeTableView.dequeueCellExpectation = self.expectationWithDescription("dequeue cell expectation")
        self.fakeTableView.fakeCell = self.fakeCell

        self.fakeIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testTableViewDataSource() {

        // GIVEN: a cell factory
        let factory = TableViewCellFactory(reuseIdentifier: self.fakeReuseId) { (cell: FakeTableCell, model: FakeTableModel, tableView: UITableView, indexPath: NSIndexPath) -> FakeTableCell in
            XCTAssertEqual(cell, self.fakeTableView.fakeCell!)
            XCTAssertEqual(model, self.fakeModel)
            XCTAssertEqual(tableView, self.fakeTableView)
            XCTAssertEqual(indexPath, self.fakeIndexPath)
            return cell
        }

        // GIVEN: sections with data items
        let section0 = TableViewSection(dataItems: [self.fakeModel], headerTitle: nil, footerTitle: nil)
        let allSections = [section0]

        // GIVEN: a data source provider
        let dataSourceProvider = TableViewDataSourceProvider(sections: allSections, cellFactory: factory, tableView: self.fakeTableView)
        let dataSource = dataSourceProvider.dataSource

        // WHEN: we call the table view data source methods

        // THEN: we receive the expected return values
        if let sections = dataSource.numberOfSectionsInTableView?(self.fakeTableView) {
            XCTAssertEqual(sections, 1)
        }
        else {
            XCTFail("")
        }

        let cell = dataSource.tableView(self.fakeTableView, cellForRowAtIndexPath: self.fakeIndexPath)
        XCTAssertEqual(cell, self.fakeTableView.fakeCell!)

        self.waitForExpectationsWithTimeout(1, handler: { (error) -> Void in
            XCTAssertNil(error)
        })

    }

}
