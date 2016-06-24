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
//  Copyright © 2015 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import XCTest

class TestCase: XCTestCase {

    let cellReuseId = "fakeCellId"

    let supplementaryViewReuseId = "fakeSupplementaryId"
    let collectionView = FakeCollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 600),
                                                    collectionViewLayout: FakeFlowLayout())

    let tableView = FakeTableView(frame: CGRect(x: 0, y: 0, width: 320, height: 600), style: .Plain)

    override func setUp() {
        super.setUp()

        collectionView.registerClass(FakeCollectionCell.self,
                                     forCellWithReuseIdentifier: cellReuseId)

        collectionView.registerClass(FakeCollectionSupplementaryView.self,
                                     forSupplementaryViewOfKind: fakeSupplementaryViewKind,
                                     withReuseIdentifier: supplementaryViewReuseId)

        tableView.registerClass(FakeTableCell.self, forCellReuseIdentifier: cellReuseId)
    }
}
