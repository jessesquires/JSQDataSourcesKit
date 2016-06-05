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

import XCTest

final class FetchedResultsViewsUITests: XCTestCase {
    
    private let numberOfItemsAdded = 5
    
    internal override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test.
        // Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // Delete everything from Core Data before each test.
        XCUIApplication().toolbars.buttons["Delete"].tap()
    }
    
    internal override func tearDown() {
        
        let backButton = XCUIApplication().navigationBars.buttons.matchingIdentifier("Back").elementBoundByIndex(0)
        
        // Return to the initial screen after each test.
        if backButton.exists && backButton.hittable {
            backButton.tap()
        }
        
        // Delete everything from Core Data after each test.
        XCUIApplication().toolbars.buttons["Delete"].tap()
    }
  
    internal func test_ThatAddButton_CausesAddingCellToFetchedResultsViews() {
        
        let app = XCUIApplication()
        
        // GIVEN: a collection view currently presenting on the screen
        let collectionView = app.collectionViews.element
        // GIVEN: a table view currently presenting on the screen
        let table = app.tables.element
        
        // Go to fetch results table view
        table.cells.elementBoundByIndex(2).tap()
        
        // GIVEN: initial number of cells in the table
        var numberOfCellsBeforeInTable = countElements(ofType: .Cell, inView: table, byUniqueIdentifier: { $0.identifier })
        
        app.navigationBars.buttons.matchingIdentifier("Back").elementBoundByIndex(0).tap()
        
        // Go to fetch results collection view
        table.cells.elementBoundByIndex(3).tap()
        
        // GIVEN: initial number of cells in the collection view
        var numberOfCellsBeforeInCollectionView = countElements(ofType: .Cell, inView: collectionView,
                                                                 byUniqueIdentifier: { $0.identifier })
        
        XCTAssertEqual(numberOfCellsBeforeInTable, numberOfCellsBeforeInCollectionView,
                       "Table and Collection views should be syncronized")
        
        app.navigationBars.buttons.matchingIdentifier("Back").elementBoundByIndex(0).tap()

        
        // We try adding 3 times to make sure that the system behaves identically
        for _ in 0 ..< 3 {
            
            // WHEN: we tap the "Add" button
            app.toolbars.buttons["Add"].tap()
            
            // Go to fetch results table view
            table.cells.elementBoundByIndex(2).tap()
            
            // THEN: new items get added to the table
            let numberOfCellsAfterInTable = countElements(ofType: .Cell, inView: table, byUniqueIdentifier: { $0.identifier })
            XCTAssertEqual(numberOfCellsAfterInTable, numberOfCellsBeforeInTable + numberOfItemsAdded,
                           "\"Add\" button should cause adding new cells")
            
            
            numberOfCellsBeforeInTable = numberOfCellsAfterInTable
            app.navigationBars.buttons.matchingIdentifier("Back").elementBoundByIndex(0).tap()
            
            // Go to fetch results collection view
            table.cells.elementBoundByIndex(3).tap()
            
            // THEN: new items get added to the collection view as well
            let numberOfCellsAfterInCollectionView = countElements(ofType: .Cell, inView: collectionView,
                                                                   byUniqueIdentifier: { $0.identifier })
            XCTAssertEqual(numberOfCellsAfterInCollectionView, numberOfCellsBeforeInCollectionView + numberOfItemsAdded,
                           "\"Add\" button should cause adding new cells")
            
            
            numberOfCellsBeforeInTable = numberOfCellsAfterInTable
            numberOfCellsBeforeInCollectionView = numberOfCellsAfterInCollectionView
            app.navigationBars.buttons.matchingIdentifier("Back").elementBoundByIndex(0).tap()
        }
    }
    
    
    
    internal func test_ThatDeleteButton_CausesRemovingCellsFromFetchedResultsViews() {
        
        let app = XCUIApplication()
        
        // GIVEN: a collection view currently presenting on the screen
        let collectionView = app.collectionViews.element
        // GIVEN: a table view currently presenting on the screen
        let table = app.tables.element
        
        // GIVEN: some entries added into Core Data
        for _ in 0 ..< 3 {
            app.toolbars.buttons["Add"].tap()
        }
        
        // Go to fetch results table view
        table.cells.elementBoundByIndex(2).tap()
        
        // Check if anything appeared
        XCTAssertGreaterThan(table.cells.count, 0, "\"Add\" button should cause adding some new cells")
        
        app.navigationBars.buttons.matchingIdentifier("Back").elementBoundByIndex(0).tap()
        
        // Go to fetch results collection view
        table.cells.elementBoundByIndex(3).tap()
        
        // Check if anything appeared there as well
        XCTAssertGreaterThan(collectionView.cells.count, 0, "\"Add\" button should cause adding some new cells")
        
        app.navigationBars.buttons.matchingIdentifier("Back").elementBoundByIndex(0).tap()
        
        // WHEN: we tap the "Delete" button
        app.toolbars.buttons["Delete"].tap()
        
        // Go to fetch results table view
        table.cells.elementBoundByIndex(2).tap()
        
        // THEN: table view must be empty
        XCTAssertEqual(table.cells.count, 0, "\"Delete\" button should cause removing all the cells")
        
        app.navigationBars.buttons.matchingIdentifier("Back").elementBoundByIndex(0).tap()
        
        // Go to fetch results collection view
        table.cells.elementBoundByIndex(3).tap()
        
        // THEN: collection view must be empty as well
        XCTAssertEqual(collectionView.cells.count, 0, "\"Delete\" button should cause removing all the cells")
    }
    
    internal func test_That() {
    <#statements#>
    }
}
