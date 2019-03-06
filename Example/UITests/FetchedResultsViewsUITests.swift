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

final class FetchedResultsViewsUITests: XCTestCase {

    private let numberOfItemsAdded = 5

    private let fetchedResultsTableViewMenuItem = XCUIApplication().tables.element.cells.element(boundBy: 2)
    private let fetchedResultsCollectionViewMenuItem = XCUIApplication().tables.element.cells.element(boundBy: 3)

    override func setUp() {
        super.setUp()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test.
        // Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // Delete everything from Core Data before each test.
        XCUIApplication().toolbars.buttons["Delete"].tap()
    }

    override func tearDown() {

        // Return to the initial screen after each test.
        returnBackIfPossible()

        // Delete everything from Core Data after each test.
        XCUIApplication().toolbars.buttons["Delete"].tap()

        super.tearDown()
    }

    func test_ThatAddButton_CausesAddingCellToFetchedResultsViews() {

        let app = XCUIApplication()

        // GIVEN: a collection view currently presenting on the screen
        let collectionView = app.collectionViews.element
        // GIVEN: a table view currently presenting on the screen
        let table = app.tables.element

        fetchedResultsTableViewMenuItem.tap()

        // GIVEN: initial number of cells in the table
        var numberOfCellsBeforeInTable = countElements(ofType: XCUIElementType.cell,
                                                       inView: table,
                                                       byUniqueIdentifier: { $0.identifier })

        returnBackIfPossible()

        fetchedResultsCollectionViewMenuItem.tap()

        // GIVEN: initial number of cells in the collection view
        var numberOfCellsBeforeInCollectionView = countElements(ofType: XCUIElementType.cell,
                                                                inView: collectionView,
                                                                byUniqueIdentifier: { $0.identifier })

        XCTAssertEqual(numberOfCellsBeforeInTable,
                       numberOfCellsBeforeInCollectionView,
                       "Table and Collection views should be syncronized")

        returnBackIfPossible()

        // We try adding 3 times to make sure that the system behaves identically
        for _ in 0 ..< 3 {

            // WHEN: we tap the "Add" button
            app.toolbars.buttons["Add"].tap()

            fetchedResultsTableViewMenuItem.tap()

            // THEN: new items get added to the table
            let numberOfCellsAfterInTable = countElements(ofType: XCUIElementType.cell,
                                                          inView: table,
                                                          byUniqueIdentifier: { $0.identifier })
            XCTAssertEqual(numberOfCellsAfterInTable,
                           numberOfCellsBeforeInTable + numberOfItemsAdded,
                           "\"Add\" button should cause adding new cells")

            numberOfCellsBeforeInTable = numberOfCellsAfterInTable
            returnBackIfPossible()

            fetchedResultsCollectionViewMenuItem.tap()

            // THEN: new items get added to the collection view as well
            let numberOfCellsAfterInCollectionView = countElements(ofType: XCUIElementType.cell,
                                                                   inView: collectionView,
                                                                   byUniqueIdentifier: { $0.identifier })
            XCTAssertEqual(numberOfCellsAfterInCollectionView,
                           numberOfCellsBeforeInCollectionView + numberOfItemsAdded,
                           "\"Add\" button should cause adding new cells")

            numberOfCellsBeforeInCollectionView = numberOfCellsAfterInCollectionView
            returnBackIfPossible()
        }
    }

    func test_ThatDeleteButton_CausesRemovingCellsFromFetchedResultsViews() {

        let app = XCUIApplication()

        // GIVEN: a collection view currently presenting on the screen
        let collectionView = app.collectionViews.element
        // GIVEN: a table view currently presenting on the screen
        let table = app.tables.element

        // GIVEN: some entries added into Core Data
        for _ in 0 ..< 3 {
            app.toolbars.buttons["Add"].tap()
        }

        fetchedResultsTableViewMenuItem.tap()

        // Check if anything has appeared
        XCTAssertGreaterThan(table.cells.count, 0, "\"Add\" button should cause adding some new cells")

        returnBackIfPossible()

        fetchedResultsCollectionViewMenuItem.tap()

        // Check if anything has appeared there as well
        XCTAssertGreaterThan(collectionView.cells.count, 0, "\"Add\" button should cause adding some new cells")

        returnBackIfPossible()

        // WHEN: we tap the "Delete" button
        app.toolbars.buttons["Delete"].tap()

        fetchedResultsTableViewMenuItem.tap()

        // THEN: the table view must be empty
        XCTAssertEqual(table.cells.count, 0, "\"Delete\" button should cause removing all the cells")

        returnBackIfPossible()

        fetchedResultsCollectionViewMenuItem.tap()

        // THEN: the collection view must be empty as well
        XCTAssertEqual(collectionView.cells.count, 0, "\"Delete\" button should cause removing all the cells")
    }

    func test_ThatActionButton_AddNewOption_AddsCell() {

        let app = XCUIApplication()

        // GIVEN: a table view currently presenting on the screen
        let table = app.tables.element
        // GIVEN: a collection view currently presenting on the screen
        let collectionView = app.collectionViews.element

        // Test "Add New" in the collection view

        fetchedResultsCollectionViewMenuItem.tap()

        // GIVEN: initial number of cells in the collection view
        let numberOfCellsBeforeInCollectionView = countElements(ofType: XCUIElementType.cell,
                                                                inView: collectionView,
                                                                byUniqueIdentifier: { $0.identifier })

        // WHEN: "Add new" option is tapped
        app.toolbars.buttons["Share"].tap()
        app.sheets["You must select items first"].collectionViews.buttons["Add new"].tap()

        // THEN: a new cell appears in the collection view
        scrollOnStatusBarTap()
        let numberOfCellsAfterInCollectionView = countElements(ofType: XCUIElementType.cell,
                                                               inView: collectionView,
                                                               byUniqueIdentifier: { $0.identifier })

        XCTAssertEqual(numberOfCellsAfterInCollectionView,
                       numberOfCellsBeforeInCollectionView + 1,
                       "\"Add new\" should add one new cell")

        returnBackIfPossible()

        // Test "Add New" in the table view

        fetchedResultsTableViewMenuItem.tap()

        // GIVEN: initial number of cells in the table view
        let numberOfCellsBeforeInTable = countElements(ofType: XCUIElementType.cell,
                                                       inView: table,
                                                       byUniqueIdentifier: { $0.identifier })

        // WHEN: "Add new" option is tapped
        app.toolbars.buttons["Share"].tap()
        app.sheets["You must select items first"].collectionViews.buttons["Add new"].tap()

        // THEN: a new cell appears in the table view
        scrollOnStatusBarTap()
        let numberOfCellsAfterInTable = countElements(ofType: XCUIElementType.cell,
                                                      inView: table,
                                                      byUniqueIdentifier: { $0.identifier })

        XCTAssertEqual(numberOfCellsAfterInTable, numberOfCellsBeforeInTable + 1, "\"Add new\" should add one new cell")
    }

    func test_ThatActionButton_DeleteSelectedOption_RemovesSelectedCells() {

        let numberOfCellsToDelete = 3

        let app = XCUIApplication()

        // GIVEN: a table view currently presenting on the screen
        let table = app.tables.element
        // GIVEN: a collection view currently presenting on the screen
        let collectionView = app.collectionViews.element

        // Test "Delete selected" in the table view

        // GIVEN: some entries added into Core Data
        app.toolbars.buttons["Add"].tap()

        fetchedResultsTableViewMenuItem.tap()

        // GIVEN: initial number of cells in the table view
        let numberOfCellsBeforeInTable = countElements(ofType: XCUIElementType.cell,
                                                       inView: table,
                                                       byUniqueIdentifier: { $0.identifier })

        scrollOnStatusBarTap()

        // WHEN: we select some of them
        tapOn(numberOfCellsToDelete, hittableElementsOfType: .cell, inView: table)

        // WHEN: "Delete selected" option is tapped
        app.toolbars.buttons["Share"].tap()
        app.sheets["You must select items first"].collectionViews.buttons["Delete selected"].tap()

        // THEN: Selected cells disappear
        scrollOnStatusBarTap()
        let numberOfCellsAfterInTable = countElements(ofType: .cell,
                                                      inView: table,
                                                      byUniqueIdentifier: { $0.identifier })
        XCTAssertEqual(numberOfCellsAfterInTable,
                       numberOfCellsBeforeInTable - numberOfCellsToDelete,
                       "\"Delete selected\" should remove \(numberOfCellsToDelete) cells.")

        returnBackIfPossible()

        // Test "Delete selected" in the collection view

        // GIVEN: some more entries added into Core Data
        app.toolbars.buttons["Add"].tap()

        fetchedResultsCollectionViewMenuItem.tap()

        // GIVEN: initial number of cells in the table view
        let numberOfCellsBeforeInCollectionView = countElements(ofType: .cell,
                                                                inView: collectionView,
                                                                byUniqueIdentifier: { $0.identifier })
        scrollOnStatusBarTap()

        // WHEN: we select some of them
        tapOn(numberOfCellsToDelete, hittableElementsOfType: .cell, inView: collectionView)

        // WHEN: "Delete selected" option is tapped
        app.toolbars.buttons["Share"].tap()
        app.sheets["You must select items first"].collectionViews.buttons["Delete selected"].tap()

        // THEN: Selected cells disappear
        scrollOnStatusBarTap()
        let numberOfCellsAfterInCollectionView = countElements(ofType: .cell,
                                                               inView: collectionView,
                                                               byUniqueIdentifier: { $0.identifier })
        XCTAssertEqual(numberOfCellsAfterInCollectionView,
                       numberOfCellsBeforeInCollectionView - numberOfCellsToDelete,
                       "\"Delete selected\" should remove \(numberOfCellsToDelete) cells.")
    }
}

// swiftlint:enable trailing_closure
