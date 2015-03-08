//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQDataSourcesKit
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

import UIKit
import Foundation
import XCTest
import JSQDataSourcesKit


// MARK: fakes

struct FakeCollectionModel: Equatable {
    let name = NSProcessInfo.processInfo().globallyUniqueString
}


func ==(lhs: FakeCollectionModel, rhs: FakeCollectionModel) -> Bool {
    return lhs.name == rhs.name
}


class FakeCollectionCell: UICollectionViewCell { }


class FakeCollectionSupplementaryView: UICollectionReusableView { }


class FakeCollectionView: UICollectionView {

    var dequeueCellExpectation: XCTestExpectation?

    var dequeueSupplementaryViewExpectation: XCTestExpectation?

    override func dequeueReusableCellWithReuseIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath!) -> AnyObject {
        dequeueCellExpectation?.fulfill()
        return super.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
    }

    override func dequeueReusableSupplementaryViewOfKind(elementKind: String, withReuseIdentifier identifier: String, forIndexPath indexPath: NSIndexPath!) -> AnyObject {
        dequeueSupplementaryViewExpectation?.fulfill()
        return super.dequeueReusableSupplementaryViewOfKind(elementKind, withReuseIdentifier: identifier, forIndexPath: indexPath)
    }
}


// MARK: test case

class CollectionViewDataSourceTests: XCTestCase {

    // MARK: setup

    let fakeCellReuseId = "fakeCellId"
    let fakeSupplementaryViewReuseId = "fakeSupplementaryId"
    let fakeSupplementaryViewKind = "fakeSupplementaryKind"

    let fakeCollectionView = FakeCollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 600), collectionViewLayout: UICollectionViewFlowLayout())
    let dequeueCellExpectationName = "collectionview_dequeue_cell_expectation"
    let dequeueSupplementaryViewExpectationName = "collectionview_dequeue_supplementaryview_expectation"

    override func setUp() {
        super.setUp()

        fakeCollectionView.registerClass(FakeCollectionCell.self, forCellWithReuseIdentifier: fakeCellReuseId)
        fakeCollectionView.registerClass(FakeCollectionSupplementaryView.self, forSupplementaryViewOfKind: fakeSupplementaryViewKind, withReuseIdentifier: fakeSupplementaryViewReuseId)
    }
    
    override func tearDown() {
        super.tearDown()
    }


    // MARK: tests

    func test_ThatCollectionViewSectionReturnsExpectedDataFromSubscript() {

        // GIVEN: a model and a collection view section
        let expectedModel = FakeCollectionModel()
        let section = CollectionViewSection(dataItems: [FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel(), expectedModel])

        // WHEN: we ask for an item at a specific index
        let item = section[3]

        // THEN: we receive the expected item
        XCTAssertEqual(item, expectedModel, "Model returned from subscript should equal expected model")
    }

}






































