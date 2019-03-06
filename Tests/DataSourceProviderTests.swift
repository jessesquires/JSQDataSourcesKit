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

final class DataSourceProviderTests: TestCase {

    private let dequeueCellExpectationName = "dequeue_cell_expectation"
    private let dequeueSupplementaryViewExpectationName = "dequeue_supplementaryview_expectation"

    func test_reusableViewType_equality() {
        let c1 = ReusableViewType.cell
        let c2 = ReusableViewType.cell
        XCTAssertEqual(c1, c2)

        let s1 = ReusableViewType.supplementaryView(kind: "same")
        let s2 = ReusableViewType.supplementaryView(kind: "same")
        XCTAssertEqual(s1, s2)

        let s3 = ReusableViewType.supplementaryView(kind: "different")
        XCTAssertNotEqual(s1, s3)
        XCTAssertNotEqual(c1, s1)
    }

    // MARK: CollectionView

    func test_thatDataSourceProvider_forCollectionView_returnsExpectedData_forSingleSection() {
        // GIVEN: a single section with data items
        let expectedModel = FakeViewModel()
        let expectedIndexPath = IndexPath(row: 3, section: 0)

        let section0 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), expectedModel, FakeViewModel())
        let dataSource = DataSource([section0])

        let cellConfigExpectation = expectation(description: #function)
        collectionView.dequeueCellExpectation = expectation(description: dequeueCellExpectationName + #function)

        // GIVEN: a cell config
        let cellConfig = ReusableViewConfig(reuseIdentifier: cellReuseId) { (cell, model: FakeViewModel?, _, collectionView, indexPath) -> FakeCollectionCell in
            XCTAssertEqual(cell.reuseIdentifier!, self.cellReuseId, "Dequeued cell should have expected identifier")
            XCTAssertEqual(model, expectedModel, "Model object should equal expected value")
            XCTAssertEqual(collectionView, self.collectionView, "CollectionView should equal the collectionView for the data source")
            XCTAssertEqual(indexPath, expectedIndexPath, "IndexPath should equal expected value")

            cellConfigExpectation.fulfill()
            return cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider = DataSourceProvider(dataSource: dataSource, cellConfig: cellConfig, supplementaryConfig: cellConfig)
        let collectionViewDataSource = dataSourceProvider.collectionViewDataSource

        collectionView.dataSource = collectionViewDataSource

        // WHEN: we call the collection view data source methods
        let numSections = collectionViewDataSource.numberOfSections?(in: collectionView)
        let numRows = collectionViewDataSource.collectionView(collectionView, numberOfItemsInSection: 0)
        let cell = collectionViewDataSource.collectionView(collectionView, cellForItemAt: expectedIndexPath)

        // THEN: we receive the expected return values
        XCTAssertNotNil(numSections, "Number of sections should not be nil")
        XCTAssertEqual(numSections!, dataSource.sections.count, "Data source should return expected number of sections")

        XCTAssertEqual(numRows, section0.count, "Data source should return expected number of rows for section 0")

        XCTAssertEqual(cell.reuseIdentifier!, cellReuseId, "Data source should return cells with the expected identifier")

        // THEN: the collectionView calls `dequeueReusableCellWithReuseIdentifier`
        // THEN: the cell config calls its `ConfigurationHandler`
        waitForExpectations(timeout: defaultTimeout) { error -> Void in
            XCTAssertNil(error, "Expectation should not error")
        }
    }

    func test_thatDataSourceProvider_forCollectionView_returnsExpectedData_forSingleSection_withoutItems() {
        // GIVEN: a single section with no items
        let items = [FakeViewModel]()
        let dataSource = DataSource(sections: Section(items))
        XCTAssertEqual(dataSource.sections.count, 1)

        // GIVEN: a cell config
        let cellConfig = ReusableViewConfig(reuseIdentifier: cellReuseId) { (cell, _: FakeViewModel?, _, _, _) -> FakeCollectionCell in
            cell
        }

        let supplementaryConfigExpectation = expectation(description: "supplementary_config_\(#function)")

        // GIVEN: a supplementary view config
        let supplementaryConfig = ReusableViewConfig(reuseIdentifier: supplementaryViewReuseId,
                                                     type: .supplementaryView(kind: fakeSupplementaryViewKind)) { (view, _: FakeViewModel?, _, _, _) -> FakeCollectionSupplementaryView in
            supplementaryConfigExpectation.fulfill()
            return view
        }

        // GIVEN: a data source provider
        let dataSourceProvider = DataSourceProvider(dataSource: dataSource,
                                                    cellConfig: cellConfig,
                                                    supplementaryConfig: supplementaryConfig)
        let collectionViewDataSource = dataSourceProvider.collectionViewDataSource
        collectionView.dataSource = collectionViewDataSource

        collectionView.layoutSubviews()

        // WHEN: we call the collection view data source methods
        let numSections = collectionViewDataSource.numberOfSections?(in: collectionView)
        let numRows = collectionViewDataSource.collectionView(collectionView, numberOfItemsInSection: 0)
        let supplementaryView = collectionViewDataSource.collectionView?(collectionView,
                                                                         viewForSupplementaryElementOfKind: fakeSupplementaryViewKind,
                                                                         at: IndexPath(item: 0, section: 0))

        // THEN: we receive the expected return values
        XCTAssertEqual(numSections!, 1, "Data source should return 1 section")
        XCTAssertEqual(numRows, 0, "Data source should return 0 rows for section 0")

        XCTAssertNotNil(supplementaryView, "Supplementary view should not be nil")
        XCTAssertEqual(supplementaryView!.reuseIdentifier!, supplementaryViewReuseId, "Data source should return supplementary views with the expected identifier")

        // THEN: the collectionView calls `dequeueReusableSupplementaryViewOfKind`
        // THEN: the supplementary view config calls its `ConfigurationHandler`
        waitForExpectations(timeout: defaultTimeout) { error -> Void in
            XCTAssertNil(error, "Expectation should not error")
        }
    }

    func test_thatDataSourceProvider_forCollectionView_returnsExpectedData_forMultipleSections() {
        // GIVEN: some collection view sections
        let section0 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel())
        let section1 = Section(items: FakeViewModel(), FakeViewModel())
        let section2 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel())
        let dataSource = DataSource([section0, section1, section2])

        var cellConfigExpectation = expectation(description: "cell_config_\(#function)")

        // GIVEN: a cell config
        let cellConfig = ReusableViewConfig(reuseIdentifier: cellReuseId) { (cell, model: FakeViewModel?, _, collectionView, indexPath) -> FakeCollectionCell in
            XCTAssertEqual(cell.reuseIdentifier!, self.cellReuseId, "Dequeued cell should have expected identifier")
            XCTAssertEqual(model, dataSource[indexPath.section][indexPath.row], "Model object should equal expected value")
            XCTAssertEqual(collectionView, self.collectionView, "CollectionView should equal the collectionView for the data source")

            cellConfigExpectation.fulfill()
            return cell
        }

        var supplementaryConfigExpectation = expectation(description: "supplementary_config_\(#function)")

        // GIVEN: a supplementary view config
        let supplementaryConfig = ReusableViewConfig(
        reuseIdentifier: supplementaryViewReuseId,
        type: .supplementaryView(kind: fakeSupplementaryViewKind)) { (view, model: FakeViewModel?, type, collectionView, indexPath) -> FakeCollectionSupplementaryView in
            XCTAssertEqual(view.reuseIdentifier!, self.supplementaryViewReuseId, "Dequeued supplementary view should have expected identifier")
            XCTAssertEqual(model, dataSource[indexPath.section][indexPath.row], "Model object should equal expected value")
            XCTAssertEqual(type, ReusableViewType.supplementaryView(kind: fakeSupplementaryViewKind), "View type should have expected type")
            XCTAssertEqual(collectionView, self.collectionView, "CollectionView should equal the collectionView for the data source")

            supplementaryConfigExpectation.fulfill()
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

                // THEN: we receive the expected return values
                XCTAssertEqual(numRows, dataSource[sectionIndex].count, "Data source should return expected number of rows for section \(sectionIndex)")

                XCTAssertEqual(cell.reuseIdentifier!, cellReuseId, "Data source should return cells with the expected identifier")

                XCTAssertNotNil(supplementaryView, "Supplementary view should not be nil")
                XCTAssertEqual(supplementaryView!.reuseIdentifier!, supplementaryViewReuseId, "Data source should return supplementary views with the expected identifier")

                // THEN: the collectionView calls `dequeueReusableCellWithReuseIdentifier`
                // THEN: the cell config calls its `ConfigurationHandler`

                // THEN: the collectionView calls `dequeueReusableSupplementaryViewOfKind`
                // THEN: the supplementary view config calls its `ConfigurationHandler`
                waitForExpectations(timeout: defaultTimeout) { error -> Void in
                    XCTAssertNil(error, "Expections should not error")
                }

                // reset expectation names for next loop, ignore last item
                if !(sectionIndex == dataSource.sections.count - 1 && rowIndex == dataSource[sectionIndex].count - 1) {
                    cellConfigExpectation = expectation(description: "cell_config_" + expectationName)
                    supplementaryConfigExpectation = expectation(description: "supplementary_config_" + expectationName)
                }
            }
        }
    }

    // MARK: TableView

    func test_thatDataSourceProvider_forTableView_returnsExpectedData_forSingleSection() {
        // GIVEN: a single section with data items
        let expectedModel = FakeViewModel()
        let expectedIndexPath = IndexPath(row: 2, section: 0)
        let items = [FakeViewModel(), FakeViewModel(), expectedModel, FakeViewModel(), FakeViewModel()]
        let section0 = Section(items: items,
                               headerTitle: "Header",
                               footerTitle: "Footer")
        let dataSource = DataSource([section0])

        let configExpectation = expectation(description: #function)
        tableView.dequeueCellExpectation = expectation(description: dequeueCellExpectationName + #function)

        // GIVEN: a cell config
        let config = ReusableViewConfig(reuseIdentifier: cellReuseId) { (cell, model: FakeViewModel?, _, tableView, indexPath) -> FakeTableCell in
            XCTAssertEqual(cell.reuseIdentifier!, self.cellReuseId, "Dequeued cell should have expected identifier")

            XCTAssertEqual(model, expectedModel, "Model object should equal expected value")
            XCTAssertEqual(tableView, self.tableView, "TableView should equal the tableView for the data source")
            XCTAssertEqual(indexPath, expectedIndexPath, "IndexPath should equal expected value")

            configExpectation.fulfill()
            return cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider = DataSourceProvider(dataSource: dataSource, cellConfig: config, supplementaryConfig: config)
        let tableViewDataSource = dataSourceProvider.tableViewDataSource

        tableView.dataSource = tableViewDataSource

        // WHEN: we call the table view data source methods
        let numSections = tableViewDataSource.numberOfSections?(in: tableView)
        let numRows = tableViewDataSource.tableView(tableView, numberOfRowsInSection: 0)
        let cell = tableViewDataSource.tableView(tableView, cellForRowAt: expectedIndexPath)
        let header = tableViewDataSource.tableView?(tableView, titleForHeaderInSection: 0)
        let footer = tableViewDataSource.tableView?(tableView, titleForFooterInSection: 0)

        // THEN: we receive the expected return values
        XCTAssertNotNil(numSections, "Number of sections should not be nil")
        XCTAssertEqual(numSections!, dataSourceProvider.dataSource.sections.count, "Data source should return expected number of sections")

        XCTAssertEqual(numRows, section0.count, "Data source should return expected number of rows for section 0")

        XCTAssertNotNil(cell.reuseIdentifier, "Cell reuse identifier should not be nil")
        XCTAssertEqual(cell.reuseIdentifier!, cellReuseId, "Data source should return cells with the expected identifier")

        XCTAssertNotNil(header, "Header should not be nil")
        XCTAssertNotNil(section0.headerTitle, "Section 0 header title should not be nil")
        XCTAssertEqual(header!, section0.headerTitle!, "Data source should return expected header title")

        XCTAssertNotNil(footer, "Footer should not be nil")
        XCTAssertNotNil(section0.footerTitle, "Section 0 footer title should not be nil")
        XCTAssertEqual(footer!, section0.footerTitle!, "Data source should return expected footer title")

        // THEN: the tableView calls `dequeueReusableCellWithIdentifier`
        // THEN: the cell config calls its `ConfigurationHandler`
        waitForExpectations(timeout: defaultTimeout) { error -> Void in
            XCTAssertNil(error, "Expectations should not error")
        }
    }

    func test_thatDataSourceProvider_forTableView_returnsExpectedData_forMultipleSections() {
        // GIVEN: some table view sections
        let section0 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), headerTitle: "Header", footerTitle: "Footer")
        let section1 = Section(items: FakeViewModel(), headerTitle: "Header Title")
        let section2 = Section(items: FakeViewModel(), FakeViewModel(), footerTitle: "Footer")
        let section3 = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel())
        let dataSource = DataSource([section0, section1, section2, section3])

        var configExpectation = expectation(description: "config_\(#function)")

        // GIVEN: a cell config
        let config = ReusableViewConfig(reuseIdentifier: cellReuseId) { (cell, model: FakeViewModel?, _, tableView, indexPath) -> FakeTableCell in
            XCTAssertEqual(cell.reuseIdentifier!, self.cellReuseId, "Dequeued cell should have expected identifier")
            XCTAssertEqual(model, dataSource[indexPath.section][indexPath.row], "Model object should equal expected value")
            XCTAssertEqual(tableView, self.tableView, "TableView should equal the tableView for the data source")

            configExpectation.fulfill()
            return cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider = DataSourceProvider(dataSource: dataSource, cellConfig: config, supplementaryConfig: config)
        let tableViewDataSource = dataSourceProvider.tableViewDataSource

        tableView.dataSource = tableViewDataSource

        // WHEN: we call the table view data source methods
        let numSections = tableViewDataSource.numberOfSections?(in: tableView)

        // THEN: we receive the expected return values
        XCTAssertNotNil(numSections, "Number of sections should not be nil")
        XCTAssertEqual(numSections!, dataSourceProvider.dataSource.sections.count, "Data source should return expected number of sections")

        for sectionIndex in 0..<dataSourceProvider.dataSource.sections.count {

            for rowIndex in 0..<dataSourceProvider.dataSource[sectionIndex].items.count {

                let expectationName = "\(#function)_\(sectionIndex)_\(rowIndex)"
                tableView.dequeueCellExpectation = expectation(description: dequeueCellExpectationName + expectationName)

                // WHEN: we call the table view data source methods
                let numRows = tableViewDataSource.tableView(tableView, numberOfRowsInSection: sectionIndex)
                let header = tableViewDataSource.tableView?(tableView, titleForHeaderInSection: sectionIndex)
                let footer = tableViewDataSource.tableView?(tableView, titleForFooterInSection: sectionIndex)

                let cell = tableViewDataSource.tableView(tableView, cellForRowAt: IndexPath(row: rowIndex, section: sectionIndex))

                // THEN: we receive the expected return values
                XCTAssertEqual(numRows, dataSourceProvider.dataSource[sectionIndex].count, "Data source should return expected number of rows for section \(sectionIndex)")

                XCTAssertNotNil(cell.reuseIdentifier, "Cell reuse identifier should not be nil")
                XCTAssertEqual(cell.reuseIdentifier!, cellReuseId, "Data source should return cells with the expected identifier")

                XCTAssertTrue(header == dataSourceProvider.dataSource[sectionIndex].headerTitle, "Data source should return expected header title for section \(sectionIndex)")
                XCTAssertTrue(footer == dataSourceProvider.dataSource[sectionIndex].footerTitle, "Data source should return expected footer title for section \(sectionIndex)")

                // THEN: the tableView calls `dequeueReusableCellWithIdentifier`
                // THEN: the cell config calls its `ConfigurationHandler`
                waitForExpectations(timeout: defaultTimeout) { error -> Void in
                    XCTAssertNil(error, "Expectations should not error")
                }

                // reset expectation names for next loop, ignore last item
                if !(sectionIndex == dataSourceProvider.dataSource.sections.count - 1 && rowIndex == dataSourceProvider.dataSource[sectionIndex].count - 1) {
                    configExpectation = expectation(description: "config_" + expectationName)
                }
            }
        }
    }

    func test_thatDataSourceProvider_forTableView_returnsExpectedData_afterRemovingRowFromTableView() {
        // GIVEN: a single section with data items
        let expectedModel = FakeViewModel()
        let expectedIndexPath = IndexPath(row: 2, section: 0)
        let items = [ FakeViewModel(), FakeViewModel(), expectedModel, FakeViewModel(), FakeViewModel()]
        let section0 = Section(items: items,
                               headerTitle: "Header",
                               footerTitle: "Footer")
        let dataSource = DataSource([section0])

        let oldItemForExpectedIndexPath = dataSource.item(atRow: expectedIndexPath.row, inSection: expectedIndexPath.section)
        let oldCount = dataSource.numberOfItems(inSection: expectedIndexPath.section)

        let configExpectation = expectation(description: #function)
        tableView.dequeueCellExpectation = expectation(description: dequeueCellExpectationName + #function)

        typealias TableCellConfig = ReusableViewConfig<FakeViewModel, FakeTableCell>
        var dataSourceProvider: DataSourceProvider<DataSource<FakeViewModel>, TableCellConfig, TableCellConfig>!

        // GIVEN: a cell config
        let config = ReusableViewConfig(reuseIdentifier: cellReuseId) { (cell, _: FakeViewModel?, _, tableView, _) -> FakeTableCell in

            XCTAssertEqual(cell.reuseIdentifier!, self.cellReuseId, "Dequeued cell should have expected identifier")
            XCTAssertEqual(tableView, self.tableView, "TableView should equal the tableView for the data source")

            configExpectation.fulfill()
            return cell
        }

        // GIVEN: a data source editing controller
        let editingController = TableEditingController<DataSource<FakeViewModel>>(
            canEditRow: { _, tableView, indexPath -> Bool in
                indexPath == expectedIndexPath
        },
            commitEditing: { (dataSource: inout DataSource, tableView, editingStyle, indexPath) in
                if editingStyle == .delete {
                    if dataSource.remove(at: indexPath) != nil {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
        })

        // GIVEN: a data source provider
        dataSourceProvider = DataSourceProvider(dataSource: dataSource,
                                                cellConfig: config,
                                                supplementaryConfig: config,
                                                tableEditingController: editingController)

        let tableViewDataSource = dataSourceProvider.tableViewDataSource
        tableView.dataSource = tableViewDataSource

        // WHEN: we call the table view data source methods
        let canEditRow = tableViewDataSource.tableView?(tableView, canEditRowAt: expectedIndexPath)
        tableViewDataSource.tableView?(tableView, commit: .delete, forRowAt: expectedIndexPath)
        let newItemForExpectedIndexPath = dataSourceProvider.dataSource.item(atRow: expectedIndexPath.row, inSection: expectedIndexPath.section)
        let newCount = dataSourceProvider.dataSource.numberOfItems(inSection: expectedIndexPath.section)

        let numSections = tableViewDataSource.numberOfSections?(in: tableView)
        let cell = tableViewDataSource.tableView(tableView, cellForRowAt: expectedIndexPath)
        let header = tableViewDataSource.tableView?(tableView, titleForHeaderInSection: 0)
        let footer = tableViewDataSource.tableView?(tableView, titleForFooterInSection: 0)

        // THEN: we receive the expected return values
        XCTAssertNotNil(canEditRow, "canEditRow should not be nil")
        XCTAssert(canEditRow!, "expectedIndexpath should be able to be removed from tableview")

        XCTAssertNotEqual(oldCount, newCount, "Number of items for \(expectedIndexPath.section) should not be equal after removing the expected row")
        XCTAssertEqual(newCount, oldCount - 1, "Number of items for \(expectedIndexPath.section) should be less by one")
        XCTAssertNotEqual(newItemForExpectedIndexPath, oldItemForExpectedIndexPath, "old item at row \(expectedIndexPath.row), section \(expectedIndexPath.section) shouldn't exist any more")

        XCTAssertNotNil(numSections, "Number of sections should not be nil")
        XCTAssertEqual(numSections!, dataSourceProvider.dataSource.sections.count, "Data source should return expected number of sections")

        XCTAssertNotNil(cell.reuseIdentifier, "Cell reuse identifier should not be nil")
        XCTAssertEqual(cell.reuseIdentifier!, cellReuseId, "Data source should return cells with the expected identifier")

        XCTAssertNotNil(header, "Header should not be nil")
        XCTAssertNotNil(section0.headerTitle, "Section 0 header title should not be nil")
        XCTAssertEqual(header!, section0.headerTitle!, "Data source should return expected header title")

        XCTAssertNotNil(footer, "Footer should not be nil")
        XCTAssertNotNil(section0.footerTitle, "Section 0 footer title should not be nil")
        XCTAssertEqual(footer!, section0.footerTitle!, "Data source should return expected footer title")

        // THEN: the tableView calls `dequeueReusableCellWithIdentifier`
        // THEN: the cell config calls its `ConfigurationHandler`
        waitForExpectations(timeout: defaultTimeout) { error -> Void in
            XCTAssertNil(error, "Expectations should not error")
        }
    }
}
