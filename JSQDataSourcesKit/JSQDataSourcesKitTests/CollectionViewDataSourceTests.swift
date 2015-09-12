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
//  Copyright (c) 2015 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation
import UIKit
import XCTest

import JSQDataSourcesKit


class CollectionViewDataSourceTests: XCTestCase {

    let fakeCellReuseId = "fakeCellId"
    let fakeSupplementaryViewReuseId = "fakeSupplementaryId"

    private let fakeCollectionView = FakeCollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 600), collectionViewLayout: FakeFlowLayout())
    let dequeueCellExpectationName = "collectionview_dequeue_cell_expectation"
    let dequeueSupplementaryViewExpectationName = "collectionview_dequeue_supplementaryview_expectation"

    override func setUp() {
        super.setUp()

        fakeCollectionView.registerClass(FakeCollectionCell.self, forCellWithReuseIdentifier: fakeCellReuseId)
        fakeCollectionView.registerClass(FakeCollectionSupplementaryView.self, forSupplementaryViewOfKind: FakeSupplementaryViewKind, withReuseIdentifier: fakeSupplementaryViewReuseId)
    }

    func test_ThatCollectionViewDataSource_ReturnsExpectedData_ForSingleSection() {

        // GIVEN: a single CollectionViewSection with data items
        let expectedModel = FakeCollectionModel()
        let expectedIndexPath = NSIndexPath(forRow: 3, inSection: 0)

        let section0 = CollectionViewSection(dataItems: [FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel(), expectedModel, FakeCollectionModel()])
        let allSections = [section0]

        let cellFactoryExpectation = self.expectationWithDescription("\(__FUNCTION__)")
        self.fakeCollectionView.dequeueCellExpectation = self.expectationWithDescription(self.dequeueCellExpectationName + "\(__FUNCTION__)")

        // GIVEN: a cell factory
        let factory = CollectionViewCellFactory(reuseIdentifier: self.fakeCellReuseId) { (cell: FakeCollectionCell, model: FakeCollectionModel, view: UICollectionView, indexPath: NSIndexPath) -> FakeCollectionCell in
            XCTAssertEqual(cell.reuseIdentifier!, self.fakeCellReuseId, "Dequeued cell should have expected identifier")
            XCTAssertEqual(view, self.fakeCollectionView, "CollectionView should equal the collectionView for the data source")

            XCTAssertEqual(model, expectedModel, "Model object should equal expected value")
            XCTAssertEqual(indexPath, expectedIndexPath, "IndexPath should equal expected value")

            cellFactoryExpectation.fulfill()

            return cell
        }

        // GIVEN: a data source provider
        typealias CellFactory = CollectionViewCellFactory<FakeCollectionCell, FakeCollectionModel>
        typealias SupplementaryViewFactory = CollectionSupplementaryViewFactory<FakeCollectionSupplementaryView, FakeCollectionModel>
        typealias Section = CollectionViewSection<FakeCollectionModel>
        typealias Provider = CollectionViewDataSourceProvider<FakeCollectionModel, Section, CellFactory, SupplementaryViewFactory>

        let dataSourceProvider: Provider = CollectionViewDataSourceProvider(sections: allSections, cellFactory: factory, collectionView: self.fakeCollectionView)
        let dataSource = dataSourceProvider.dataSource

        // WHEN: we call the collection view data source methods
        let numSections = dataSource.numberOfSectionsInCollectionView?(self.fakeCollectionView)
        let numRows = dataSource.collectionView(self.fakeCollectionView, numberOfItemsInSection: 0)
        let cell = dataSource.collectionView(self.fakeCollectionView, cellForItemAtIndexPath: expectedIndexPath)

        // THEN: we receive the expected return values
        XCTAssertNotNil(numSections, "Number of sections should not be nil")
        XCTAssertEqual(numSections!, dataSourceProvider.sections.count, "Data source should return expected number of sections")

        XCTAssertEqual(numRows, section0.count, "Data source should return expected number of rows for section 0")

        XCTAssertEqual(cell.reuseIdentifier!, self.fakeCellReuseId, "Data source should return cells with the expected identifier")

        // THEN: the collectionView calls `dequeueReusableCellWithReuseIdentifier`
        // THEN: the cell factory calls its `ConfigurationHandler`
        self.waitForExpectationsWithTimeout(1, handler: { (error) -> Void in
            XCTAssertNil(error, "Expectation should not error")
        })
    }

    func test_ThatCollectionViewDataSource_ReturnsExpectedData_ForMultipleSections() {

        // GIVEN: some collection view sections
        let section0 = CollectionViewSection(dataItems: [FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel()])
        let section1 = CollectionViewSection(dataItems: [FakeCollectionModel(), FakeCollectionModel()])
        let section2 = CollectionViewSection(dataItems: [FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel()])
        let allSections = [section0, section1, section2]

        var cellFactoryExpectation = self.expectationWithDescription("cell_factory_\(__FUNCTION__)")

        // GIVEN: a cell factory
        let cellFactory = CollectionViewCellFactory(reuseIdentifier: self.fakeCellReuseId) { (cell: FakeCollectionCell, model: FakeCollectionModel, view: UICollectionView, indexPath: NSIndexPath) -> FakeCollectionCell in
            XCTAssertEqual(cell.reuseIdentifier!, self.fakeCellReuseId, "Dequeued cell should have expected identifier")
            XCTAssertEqual(view, self.fakeCollectionView, "CollectionView should equal the collectionView for the data source")

            XCTAssertEqual(model, allSections[indexPath.section][indexPath.item], "Model object should equal expected value")

            cellFactoryExpectation.fulfill()

            return cell
        }

        var supplementaryFactoryExpectation = self.expectationWithDescription("supplementary_factory_\(__FUNCTION__)")

        // GIVEN: a supplementary view factory
        let supplementaryViewFactory = CollectionSupplementaryViewFactory(reuseIdentifier: self.fakeSupplementaryViewReuseId)
            { (view: FakeCollectionSupplementaryView, model: FakeCollectionModel, kind: String, collectionView: UICollectionView, indexPath: NSIndexPath) -> FakeCollectionSupplementaryView in
                XCTAssertEqual(view.reuseIdentifier!, self.fakeSupplementaryViewReuseId, "Dequeued supplementary view should have expected identifier")
                XCTAssertEqual(collectionView, self.fakeCollectionView, "CollectionView should equal the collectionView for the data source")

                XCTAssertEqual(model, allSections[indexPath.section][indexPath.item], "Model object should equal expected value")

                supplementaryFactoryExpectation.fulfill()

                return view
        }

        // GIVEN: a data source provider
        let dataSourceProvider = CollectionViewDataSourceProvider(sections: allSections, cellFactory: cellFactory, supplementaryViewFactory: supplementaryViewFactory, collectionView: self.fakeCollectionView)
        let dataSource = dataSourceProvider.dataSource

        // WHEN: we call the collection view data source methods
        let numSections = dataSource.numberOfSectionsInCollectionView?(self.fakeCollectionView)

        // THEN: we receive the expected return values
        XCTAssertNotNil(numSections, "Number of sections should not be nil")
        XCTAssertEqual(numSections!, dataSourceProvider.sections.count, "Data source should return expected number of sections")

        for sectionIndex in 0..<dataSourceProvider.sections.count {

            for rowIndex in 0..<dataSourceProvider[sectionIndex].dataItems.count {

                let expectationName = "\(__FUNCTION__)_\(sectionIndex)_\(rowIndex)"
                self.fakeCollectionView.dequeueCellExpectation = self.expectationWithDescription(self.dequeueCellExpectationName + expectationName)
                self.fakeCollectionView.dequeueSupplementaryViewExpectation = self.expectationWithDescription(self.dequeueSupplementaryViewExpectationName + expectationName)

                let indexPath = NSIndexPath(forItem: rowIndex, inSection: sectionIndex)

                // WHEN: we call the collection view data source methods
                let numRows = dataSource.collectionView(self.fakeCollectionView, numberOfItemsInSection: sectionIndex)
                let cell = dataSource.collectionView(self.fakeCollectionView, cellForItemAtIndexPath: indexPath)
                let supplementaryView = dataSource.collectionView?(self.fakeCollectionView, viewForSupplementaryElementOfKind: FakeSupplementaryViewKind, atIndexPath: indexPath)

                // THEN: we receive the expected return values
                XCTAssertEqual(numRows, dataSourceProvider[sectionIndex].count, "Data source should return expected number of rows for section \(sectionIndex)")

                XCTAssertEqual(cell.reuseIdentifier!, self.fakeCellReuseId, "Data source should return cells with the expected identifier")

                XCTAssertNotNil(supplementaryView, "Supplementary view should not be nil")
                XCTAssertEqual(supplementaryView!.reuseIdentifier!, self.fakeSupplementaryViewReuseId, "Data source should return supplementary views with the expected identifier")

                // THEN: the collectionView calls `dequeueReusableCellWithReuseIdentifier`
                // THEN: the cell factory calls its `ConfigurationHandler`
                // THEN: the supplementary view factory calls its `ConfigurationHandler`
                self.waitForExpectationsWithTimeout(1, handler: { (error) -> Void in
                    XCTAssertNil(error, "Expections should not error")
                })
                
                // reset expectation names for next loop, ignore last item
                if !(sectionIndex == dataSourceProvider.sections.count - 1 && rowIndex == dataSourceProvider[sectionIndex].count - 1) {
                    cellFactoryExpectation = self.expectationWithDescription("cell_factory_" + expectationName)
                    supplementaryFactoryExpectation = self.expectationWithDescription("supplementary_factory_" + expectationName)
                }
            }
        }
        
    }
    
}
