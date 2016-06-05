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
    
    private let numberOfCellsInStaticTableView: Int = 9
    
    private let numberOfCellsInStaticCollectionView: Int = 10
        
    internal override func setUp() {
        super.setUp()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test.
        // Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }
    
    // MARK: - Test methods
    internal func test_ThatStaticTableView_LoadsItsCells() {
        
        // GIVEN: a table currently presenting on the screen
        let table = XCUIApplication().tables.element
        
        // WHEN: we choose to present the static table view (by tapping the first cell in the initial view)
        table.cells.elementBoundByIndex(0).tap()
        
        // THEN: the number of cells loaded matches the number of cells expected
        let countTableCells = countElements(ofType: .Cell,
                                            inView: table,
                                            byUniqueIdentifier: { $0.identifier })
        
        XCTAssertEqual(countTableCells, numberOfCellsInStaticTableView,
                       "The number of cells loaded should be the same as the number of cells expected")
    }
    
    internal func test_ThatStaticCollectionView_loadsItsCells() {
        // GIVEN: a collection view currently presenting on the screen
        let collectionView = XCUIApplication().collectionViews.element
        
        // WHEN: we choose to present the static collection view (by tapping the second cell in the initial view) and scroll it
        XCUIApplication().tables.element.cells.elementBoundByIndex(1).tap()
        
        // THEN: the number of cells loaded matches the number of cells expected
        let countCollectionViewCells = countElements(ofType: .Cell,
                                                     inView: collectionView,
                                                     byUniqueIdentifier: { $0.identifier })
        
        XCTAssertEqual(countCollectionViewCells, numberOfCellsInStaticCollectionView,
                       "The number of cells loaded should be the same as the number of cells expected")
    }
}
