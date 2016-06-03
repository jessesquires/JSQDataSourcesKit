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

final class StaticViewsUITests: XCTestCase {
    
    private let numberOfCellsInStaticTableView: UInt = 9
    
    private let numberOfCellsInStaticCollectionView: UInt = 10
        
    override func setUp() {
        super.setUp()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }
    
    // MARK: - Test methods
    func test_ThatStaticTableView_LoadsItsCells() {
        
        // GIVEN: a table currently presenting on the screen
        let table = XCUIApplication().tables.element
        
        // WHEN: we choose to present the static table view (by tapping the first cell in the initial view)
        table.cells.elementBoundByIndex(0).tap()
        
        // THEN: the number of cells loaded matches the number of cells expected
        XCTAssertEqual(table.cells.count, numberOfCellsInStaticTableView,
                       "Number of cells loaded should be the same as the number of cells expected")
        
        // THEN: all of the sections are present (we test this by checking if their headers exist,
        // since sections themselves are not accessible and therefore not visible to UI tests)
        XCTAssertTrue(table.otherElements["FIRST"].exists, "Section FIRST sould be present")
        XCTAssertTrue(table.otherElements["SECOND"].exists, "Section SECOND sould be present")
        XCTAssertTrue(table.otherElements["THIRD"].exists, "Section THIRD sould be present")
    }
    
    func test_ThatStaticCollectionView_loadsItsCells() {
        // GIVEN: a collection view currently presenting on the screen
        let collectionView = XCUIApplication().collectionViews.element
        
        // WHEN: we choose to present the static collection view (by tapping the second cell in the initial view) and scroll it
        XCUIApplication().tables.element.cells.elementBoundByIndex(1).tap()
        
        // Because counting cells is very non-trivial, having in mind that the number of cells currently presented on the screen
        // may differ from an actual number of cells overall, it is better to grab their text labels into a set, then scroll,
        // then again grab their labels into a set, then unite those sets and count the resulting set.
        var everPresentedCells = presentingCellsTextLabels(inCollectionView: collectionView)
        collectionView.swipeUp()
        everPresentedCells = everPresentedCells.union(presentingCellsTextLabels(inCollectionView: collectionView))
        
        // THEN: the number of cells loaded matches the number of cells expected
        XCTAssertEqual(UInt(everPresentedCells.count), numberOfCellsInStaticCollectionView,
                       "Number of cells loaded should be the same as the number of cells expected")
        
        // THEN: all of the sections are present (we test this by checking if their headers exist,
        // since sections themselves are not accessible and therefore not visible to UI tests)
        XCTAssertTrue(collectionView.staticTexts["Section 2"].exists, "Section 2 sould be present")
        collectionView.swipeDown()
        XCTAssertTrue(collectionView.staticTexts["Section 0"].exists, "Section 0 sould be present")
        XCTAssertTrue(collectionView.staticTexts["Section 1"].exists, "Section 1 sould be present")
    }
    
    
    // MARK: - Helping methods
    func presentingCellsTextLabels(inCollectionView collectionView: XCUIElement) -> Set<String> {
        
        var set = Set<String>()
        
        let numberOfCurrentlyPresentedSells = collectionView.cells.count
        for cellIndex in 0..<numberOfCurrentlyPresentedSells {
            set.insert(collectionView.cells.elementBoundByIndex(cellIndex).staticTexts.element.label)
        }
        
        return set
    }
}
