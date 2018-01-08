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
import UIKit
import XCTest

import JSQDataSourcesKit

final class DataSourceTests: XCTestCase {

    func test_thatDataSource_implements_dataSourceProtocol() {
        // GIVEN: some sections
        let sectionA = Section(items: FakeViewModel(), FakeViewModel(), headerTitle: "Header")
        let sectionB = Section(items: FakeViewModel(), FakeViewModel(), footerTitle: "Footer")
        let sectionC = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel())

        // WHEN: we create a data source
        let dataSource = DataSource(sections: sectionA, sectionB, sectionC)

        // THEN: it returns the expected data from the protocol methods
        XCTAssertEqual(dataSource.numberOfSections(), 3)
        XCTAssertEqual(dataSource.numberOfItems(inSection: 0), 2)
        XCTAssertEqual(dataSource.numberOfItems(inSection: 1), 2)
        XCTAssertEqual(dataSource.numberOfItems(inSection: 2), 3)
        XCTAssertEqual(dataSource.numberOfItems(inSection: 3), 0)

        XCTAssertEqual(dataSource.items(inSection: 0)!, sectionA.items)
        XCTAssertEqual(dataSource.items(inSection: 1)!, sectionB.items)
        XCTAssertEqual(dataSource.items(inSection: 2)!, sectionC.items)
        XCTAssertNil(dataSource.items(inSection: 3))

        XCTAssertEqual(dataSource.item(atRow: 0, inSection: 0), sectionA[0])
        XCTAssertEqual(dataSource.item(atRow: 1, inSection: 0), sectionA[1])
        XCTAssertNil(dataSource.item(atRow: 2, inSection: 0))

        XCTAssertEqual(dataSource.headerTitle(inSection: 0), sectionA.headerTitle)
        XCTAssertNil(dataSource.footerTitle(inSection: 0))

        XCTAssertNil(dataSource.headerTitle(inSection: 1))
        XCTAssertEqual(dataSource.footerTitle(inSection: 1), sectionB.footerTitle)

        XCTAssertNil(dataSource.headerTitle(inSection: 2))
        XCTAssertNil(dataSource.footerTitle(inSection: 2))

        XCTAssertNil(dataSource.headerTitle(inSection: 4))
        XCTAssertNil(dataSource.footerTitle(inSection: 4))
    }

    func test_thatFetchedResultsController_implements_dataSourceProtocol_withObjectsInCoreData() {
        // GIVEN: a core data stack and objects in a context
        let context = CoreDataStack(inMemory: true).context
        let blueThings = generateThings(context, color: .Blue)
        let greenThings = generateThings(context, color: .Green)
        let redThings = generateThings(context, color: .Red)

        // GIVEN: a fetched results controller
        let frc = FetchedResultsController<Thing>(fetchRequest: Thing.newFetchRequest(),
                                                  managedObjectContext: context,
                                                  sectionNameKeyPath: "colorName",
                                                  cacheName: nil)

        // WHEN: we fech data
        _ = try? frc.performFetch()

        // THEN: it returns the expected data from the protocol methods
        XCTAssertEqual(frc.numberOfSections(), 3)
        XCTAssertEqual(frc.numberOfItems(inSection: 0), 3)
        XCTAssertEqual(frc.numberOfItems(inSection: 1), 3)
        XCTAssertEqual(frc.numberOfItems(inSection: 2), 3)

        XCTAssertEqual(frc.items(inSection: 0)!, blueThings)
        XCTAssertEqual(frc.items(inSection: 1)!, greenThings)
        XCTAssertEqual(frc.items(inSection: 2)!, redThings)

        XCTAssertEqual(frc.item(atRow: 0, inSection: 0), blueThings[0])
        XCTAssertEqual(frc.item(atRow: 1, inSection: 1), greenThings[1])
        XCTAssertEqual(frc.item(atRow: 2, inSection: 2), redThings[2])

        XCTAssertEqual(frc.headerTitle(inSection: 0), "Blue")
        XCTAssertEqual(frc.headerTitle(inSection: 1), "Green")
        XCTAssertEqual(frc.headerTitle(inSection: 2), "Red")

        XCTAssertNil(frc.footerTitle(inSection: 0))
        XCTAssertNil(frc.footerTitle(inSection: 1))
        XCTAssertNil(frc.footerTitle(inSection: 2))
    }

    func test_thatFetchedResultsController_implements_dataSourceProtocol_withNoData() {
        // GIVEN: a core data stack and objects in a context
        let context = CoreDataStack(inMemory: true).context

        // GIVEN: a fetched results controller
        let frc = FetchedResultsController<Thing>(fetchRequest: Thing.newFetchRequest(),
                                                  managedObjectContext: context,
                                                  sectionNameKeyPath: "colorName",
                                                  cacheName: nil)

        // WHEN: we fech data
        _ = try? frc.performFetch()

        // THEN: it returns the expected data from the protocol methods
        XCTAssertEqual(frc.numberOfSections(), 0)
        XCTAssertEqual(frc.numberOfItems(inSection: 0), 0)
        XCTAssertEqual(frc.numberOfItems(inSection: 5), 0)

        XCTAssertNil(frc.items(inSection: 0))
        XCTAssertNil(frc.items(inSection: 4))

        XCTAssertNil(frc.item(atRow: 0, inSection: 0))
        XCTAssertNil(frc.item(atRow: 6, inSection: 7))

        XCTAssertNil(frc.headerTitle(inSection: 0))
        XCTAssertNil(frc.headerTitle(inSection: 10))

        XCTAssertNil(frc.footerTitle(inSection: 0))
        XCTAssertNil(frc.footerTitle(inSection: 4))
    }

    func test_thatFetchedResultsController_returnsExpectedData_fromIndexPathSubscript() {
        // GIVEN: a core data stack and objects in a context
        let context = CoreDataStack(inMemory: true).context
        let blueThings = generateThings(context, color: .Blue)
        let greenThings = generateThings(context, color: .Green)
        let redThings = generateThings(context, color: .Red)

        // GIVEN: a fetched results controller
        let frc = FetchedResultsController<Thing>(fetchRequest: Thing.newFetchRequest(),
                                                  managedObjectContext: context,
                                                  sectionNameKeyPath: "colorName",
                                                  cacheName: nil)
        _ = try? frc.performFetch()

        // WHEN: we ask for an object
        // THEN: we receive the exepected data
        XCTAssertEqual(frc[IndexPath(item: 1, section: 0)], blueThings[1])
        XCTAssertEqual(frc[IndexPath(item: 2, section: 1)], greenThings[2])
        XCTAssertEqual(frc[IndexPath(item: 0, section: 2)], redThings[0])
    }

    func test_thatFetchedResultsController_returnsExpectedData_atIndexPath() {
        // GIVEN: a core data stack and objects in a context
        let context = CoreDataStack(inMemory: true).context
        let blueThings = generateThings(context, color: .Blue)
        let greenThings = generateThings(context, color: .Green)
        let redThings = generateThings(context, color: .Red)

        // GIVEN: a fetched results controller
        let frc = FetchedResultsController<Thing>(fetchRequest: Thing.newFetchRequest(),
                                                  managedObjectContext: context,
                                                  sectionNameKeyPath: "colorName",
                                                  cacheName: nil)
        _ = try? frc.performFetch()

        // WHEN: we ask for an object
        // THEN: we receive the exepected data
        XCTAssertEqual(frc.item(atIndexPath: IndexPath(item: 1, section: 0)), blueThings[1])
        XCTAssertEqual(frc.item(atIndexPath: IndexPath(item: 2, section: 1)), greenThings[2])
        XCTAssertEqual(frc.item(atIndexPath: IndexPath(item: 0, section: 2)), redThings[0])
    }

    func test_thatDataSource_returnsExpectedData_fromIntSubscript() {
        // GIVEN: a data source
        let sectionA = Section(items: FakeViewModel(), FakeViewModel(), headerTitle: "Header")
        let sectionB = Section(items: FakeViewModel(), FakeViewModel(), footerTitle: "Footer")
        let sectionC = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel())
        let dataSource = DataSource(sections: sectionA, sectionB, sectionC)

        // WHEN: we ask for a section
        let s = dataSource[1]

        // THEN: we receive the exepected data
        XCTAssertEqual(s.items, sectionB.items)
        XCTAssertEqual(s.headerTitle, sectionB.headerTitle)
        XCTAssertEqual(s.footerTitle, sectionB.footerTitle)
    }

    func test_thatDataSource_setsExpectedData_atIntSubscript() {
        // GIVEN: a data source
        let sectionA = Section(items: FakeViewModel(), FakeViewModel(), headerTitle: "Header")
        let sectionB = Section(items: FakeViewModel(), FakeViewModel(), footerTitle: "Footer")
        var dataSource = DataSource(sections: sectionA, sectionB)

        // WHEN: we set a section at a specific index
        let index = 1
        let sectionC = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel())
        dataSource[index] = sectionC

        // THEN: the section is replaced
        XCTAssertEqual(dataSource[index].items, sectionC.items)
        XCTAssertEqual(dataSource[index].headerTitle, sectionC.headerTitle)
        XCTAssertEqual(dataSource[index].footerTitle, sectionC.footerTitle)
    }

    func test_thatDataSource_returnsExpectedData_fromIndexPathSubscript() {
        // GIVEN: a data source
        let model = FakeViewModel()
        let sectionA = Section(items: FakeViewModel(), FakeViewModel(), headerTitle: "Header")
        let sectionB = Section(items: FakeViewModel(), FakeViewModel(), footerTitle: "Footer")
        let sectionC = Section(items: FakeViewModel(), FakeViewModel(), model)
        let dataSource = DataSource(sections: sectionA, sectionB, sectionC)

        // WHEN: we ask for an item
        let ip = IndexPath(item: 2, section: 2)
        let item = dataSource[ip]

        // THEN: we receive the expected data
        XCTAssertEqual(item, model)
    }

    func test_thatDataSource_setsExpectedData_atIndexPathSubscript() {
        // GIVEN: a data source
        let sectionA = Section(items: FakeViewModel(), FakeViewModel(), headerTitle: "Header")
        let sectionB = Section(items: FakeViewModel(), FakeViewModel(), footerTitle: "Footer")
        var dataSource = DataSource(sections: sectionA, sectionB)

        // WHEN: we set an item at a specific index path
        let ip = IndexPath(item: 1, section: 0)
        let item = FakeViewModel()
        dataSource[ip] = item

        // THEN: the item is replaced
        XCTAssertEqual(dataSource[ip], item)
    }

    func test_thatDataSource_returnsNil_whenDataFromInvalidSection_areRequested() {
        // GIVEN: a data source
        let sectionA = Section(items: FakeViewModel(), FakeViewModel(), headerTitle: "Header")
        let sectionB = Section(items: FakeViewModel(), FakeViewModel(), footerTitle: "Footer")
        let dataSource = DataSource(sections: sectionA, sectionB)

        // WHEN: we request an item from an invalid section
        let requestedItem = dataSource.item(atRow: 0, inSection: 2)

        // THEN: the returned item should be nil
        XCTAssertNil(requestedItem, "The requested section shouldn't exist")
    }

    func test_thatDataSource_insertsExpectedData_atIndexPath() {
        // GIVEN: a data source
        let sectionA = Section(items: FakeViewModel(), FakeViewModel(), headerTitle: "Header")
        let sectionB = Section(items: FakeViewModel(), FakeViewModel(), footerTitle: "Footer")
        var dataSource = DataSource(sections: sectionA, sectionB)

        // WHEN: we add an item at a specific index path
        let newItem = FakeViewModel()
        let ip = IndexPath(item: 2, section: 1)
        dataSource.insert(item: newItem, at: ip)

        let sectionItems = dataSource.items(inSection: ip.section)
        let insertedIndex = sectionItems?.index(of: newItem)

        // THEN: the item is inserted at the specific index path
        XCTAssertEqual(insertedIndex, ip.row, "New item should be at the requested index")
        XCTAssertEqual(newItem, dataSource[ip], "New item should match the item at requested index path in dataSource")
    }

    func test_thatDataSource_appendsExpectedData_inSection() {
        // GIVEN: a data source
        let sectionA = Section(items: FakeViewModel(), FakeViewModel(), headerTitle: "Header")
        let sectionB = Section(items: FakeViewModel(), FakeViewModel(), footerTitle: "Footer")
        var dataSource = DataSource(sections: sectionA, sectionB)

        // WHEN: we append an item in a specific section
        let newItem = FakeViewModel()
        let section = 1
        dataSource.append(newItem, inSection: section)

        let sectionItems = dataSource.items(inSection: section)
        let insertedIndex = sectionItems?.index(of: newItem)

        // THEN: the item is appended in the specific section
        XCTAssertEqual(insertedIndex, sectionItems!.count - 1, "New item should be at the requested index")
        XCTAssertEqual(newItem, sectionItems?.last, "New item should be at the end of the requested section")
    }

    func test_thatDataSource_doesNotInsertData_atOutOfBounds_Section() {
        // GIVEN: a data source
        let sectionA = Section(items: FakeViewModel(), FakeViewModel(), headerTitle: "Header")
        let sectionB = Section(items: FakeViewModel(), FakeViewModel(), footerTitle: "Footer")
        var dataSource = DataSource(sections: sectionA, sectionB)

        // WHEN: we add an item at a section that doesn't exist
        let newItem = FakeViewModel()
        let ip = IndexPath(item: 1, section: 2)
        dataSource.insert(item: newItem, at: ip)

        let sectionItems = dataSource.items(inSection: 2)

        // THEN: the section should not exist hence the item should not be added
        XCTAssertNil(sectionItems, "The requested section doesn't exist")
    }

    func test_thatDataSource_doesNotInsertData_atOutOfBounds_Row() {
        // GIVEN: a data source
        let sectionA = Section(items: FakeViewModel(), FakeViewModel(), headerTitle: "Header")
        let sectionB = Section(items: FakeViewModel(), FakeViewModel(), footerTitle: "Footer")
        var dataSource = DataSource(sections: sectionA, sectionB)

        // WHEN: we add an item at an index that doesn't exist
        let newItem = FakeViewModel()
        let ip = IndexPath(item: 4, section: 1)
        dataSource.insert(item: newItem, at: ip)

        // THEN: the item should not be added
        XCTAssertFalse(dataSource.items(inSection: 1)!.contains(newItem), "The item shouldn't be added")
    }

    func test_thatDataSource_removesExpectedData_atIndexPath() {
        // GIVEN: a data source
        let sectionA = Section(items: FakeViewModel(), FakeViewModel(), headerTitle: "Header")
        let sectionB = Section(items: FakeViewModel(), FakeViewModel(), footerTitle: "Footer")
        var dataSource = DataSource(sections: sectionA, sectionB)

        // WHEN: we remove an item at a specific index path
        let ip = IndexPath(item: 1, section: 0)
        let itemToRemove = dataSource.remove(at: ip)

        // THEN: the item is removed
        XCTAssertNotNil(itemToRemove)
        XCTAssertEqual(dataSource.sections.count, 2)
        XCTAssertEqual(dataSource.items(inSection: 0)?.count, 1)
        XCTAssertEqual(dataSource.items(inSection: 1)?.count, 2)
        XCTAssertEqual(sectionA.count, 2, "Original section should not be changed")
    }

    func test_thatDataSource_doesNotRemoveData_fromInvalid_SectionOrRow() {
        // GIVEN: a data source
        let sectionA = Section(items: FakeViewModel(), FakeViewModel(), headerTitle: "Header")
        let sectionB = Section(items: FakeViewModel(), FakeViewModel(), footerTitle: "Footer")
        var dataSource = DataSource(sections: sectionA, sectionB)

        // WHEN: we remove an item from an invalid section or row
        let invalidIndex = 2
        let itemToRemoveA = dataSource.remove(atRow: 0, inSection: invalidIndex)
        let itemToRemoveB = dataSource.remove(atRow: invalidIndex, inSection: 0)

        // THEN: the returned items should be nil
        XCTAssertNil(itemToRemoveA, "The section \(invalidIndex) doesn't exist")
        XCTAssertNil(itemToRemoveB, "There should be no item in row \(invalidIndex)")
    }

    func test_thatDataSource_returnsItem_atIndexPath() {
        // GIVEN: a data source
        let model = FakeViewModel()
        let sectionA = Section(items: FakeViewModel(), FakeViewModel(), headerTitle: "Header")
        let sectionB = Section(items: FakeViewModel(), FakeViewModel(), footerTitle: "Footer")
        let sectionC = Section(items: FakeViewModel(), FakeViewModel(), model)
        let dataSource = DataSource(sections: sectionA, sectionB, sectionC)

        // WHEN: we ask for an item
        let ip = IndexPath(item: 2, section: 2)
        let item = dataSource.item(atIndexPath: ip)

        // THEN: we receive the expected data
        XCTAssertEqual(item, model)
    }
}
