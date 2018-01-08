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

import XCTest

@testable import JSQDataSourcesKit

class DataSourceContainerTests: XCTestCase {
    
    private class FakeTableViewDataSource: NSObject, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
    
    private class FakeCollectionViewDataSource: NSObject, UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            return UICollectionViewCell()
        }
    }
    
    func test_thatDataSourceContainer_returnsExpectedDataSource_forAddedDataSources() {
        
        let tableViewDatasource: UITableViewDataSource = FakeTableViewDataSource()
        let collectionViewDatasource: UICollectionViewDataSource = FakeCollectionViewDataSource()
        
        var container = DataSourceContainer()
        container.add(dataSource: tableViewDatasource)
        container.add(dataSource: collectionViewDatasource)
        
        let tableViewResult = container[UITableViewDataSource.self]
        let collectionViewResult = container[UICollectionViewDataSource.self]
        
        XCTAssert(tableViewDatasource === tableViewResult)
        XCTAssert(collectionViewDatasource === collectionViewResult)
    }
    
    func test_thatDataSourceContainer_returnsNoDataSource_ifNotAdded() {
        
        let container = DataSourceContainer()
        
        let tableViewResult = container[UITableViewDataSource.self]
        let collectionViewResult = container[UICollectionViewDataSource.self]
        
        XCTAssertNil(tableViewResult)
        XCTAssertNil(collectionViewResult)
    }
}
