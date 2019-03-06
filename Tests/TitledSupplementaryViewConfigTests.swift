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

import Foundation
import JSQDataSourcesKit
import UIKit
import XCTest

final class TitledSupplementaryViewConfigTests: TestCase {

    private let dequeueCellExpectationName = "collectionview_dequeue_cell_expectation"
    private let dequeueSupplementaryViewExpectationName = "collectionview_dequeue_supplementaryview_expectation"

    override func setUp() {
        super.setUp()
        collectionView.register(TitledSupplementaryView.self,
                                forSupplementaryViewOfKind: fakeSupplementaryViewKind,
                                withReuseIdentifier: TitledSupplementaryView.identifier)
    }

    func test_dataSource_returnsExpectedData_withTitledSupplementaryView() {
        // GIVEN: some collection view sections
        let section0 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel())
        let section1 = Section(items: FakeViewModel(), FakeViewModel())
        let section2 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel())
        let dataSource = DataSource([section0, section1, section2])

        var cellConfigExpectation = expectation(description: "cell_config")

        // GIVEN: a cell config
        let cellConfig = ReusableViewConfig(reuseIdentifier: cellReuseId) { (cell, _: FakeViewModel?, _, _, _) -> FakeCollectionCell in
            cellConfigExpectation.fulfill()
            return cell
        }

        var titledViewDataConfigExpectation = expectation(description: "titledViewDataConfigExpectation")

        let supplementaryConfig = TitledSupplementaryViewConfig { (view, item: FakeViewModel?, type, collectionView, indexPath) -> TitledSupplementaryView in
            XCTAssertEqual(view.reuseIdentifier!, TitledSupplementaryView.identifier, "Dequeued supplementary view should have expected identifier")
            XCTAssertEqual(type, ReusableViewType.supplementaryView(kind: fakeSupplementaryViewKind), "View type should have expected type")
            XCTAssertEqual(item, dataSource[indexPath.section][indexPath.row], "Model object should equal expected value")
            XCTAssertEqual(collectionView, self.collectionView, "CollectionView should equal the collectionView for the data source")

            titledViewDataConfigExpectation.fulfill()
            return view
        }

        // GIVEN: a data source provider
        let dataSourceProvider = DataSourceProvider(dataSource: dataSource,
                                                    cellConfig: cellConfig,
                                                    supplementaryConfig: supplementaryConfig)

        let collectionViewDataSource = dataSourceProvider.collectionViewDataSource

        collectionView.dataSource = collectionViewDataSource

        // WHEN: we call the collection view data source methods
        let numSections = collectionViewDataSource.numberOfSections?(in: collectionView)

        // THEN: we receive the expected return values
        XCTAssertNotNil(numSections, "Number of sections should not be nil")
        XCTAssertEqual(numSections!, dataSource.sections.count, "Data source should return expected number of sections")

        for sectionIndex in 0..<dataSource.sections.count {
            for rowIndex in 0..<dataSource[sectionIndex].items.count {

                let expectationName = "\(#function)_\(sectionIndex)_\(rowIndex)"
                collectionView.dequeueCellExpectation = expectation(description: dequeueCellExpectationName + expectationName)
                collectionView.dequeueSupplementaryViewExpectation = expectation(description: dequeueSupplementaryViewExpectationName + expectationName)

                let indexPath = IndexPath(item: rowIndex, section: sectionIndex)

                // WHEN: we call the collection view data source methods
                let numRows = collectionViewDataSource.collectionView(collectionView, numberOfItemsInSection: sectionIndex)
                let cell = collectionViewDataSource.collectionView(collectionView, cellForItemAt: indexPath)
                let supplementaryView = collectionViewDataSource.collectionView?(collectionView, viewForSupplementaryElementOfKind: fakeSupplementaryViewKind, at: indexPath)

                // THEN: we receive the expected return values for cells
                XCTAssertEqual(numRows, dataSource[sectionIndex].count, "Data source should return expected number of rows for section \(sectionIndex)")
                XCTAssertEqual(cell.reuseIdentifier!, cellReuseId, "Data source should return cells with the expected identifier")

                // THEN: we receive the expected return values for supplementary views
                XCTAssertNotNil(supplementaryView, "Supplementary view should not be nil")
                XCTAssertEqual(supplementaryView!.reuseIdentifier!,
                               TitledSupplementaryView.identifier,
                               "Data source should return supplementary views with the expected identifier")

                // THEN: the collectionView calls `dequeueReusableCellWithReuseIdentifier`
                // THEN: the cell config calls its `ConfigurationHandler`

                // THEN: the collectionView calls `dequeueReusableSupplementaryViewOfKind`
                // THEN: the supplementary view config calls its `dataConfigurator`
                // THEN: the supplementary view config calls its `styleConfigurator`
                waitForExpectations(timeout: defaultTimeout) { error -> Void in
                    XCTAssertNil(error, "Expections should not error")
                }

                // reset expectation names for next loop, ignore last item
                if !(sectionIndex == dataSource.sections.count - 1 && rowIndex == dataSource[sectionIndex].count - 1) {
                    cellConfigExpectation = expectation(description: "cell_config_" + expectationName)
                    titledViewDataConfigExpectation = expectation(description: "titledViewDataConfigExpectation_" + expectationName)
                }
            }
        }
    }
}
