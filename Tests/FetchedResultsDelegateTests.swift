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

import CoreData
import ExampleModel
import Foundation
import JSQDataSourcesKit
import UIKit
import XCTest

final class FetchedResultsDelegateTests: TestCase {

    func test_fetchedResultsDelegate_integration_withTableView() {
        // GIVEN: a core data stack and objects in a context
        let stack = CoreDataStack(inMemory: true)
        let context = stack.context
        let blueThings = generateThings(context, color: .Blue)
        let greenThings = generateThings(context, color: .Green)
        let redThings = generateThings(context, color: .Red)
        stack.saveAndWait()

        // GIVEN: a fetched results controller
        let frc = FetchedResultsController<Thing>(fetchRequest: Thing.newFetchRequest(),
                                                  managedObjectContext: context,
                                                  sectionNameKeyPath: "colorName",
                                                  cacheName: nil)

        // GIVEN: a cell config
        let config = ReusableViewConfig(reuseIdentifier: cellReuseId) { (cell, _: Thing?, _, _, _) -> FakeTableCell in
            cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider = DataSourceProvider(dataSource: frc, cellConfig: config, supplementaryConfig: config)
        let tableViewDataSource = dataSourceProvider.tableViewDataSource
        tableView.dataSource = tableViewDataSource

        let delegateProvider = FetchedResultsDelegateProvider(cellConfig: config, tableView: tableView)
        frc.delegate = delegateProvider.tableDelegate

        // WHEN: we fech data
        _ = try? frc.performFetch()

        // THEN: the table view reports the expected state
        XCTAssertEqual(tableView.numberOfSections, 3)

        XCTAssertEqual(tableView.numberOfRows(inSection: 0), blueThings.count)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), greenThings.count)
        XCTAssertEqual(tableView.numberOfRows(inSection: 2), redThings.count)

        // WHEN: we modify data, and re-fetch
        for obj in greenThings {
            context.delete(obj)
        }
        generateThings(context, color: .Red)
        blueThings[0].color = .Red
        redThings[0].changeNameRandomly()

        stack.saveAndWait()
        _ = try? frc.performFetch()

        // THEN: the table view reports the expected state
        XCTAssertEqual(tableView.numberOfSections, 2)

        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 7)
    }

    func test_fetchedResultsDelegate_integration_withCollectionView() {
        // GIVEN: a core data stack and objects in a context
        let stack = CoreDataStack(inMemory: true)
        let context = stack.context
        let blueThings = generateThings(context, color: .Blue)
        let greenThings = generateThings(context, color: .Green)
        let redThings = generateThings(context, color: .Red)
        stack.saveAndWait()

        // GIVEN: a fetched results controller
        let frc = FetchedResultsController<Thing>(fetchRequest: Thing.newFetchRequest(),
                                                  managedObjectContext: context,
                                                  sectionNameKeyPath: "colorName",
                                                  cacheName: nil)

        // GIVEN: a cell config
        let config = ReusableViewConfig(reuseIdentifier: cellReuseId) { (cell, _: Thing?, _, _, _) -> FakeCollectionCell in
            cell
        }

        // GIVEN: a supplementary config
        let supplementaryConfig = ReusableViewConfig(
            reuseIdentifier: supplementaryViewReuseId,
            type: .supplementaryView(kind: fakeSupplementaryViewKind)) { (view, _: Thing?, _, _, _) -> FakeCollectionSupplementaryView in
                view
        }

        // GIVEN: a data source provider
        let dataSourceProvider = DataSourceProvider(dataSource: frc, cellConfig: config, supplementaryConfig: supplementaryConfig)
        let collectionViewDataSource = dataSourceProvider.collectionViewDataSource
        collectionView.dataSource = collectionViewDataSource

        let delegateProvider = FetchedResultsDelegateProvider(cellConfig: config, collectionView: collectionView)
        frc.delegate = delegateProvider.collectionDelegate

        // WHEN: we fech data
        _ = try? frc.performFetch()

        // THEN: the table view reports the expected state
        XCTAssertEqual(collectionView.numberOfSections, 3)

        XCTAssertEqual(collectionView.numberOfItems(inSection: 0), blueThings.count)
        XCTAssertEqual(collectionView.numberOfItems(inSection: 1), greenThings.count)
        XCTAssertEqual(collectionView.numberOfItems(inSection: 2), redThings.count)

        collectionView.layoutSubviews()

        // WHEN: we modify data, and re-fetch
        for obj in greenThings {
            context.delete(obj)
        }
        generateThings(context, color: .Red)
        blueThings[0].color = .Red
        redThings[0].changeNameRandomly()

        stack.saveAndWait()
        _ = try? frc.performFetch()

        // THEN: the table view reports the expected state
        XCTAssertEqual(collectionView.numberOfSections, 2)

        XCTAssertEqual(collectionView.numberOfItems(inSection: 0), 2)
        XCTAssertEqual(collectionView.numberOfItems(inSection: 1), 7)
    }

}
