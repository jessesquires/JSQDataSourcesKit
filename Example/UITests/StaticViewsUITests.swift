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

import XCTest

final class StaticViewsUITests: XCTestCase {

    private let numberOfCellsInStaticTableView: Int = 9
    private let numberOfCellsInStaticCollectionView: Int = 10

    private let staticTableViewMenuItem = XCUIApplication().tables.element.cells.element(boundBy: 0)
    private let staticCollectionViewMenuItem = XCUIApplication().tables.element.cells.element(boundBy: 1)

    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        app.launch()
    }

    func test_ThatStaticTableView_LoadsItsCells() {
        // GIVEN: a static table view
        // WHEN: we choose to present the static table view
        staticTableViewMenuItem.tap()

        // THEN: the number of cells loaded matches the number of cells expected
        let table = app.tables[Identifiers.staticTableView.rawValue]
        let countTableCells = countElements(ofType: .cell, inView: table) { $0.identifier }

        XCTAssertEqual(countTableCells,
                       numberOfCellsInStaticTableView,
                       "The number of cells loaded should be the same as the number of cells expected")
    }

    func test_ThatStaticCollectionView_loadsItsCells() {
        // GIVEN: a static collection view
        // WHEN: we choose to present the static collection view
        staticCollectionViewMenuItem.tap()

        // THEN: the number of cells loaded matches the number of cells expected
        let collection = app.collectionViews[Identifiers.staticCollectionView.rawValue]
        let countCollectionCells = countElements(ofType: .cell, inView: collection) { $0.identifier }

        XCTAssertEqual(countCollectionCells,
                       numberOfCellsInStaticCollectionView,
                       "The number of cells loaded should be the same as the number of cells expected")
    }
}
