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

private struct FakeCollectionModel: Equatable {
    let name = NSProcessInfo.processInfo().globallyUniqueString
}


private func ==(lhs: FakeCollectionModel, rhs: FakeCollectionModel) -> Bool {
    return lhs.name == rhs.name
}


private class FakeCollectionCell: UICollectionViewCell { }


private class FakeCollectionSupplementaryView: UICollectionReusableView { }


private class FakeCollectionView: UICollectionView {

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

    private let fakeCollectionView = FakeCollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 600), collectionViewLayout: UICollectionViewFlowLayout())
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

    func test_ThatCollectionViewDataSourceProviderReturnsExpectedDataFromSubscript() {

        // GIVEN: some collection view sections
        let section0 = CollectionViewSection(dataItems: [FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel()])
        let section1 = CollectionViewSection(dataItems: [FakeCollectionModel(), FakeCollectionModel()])
        let section2 = CollectionViewSection(dataItems: [FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel()])
        let sections = [section0, section1, section2]

        // GIVEN: a cell factory
        let cellFactory = CollectionViewCellFactory(reuseIdentifier: "reuseId", cellConfigurator: { (cell: UICollectionViewCell, model: FakeCollectionModel, view: UICollectionView, index: NSIndexPath) -> UICollectionViewCell in
            return cell
        })

        // GIVEN: a supplementary view factory
        let viewFactory = CollectionSupplementaryViewFactory(reuseIdentifier: "reuseId") { (view: UICollectionReusableView, model: FakeCollectionModel, kind: String, collectionView: UICollectionView, index: NSIndexPath) -> UICollectionReusableView in
            return view
        }

        // GIVEN: a data source provider
        let dataSourceProvider = CollectionViewDataSourceProvider(sections: sections, cellFactory: cellFactory, supplementaryViewFactory: viewFactory)
        
        // WHEN: we ask for a section at a specific index
        let section = dataSourceProvider[1]

        // THEN: we receive the expected section
        XCTAssertEqual(section.dataItems, section1.dataItems, "Section returned from subscript should equal expected section")
    }

    func test_ThatCollectionViewDataSourceProviderSetsExpectedDataAtSubscript() {

        // GIVEN: some collection view sections
        let section0 = CollectionViewSection(dataItems: [FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel()])
        let section1 = CollectionViewSection(dataItems: [FakeCollectionModel(), FakeCollectionModel()])
        let section2 = CollectionViewSection(dataItems: [FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel(), FakeCollectionModel()])
        let sections = [section0, section1, section2]

        // GIVEN: a cell factory
        let cellFactory = CollectionViewCellFactory(reuseIdentifier: "reuseId", cellConfigurator: { (cell: UICollectionViewCell, model: FakeCollectionModel, view: UICollectionView, index: NSIndexPath) -> UICollectionViewCell in
            return cell
        })

        // GIVEN: a supplementary view factory
        let viewFactory = CollectionSupplementaryViewFactory(reuseIdentifier: "reuseId") { (view: UICollectionReusableView, model: FakeCollectionModel, kind: String, collectionView: UICollectionView, index: NSIndexPath) -> UICollectionReusableView in
            return view
        }

        // GIVEN: a data source provider
        let dataSourceProvider = CollectionViewDataSourceProvider(sections: sections, cellFactory: cellFactory, supplementaryViewFactory: viewFactory)
        let count = dataSourceProvider.sections.count

        // WHEN: we set a section at a specific index
        let index = 0
        let expectedSection = CollectionViewSection(dataItems: [FakeCollectionModel(), FakeCollectionModel()])
        dataSourceProvider[index] = expectedSection

        // THEN: the section at the specified index is replaced with the new section
        XCTAssertEqual(dataSourceProvider[index].dataItems, expectedSection.dataItems, "Section set at subscript should equal expected section")
        XCTAssertEqual(count, dataSourceProvider.sections.count, "Number of sections should remain unchanged")
    }

}
