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

final class FetchedResultsViewsUITests: XCTestCase {

    private let numberOfItemsAdded = 5

    private let fetchedResultsTableViewMenuItem = XCUIApplication().tables[Identifiers.mainTableView.rawValue].cells.element(boundBy: 3)
    private let fetchedResultsCollectionViewMenuItem = XCUIApplication().tables[Identifiers.mainTableView.rawValue].cells.element(boundBy: 4)

    let app = XCUIApplication()

    let getCollectionView = {
        XCUIApplication().collectionViews[Identifiers.fetchedResultsCollectionView.rawValue]
    }

    let getTableView = {
        XCUIApplication().tables[Identifiers.fetchedResultsTableView.rawValue]
    }

    let getDeleteButton = {
        XCUIApplication().toolbars["Toolbar"].buttons["Delete"]
    }

    let getAddButton = {
        XCUIApplication().toolbars["Toolbar"].buttons["Add"]
    }

    let getShareButton = {
        XCUIApplication().toolbars["Toolbar"].buttons["Share"]
    }

    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        app.launch()

        // Delete everything from Core Data before each test.
        getDeleteButton().tap()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_ThatAddButton_CausesAddingCellToFetchedResultsViews() {
        fetchedResultsTableViewMenuItem.tap()
        let table = getTableView()

        // GIVEN: initial number of cells in the table
        var numberOfCellsBeforeInTable = countElements(ofType: .cell, inView: table) { $0.identifier }

        navigateBack()
        fetchedResultsCollectionViewMenuItem.tap()
        let collection = getCollectionView()

        // GIVEN: initial number of cells in the collection view
        var numberOfCellsBeforeInCollection = countElements(ofType: .cell, inView: collection) { $0.identifier }

        XCTAssertEqual(numberOfCellsBeforeInTable,
                       numberOfCellsBeforeInCollection,
                       "Table and Collection views should be syncronized")

        navigateBack()

        (0..<3).forEach { _ in
            // WHEN: we tap "add" to add items to Core Data
            getAddButton().tap()

            fetchedResultsTableViewMenuItem.tap()

            // THEN: new items get added to the table
            let numberOfCellsAfterInTable = countElements(ofType: .cell, inView: table) { $0.identifier }
            XCTAssertEqual(numberOfCellsAfterInTable,
                           numberOfCellsBeforeInTable + numberOfItemsAdded,
                           "\"Add\" button should cause adding new cells")

            numberOfCellsBeforeInTable = numberOfCellsAfterInTable
            navigateBack()
            fetchedResultsCollectionViewMenuItem.tap()

            // THEN: new items get added to the collection
            let numberOfCellsAfterInCollection = countElements(ofType: .cell, inView: collection) { $0.identifier }
            XCTAssertEqual(numberOfCellsAfterInCollection,
                           numberOfCellsBeforeInCollection + numberOfItemsAdded,
                           "\"Add\" button should cause adding new cells")

            numberOfCellsBeforeInCollection = numberOfCellsAfterInCollection
            navigateBack()
        }
    }

    func test_ThatDeleteButton_CausesRemovingCellsFromFetchedResultsViews() {
        // GIVEN: some entries added to Core Data
        (0..<3).forEach { _ in
            getAddButton().tap()
        }

        // WHEN: we view the table
        fetchedResultsTableViewMenuItem.tap()

        // THEN: the table should have items
        let table = getTableView()
        XCTAssertGreaterThan(table.cells.count, 0, "\"Add\" button should cause adding some new cells")

        navigateBack()

        // WHEN: we view the collection
        fetchedResultsCollectionViewMenuItem.tap()

        // THEN: the collection should have items
        let collection = getCollectionView()
        XCTAssertGreaterThan(collection.cells.count, 0, "\"Add\" button should cause adding some new cells")

        navigateBack()

        // WHEN: we tap the "Delete" button
        getDeleteButton().tap()

        // THEN: the table view must be empty
        fetchedResultsTableViewMenuItem.tap()
        XCTAssertEqual(table.cells.count, 0, "\"Delete\" button should cause removing all the cells")

        navigateBack()

        // THEN: the collection view must be empty
        fetchedResultsCollectionViewMenuItem.tap()
        XCTAssertEqual(collection.cells.count, 0, "\"Delete\" button should cause removing all the cells")
    }

    func test_ThatActionButton_AddNewOption_AddsCell() {
        fetchedResultsCollectionViewMenuItem.tap()

        // GIVEN: initial empty collection
        let collection = getCollectionView()

        // WHEN: "Add new" option is tapped
        getShareButton().tap()
        app.sheets["You must select items first"].buttons["Add new"].tap()

        // THEN: one new cell appears in the collection view
        let numberOfCellsInCollection = countElements(ofType: .cell, inView: collection) { $0.identifier }
        XCTAssertEqual(numberOfCellsInCollection, 1, "\"Add new\" should add one new cell")

        navigateBack()
        getDeleteButton().tap()
        fetchedResultsTableViewMenuItem.tap()

        // GIVEN: initial empty table
        let table = getTableView()

        // WHEN: "Add new" option is tapped
        getShareButton().tap()
        app.sheets["You must select items first"].buttons["Add new"].tap()

        // THEN: one new cell appears in the table view
        let numberOfCellsInTable = countElements(ofType: .cell, inView: table) { $0.identifier }
        XCTAssertEqual(numberOfCellsInTable, 1, "\"Add new\" should add one new cell")
    }

    func test_ThatActionButton_DeleteSelectedOption_RemovesSelectedCells() {
        let numberOfCellsToDelete = 3

        // GIVEN: some entries added into Core Data
        getAddButton().tap()
        fetchedResultsTableViewMenuItem.tap()

        // GIVEN: initial number of cells in the table view
        let table = getTableView()
        let numberOfCellsBeforeInTable = countElements(ofType: .cell, inView: table) { $0.identifier }

        // WHEN: we select some of them
        tapOn(numberOfCellsToDelete, hittableElementsOfType: .cell, inView: table)

        // WHEN: "Delete selected" option is tapped
        getShareButton().tap()
        app.sheets["You must select items first"].buttons["Delete selected"].tap()

        // THEN: Selected cells disappear
        let numberOfCellsAfterInTable = countElements(ofType: .cell, inView: table) { $0.identifier }
        XCTAssertEqual(numberOfCellsAfterInTable,
                       numberOfCellsBeforeInTable - numberOfCellsToDelete,
                       "\"Delete selected\" should remove \(numberOfCellsToDelete) cells.")

        navigateBack()

        // GIVEN: more entries added into Core Data
        getAddButton().tap()

        fetchedResultsCollectionViewMenuItem.tap()

        // GIVEN: initial number of cells in the collection
        let collection = getCollectionView()
        let numberOfCellsBeforeInCollection = countElements(ofType: .cell, inView: collection) { $0.identifier }

        // WHEN: we select some of them
        tapOn(numberOfCellsToDelete, hittableElementsOfType: .cell, inView: collection)

        // WHEN: "Delete selected" option is tapped
        getShareButton().tap()
        app.sheets["You must select items first"].buttons["Delete selected"].tap()

        // THEN: Selected cells disappear
        let numberOfCellsAfterInCollection = countElements(ofType: .cell, inView: collection) { $0.identifier }
        XCTAssertEqual(numberOfCellsAfterInCollection,
                       numberOfCellsBeforeInCollection - numberOfCellsToDelete,
                       "\"Delete selected\" should remove \(numberOfCellsToDelete) cells.")
    }
}

// swiftlint:enable trailing_closure
