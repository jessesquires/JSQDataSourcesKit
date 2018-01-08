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
import UIKit
import XCTest

import JSQDataSourcesKit

final class SectionTests: XCTestCase {

    func test_thatSection_initializes() {
        // GIVEN: some items
        let item1 = FakeViewModel()
        let item2 = FakeViewModel()
        let item3 = FakeViewModel()

        // WHEN: we create sections with the different initializers
        let sectionA = Section(items: item1, item2, item3, headerTitle: "Header")
        let sectionB = Section([item1, item2, item3], footerTitle: "Footer")

        // THEN: the sections have the same items
        XCTAssertEqual(sectionA.items, sectionB.items, "Section items should be equal")

        XCTAssertEqual(sectionA.count, 3)
        XCTAssertEqual(sectionA.headerTitle, "Header")
        XCTAssertNil(sectionA.footerTitle)

        XCTAssertEqual(sectionB.count, 3)
        XCTAssertEqual(sectionB.footerTitle, "Footer")
        XCTAssertNil(sectionB.headerTitle)
    }

    func test_thatSection_returnsExpectedDataFromSubscript() {
        // GIVEN: a model and section
        let expectedModel = FakeViewModel()
        let section = Section(items: FakeViewModel(), FakeViewModel(), expectedModel, FakeViewModel(), FakeViewModel())

        // WHEN: we ask for an item at a specific index
        let item = section[2]

        // THEN: we receive the expected item
        XCTAssertEqual(item, expectedModel, "Model returned from subscript should equal expected model")
    }

    func test_thatSection_setsExpectedDataAtSubscript() {
        // GIVEN: a section
        var section = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel())
        let count = section.items.count

        // WHEN: we set an item at a specific index
        let index = 1
        let expectedModel = FakeViewModel()
        section[index] = expectedModel

        // THEN: the item at the specified index is replaced with the new item
        XCTAssertEqual(section[index], expectedModel, "Model set at subscript should equal expected model")
        XCTAssertEqual(count, section.count, "Section count should remain unchanged")
    }

    func test_thatSection_returnsExpectedCount() {
        // GIVEN: items and a section
        let section = Section(items: FakeViewModel(), FakeViewModel(), FakeViewModel(), FakeViewModel())

        // WHEN: we ask the section for its count
        let count = section.count

        // THEN: we receive the expected count
        XCTAssertEqual(4, count, "Count should equal expected count")
        XCTAssertEqual(4, section.items.count, "Count should equal expected count")
    }
}
