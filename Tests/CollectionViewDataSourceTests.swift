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


final class CollectionViewDataSourceTests: TestCase {

    private let dequeueCellExpectationName = "collectionview_dequeue_cell_expectation"
    private let dequeueSupplementaryViewExpectationName = "collectionview_dequeue_supplementaryview_expectation"

    func test_ThatCollectionViewDataSource_ReturnsExpectedData_ForSingleSection() {

        // GIVEN: a single section with data items
        let expectedModel = FakeViewModel()
        let expectedIndexPath = NSIndexPath(forRow: 3, inSection: 0)

        let section0 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), expectedModel, FakeViewModel())
        let dataSource = DataSource([section0])

        let cellFactoryExpectation = expectationWithDescription(#function)
        collectionView.dequeueCellExpectation = expectationWithDescription(dequeueCellExpectationName + #function)

        // GIVEN: a cell factory
        let cellFactory = ViewFactory(reuseIdentifier: cellReuseId) { (cell, model: FakeViewModel?, type, collectionView, indexPath) -> FakeCollectionCell in
            XCTAssertEqual(cell.reuseIdentifier!, self.cellReuseId, "Dequeued cell should have expected identifier")
            XCTAssertEqual(model, expectedModel, "Model object should equal expected value")
            XCTAssertEqual(collectionView, self.collectionView, "CollectionView should equal the collectionView for the data source")
            XCTAssertEqual(indexPath, expectedIndexPath, "IndexPath should equal expected value")

            cellFactoryExpectation.fulfill()
            return cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider = DataSourceProvider(dataSource: dataSource, cellFactory: cellFactory, supplementaryFactory: cellFactory)
        let collectionViewDataSource = dataSourceProvider.collectionViewDataSource

        collectionView.dataSource = collectionViewDataSource

        // WHEN: we call the collection view data source methods
        let numSections = collectionViewDataSource.numberOfSectionsInCollectionView?(collectionView)
        let numRows = collectionViewDataSource.collectionView(collectionView, numberOfItemsInSection: 0)
        let cell = collectionViewDataSource.collectionView(collectionView, cellForItemAtIndexPath: expectedIndexPath)

        // THEN: we receive the expected return values
        XCTAssertNotNil(numSections, "Number of sections should not be nil")
        XCTAssertEqual(numSections!, dataSource.sections.count, "Data source should return expected number of sections")

        XCTAssertEqual(numRows, section0.count, "Data source should return expected number of rows for section 0")

        XCTAssertEqual(cell.reuseIdentifier!, cellReuseId, "Data source should return cells with the expected identifier")

        // THEN: the collectionView calls `dequeueReusableCellWithReuseIdentifier`
        // THEN: the cell factory calls its `ConfigurationHandler`
        waitForExpectationsWithTimeout(defaultTimeout, handler: { (error) -> Void in
            XCTAssertNil(error, "Expectation should not error")
        })
    }

    func test_ThatCollectionViewDataSource_ReturnsExpectedData_ForMultipleSections() {

        // GIVEN: some collection view sections
        let section0 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel())
        let section1 = Section(items: FakeViewModel(), FakeViewModel())
        let section2 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel())
        let dataSource = DataSource([section0, section1, section2])

        var cellFactoryExpectation = expectationWithDescription("cell_factory_\(#function)")

        // GIVEN: a cell factory
        let cellFactory = ViewFactory(reuseIdentifier: cellReuseId) { (cell, model: FakeViewModel?, type, collectionView, indexPath) -> FakeCollectionCell in
            XCTAssertEqual(cell.reuseIdentifier!, self.cellReuseId, "Dequeued cell should have expected identifier")
            XCTAssertEqual(model, dataSource[indexPath.section][indexPath.item], "Model object should equal expected value")
            XCTAssertEqual(collectionView, self.collectionView, "CollectionView should equal the collectionView for the data source")

            cellFactoryExpectation.fulfill()
            return cell
        }

        var supplementaryFactoryExpectation = expectationWithDescription("supplementary_factory_\(#function)")

        // GIVEN: a supplementary view factory
        let supplementaryViewFactory = ViewFactory(reuseIdentifier: supplementaryViewReuseId, type: .supplementaryView(kind: self.supplementaryViewReuseId))
        { (view, model: FakeViewModel?, type, collectionView, indexPath) -> FakeCollectionSupplementaryView in
            XCTAssertEqual(view.reuseIdentifier!, self.supplementaryViewReuseId, "Dequeued supplementary view should have expected identifier")
            XCTAssertEqual(model, dataSource[indexPath.section][indexPath.item], "Model object should equal expected value")
            XCTAssertEqual(type, ReusableViewType.supplementaryView(kind: fakeSupplementaryViewKind), "View type should have expected type")
            XCTAssertEqual(collectionView, self.collectionView, "CollectionView should equal the collectionView for the data source")

            supplementaryFactoryExpectation.fulfill()
            return view
        }

        // GIVEN: a data source provider
        let dataSourceProvider = DataSourceProvider(dataSource: dataSource,
                                                    cellFactory: cellFactory,
                                                    supplementaryFactory: supplementaryViewFactory)

        let collectionViewDataSource = dataSourceProvider.collectionViewDataSource

        collectionView.dataSource = collectionViewDataSource

        // WHEN: we call the collection view data source methods
        let numSections = collectionViewDataSource.numberOfSectionsInCollectionView?(collectionView)

        // THEN: we receive the expected return values
        XCTAssertNotNil(numSections, "Number of sections should not be nil")
        XCTAssertEqual(numSections!, dataSource.sections.count, "Data source should return expected number of sections")

        for sectionIndex in 0..<dataSource.sections.count {
            for rowIndex in 0..<dataSource[sectionIndex].items.count {

                let expectationName = "\(#function)_\(sectionIndex)_\(rowIndex)"
                collectionView.dequeueCellExpectation = expectationWithDescription(dequeueCellExpectationName + expectationName)
                collectionView.dequeueSupplementaryViewExpectation = expectationWithDescription(dequeueSupplementaryViewExpectationName + expectationName)

                let indexPath = NSIndexPath(forItem: rowIndex, inSection: sectionIndex)

                // WHEN: we call the collection view data source methods
                let numRows = collectionViewDataSource.collectionView(collectionView, numberOfItemsInSection: sectionIndex)
                let cell = collectionViewDataSource.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
                let supplementaryView = collectionViewDataSource.collectionView?(collectionView, viewForSupplementaryElementOfKind: fakeSupplementaryViewKind, atIndexPath: indexPath)

                // THEN: we receive the expected return values
                XCTAssertEqual(numRows, dataSource[sectionIndex].count, "Data source should return expected number of rows for section \(sectionIndex)")

                XCTAssertEqual(cell.reuseIdentifier!, cellReuseId, "Data source should return cells with the expected identifier")

                XCTAssertNotNil(supplementaryView, "Supplementary view should not be nil")
                XCTAssertEqual(supplementaryView!.reuseIdentifier!, supplementaryViewReuseId, "Data source should return supplementary views with the expected identifier")

                // THEN: the collectionView calls `dequeueReusableCellWithReuseIdentifier`
                // THEN: the cell factory calls its `ConfigurationHandler`

                // THEN: the collectionView calls `dequeueReusableSupplementaryViewOfKind`
                // THEN: the supplementary view factory calls its `ConfigurationHandler`
                waitForExpectationsWithTimeout(defaultTimeout, handler: { (error) -> Void in
                    XCTAssertNil(error, "Expections should not error")
                })

                // reset expectation names for next loop, ignore last item
                if !(sectionIndex == dataSource.sections.count - 1 && rowIndex == dataSource[sectionIndex].count - 1) {
                    cellFactoryExpectation = expectationWithDescription("cell_factory_" + expectationName)
                    supplementaryFactoryExpectation = expectationWithDescription("supplementary_factory_" + expectationName)
                }
            }
        }
    }
    
}
