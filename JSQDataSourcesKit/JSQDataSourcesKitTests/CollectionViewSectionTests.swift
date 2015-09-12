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

    func test_ThatCollectionViewSectionReturnsExpectedDataFromSubscript() {

        // GIVEN: a model and a collection view section
        let expectedModel = FakeCollectionModel()
        let section = CollectionViewSection(dataItems: [FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel(), expectedModel])

        // WHEN: we ask for an item at a specific index
        let item = section[3]

        // THEN: we receive the expected item
        XCTAssertEqual(item, expectedModel, "Model returned from subscript should equal expected model")
    }

    func test_ThatCollectionViewSectionSetsExpectedDataAtSubscript() {

        // GIVEN: a collection view section
        var section = CollectionViewSection(dataItems: [FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel()])
        let count = section.count

        // WHEN: we set an item at a specific index
        let index = 1
        let expectedModel = FakeCollectionModel()
        section[index] = expectedModel

        // THEN: the item at the specified index is replaced with the new item
        XCTAssertEqual(section[index], expectedModel, "Model set at subscript should equal expected model")
        XCTAssertEqual(count, section.count, "Section count should remain unchanged")
    }

    func test_ThatCollectionViewSectionReturnsExpectedCount() {

        // GIVEN: items and a collection view section
        let items = [FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel()]
        let section = CollectionViewSection(dataItems: items)

        // WHEN: we ask the section for its count
        let count = section.count

        // THEN: we receive the expected count
        XCTAssertEqual(count, items.count, "Count should equal expected count")
        XCTAssertEqual(count, section.dataItems.count, "Count should equal expected count")
    }
    
}
