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


class TitledSupplementaryViewFactoryTests: TestCase {

    private let dequeueCellExpectationName = "collectionview_dequeue_cell_expectation"
    private let dequeueSupplementaryViewExpectationName = "collectionview_dequeue_supplementaryview_expectation"

    override func setUp() {
        super.setUp()
        collectionView.registerClass(TitledSupplementaryView.self,
                                     forSupplementaryViewOfKind: fakeSupplementaryViewKind,
                                     withReuseIdentifier: TitledSupplementaryView.identifier)
    }

    func test_dataSource_returnsExpectedData_withTitledSupplementaryView() {
        // GIVEN: some collection view sections
        let section0 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel())
        let section1 = Section(items: FakeViewModel(), FakeViewModel())
        let section2 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel())
        let dataSource = DataSource([section0, section1, section2])

        var cellFactoryExpectation = expectationWithDescription("cell_factory")

        // GIVEN: a cell factory
        let cellFactory = ViewFactory(reuseIdentifier: cellReuseId) { (cell, model: FakeViewModel?, type, collectionView, indexPath) -> FakeCollectionCell in
            cellFactoryExpectation.fulfill()
            return cell
        }

        var titledViewDataConfigExpectation = expectationWithDescription("titledViewDataConfigExpectation")
        var titledViewStyleConfigExpectation = expectationWithDescription("titledViewStyleConfigExpectation")

        let supplementaryViewFactory = TitledSupplementaryViewFactory(dataConfigurator:
            { (view, item: FakeViewModel?, type, collectionView, indexPath) -> TitledSupplementaryView in
                XCTAssertEqual(view.reuseIdentifier!, TitledSupplementaryView.identifier, "Dequeued supplementary view should have expected identifier")
                XCTAssertEqual(type, ReusableViewType.supplementaryView(kind: fakeSupplementaryViewKind), "View type should have expected type")
                XCTAssertEqual(item, dataSource[indexPath.section][indexPath.item], "Model object should equal expected value")
                XCTAssertEqual(collectionView, self.collectionView, "CollectionView should equal the collectionView for the data source")

                titledViewDataConfigExpectation.fulfill()
                return view
            }, styleConfigurator: { (view) in
                titledViewStyleConfigExpectation.fulfill()
        })

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

                // THEN: we receive the expected return values for cells
                XCTAssertEqual(numRows, dataSource[sectionIndex].count, "Data source should return expected number of rows for section \(sectionIndex)")
                XCTAssertEqual(cell.reuseIdentifier!, cellReuseId, "Data source should return cells with the expected identifier")

                // THEN: we receive the expected return values for supplementary views
                XCTAssertNotNil(supplementaryView, "Supplementary view should not be nil")
                XCTAssertEqual(supplementaryView!.reuseIdentifier!, TitledSupplementaryView.identifier,
                               "Data source should return supplementary views with the expected identifier")

                // THEN: the collectionView calls `dequeueReusableCellWithReuseIdentifier`
                // THEN: the cell factory calls its `ConfigurationHandler`

                // THEN: the collectionView calls `dequeueReusableSupplementaryViewOfKind`
                // THEN: the supplementary view factory calls its `dataConfigurator`
                // THEN: the supplementary view factory calls its `styleConfigurator`
                waitForExpectationsWithTimeout(defaultTimeout, handler: { (error) -> Void in
                    XCTAssertNil(error, "Expections should not error")
                })

                // reset expectation names for next loop, ignore last item
                if !(sectionIndex == dataSource.sections.count - 1 && rowIndex == dataSource[sectionIndex].count - 1) {
                    cellFactoryExpectation = expectationWithDescription("cell_factory_" + expectationName)
                    titledViewDataConfigExpectation = expectationWithDescription("titledViewDataConfigExpectation_" + expectationName)
                    titledViewStyleConfigExpectation = expectationWithDescription("titledViewStyleConfigExpectation_")
                }
            }
        }
    }
    
}
