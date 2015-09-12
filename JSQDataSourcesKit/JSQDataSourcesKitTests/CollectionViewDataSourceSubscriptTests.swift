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


class CollectionViewDataSourceSubscriptTests: XCTestCase {

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
        let allSections = [section0, section1, section2]

        // GIVEN: a cell factory
        let factory = CollectionViewCellFactory(reuseIdentifier: "cellId") { (cell: FakeCollectionCell, model: FakeCollectionModel, view: UICollectionView, index: NSIndexPath) -> FakeCollectionCell in
            return cell
        }

        // GIVEN: a data source provider
        let dataSourceProvider: Provider = CollectionViewDataSourceProvider(sections: allSections, cellFactory: factory)
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
