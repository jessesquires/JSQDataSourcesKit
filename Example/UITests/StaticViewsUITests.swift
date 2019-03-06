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

// swiftlint:disable trailing_closure

import XCTest

final class StaticViewsUITests: XCTestCase {

    private let numberOfCellsInStaticTableView: Int = 9
    private let numberOfCellsInStaticCollectionView: Int = 10

    private let staticTableViewMenuItem = XCUIApplication().tables.element.cells.element(boundBy: 0)
    private let staticCollectionViewMenuItem = XCUIApplication().tables.element.cells.element(boundBy: 1)

    override func setUp() {
        super.setUp()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test.
        // Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }

    func test_ThatStaticTableView_LoadsItsCells() {

        // GIVEN: a table currently presenting on the screen
        let table = XCUIApplication().tables.element

        // WHEN: we choose to present the static table view
        staticTableViewMenuItem.tap()

        // THEN: the number of cells loaded matches the number of cells expected
        let countTableCells = countElements(ofType: XCUIElementType.cell,
                                            inView: table,
                                            byUniqueIdentifier: { $0.identifier })

        XCTAssertEqual(countTableCells,
                       numberOfCellsInStaticTableView,
                       "The number of cells loaded should be the same as the number of cells expected")
    }

    func test_ThatStaticCollectionView_loadsItsCells() {
        // GIVEN: a collection view currently presenting on the screen
        let collectionView = XCUIApplication().collectionViews.element

        // WHEN: we choose to present the static collection view
        staticCollectionViewMenuItem.tap()

        // THEN: the number of cells loaded matches the number of cells expected
        let countCollectionViewCells = countElements(ofType: XCUIElementType.cell,
                                                     inView: collectionView,
                                                     byUniqueIdentifier: { $0.identifier })

        XCTAssertEqual(countCollectionViewCells,
                       numberOfCellsInStaticCollectionView,
                       "The number of cells loaded should be the same as the number of cells expected")
    }
}

// swiftlint:enable trailing_closure
