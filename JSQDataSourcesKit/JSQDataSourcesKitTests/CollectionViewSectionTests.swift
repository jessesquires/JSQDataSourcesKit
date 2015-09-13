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


class CollectionViewSectionTests: XCTestCase {

    func test_ThatCollectionViewSection_Initializes() {

        // GIVEN: some items
        let item1 = FakeCollectionModel()
        let item2 = FakeCollectionModel()
        let item3 = FakeCollectionModel()

        // WHEN: we create sections with the different initializers
        let sectionA = CollectionViewSection(items: item1, item2, item3)
        let sectionB = CollectionViewSection([item1, item2, item3])

        // THEN: the sections have the same items
        XCTAssertEqual(sectionA.items, sectionB.items, "Section items should be equal")
    }

    func test_ThatCollectionViewSection_ReturnsExpectedDataFromSubscript() {

        // GIVEN: a model and a collection view section
        let expectedModel = FakeCollectionModel()
        let section = CollectionViewSection(items: FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel(), expectedModel)

        // WHEN: we ask for an item at a specific index
        let item = section[3]

        // THEN: we receive the expected item
        XCTAssertEqual(item, expectedModel, "Model returned from subscript should equal expected model")
    }

    func test_ThatCollectionViewSection_SetsExpectedDataAtSubscript() {

        // GIVEN: a collection view section
        var section = CollectionViewSection(items: FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel())
        let count = section.count

        // WHEN: we set an item at a specific index
        let index = 1
        let expectedModel = FakeCollectionModel()
        section[index] = expectedModel

        // THEN: the item at the specified index is replaced with the new item
        XCTAssertEqual(section[index], expectedModel, "Model set at subscript should equal expected model")
        XCTAssertEqual(count, section.count, "Section count should remain unchanged")
    }

    func test_ThatCollectionViewSection_ReturnsExpectedCount() {

        // GIVEN: items and a collection view section
        let section = CollectionViewSection(items: FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel())

        // WHEN: we ask the section for its count
        let count = section.count

        // THEN: we receive the expected count
        XCTAssertEqual(4, count, "Count should equal expected count")
        XCTAssertEqual(4, section.items.count, "Count should equal expected count")
    }
    
}
