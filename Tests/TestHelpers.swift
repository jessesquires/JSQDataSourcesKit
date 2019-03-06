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

let defaultTimeout = TimeInterval(5)

// MARK: model

struct FakeViewModel: Equatable, CustomStringConvertible {
    let name = UUID().uuidString

    var description: String {
        return "<\(FakeViewModel.self): \(name)>"
    }

    static func == (lhs: FakeViewModel, rhs: FakeViewModel) -> Bool {
        return lhs.name == rhs.name
    }
}

@discardableResult
func generateThings(_ context: NSManagedObjectContext, color: Color) -> [Thing] {
    var all = [Thing]()
    for _ in 0..<3 {
        let thing = Thing.newThing(context)
        thing.color = color
        all.append(thing)
    }

    all.sort { t1, t2 -> Bool in
        t1.name <= t2.name
    }
    return all
}

// MARK: table view

class FakeTableCell: UITableViewCell { }

class FakeTableView: UITableView {
    var dequeueCellExpectation: XCTestExpectation?

    override func dequeueReusableCell(withIdentifier identifier: String,
                                      for indexPath: IndexPath) -> UITableViewCell {
        dequeueCellExpectation?.fulfill()
        return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
}

// MARK: collection view

class FakeCollectionCell: UICollectionViewCell { }

class FakeCollectionSupplementaryView: UICollectionReusableView { }

let fakeSupplementaryViewKind = "FakeSupplementaryViewKind"

class FakeCollectionView: UICollectionView {

    var dequeueCellExpectation: XCTestExpectation?

    var dequeueSupplementaryViewExpectation: XCTestExpectation?

    override func dequeueReusableCell(withReuseIdentifier identifier: String,
                                      for indexPath: IndexPath) -> UICollectionViewCell {
        dequeueCellExpectation?.fulfill()
        return super.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

    override func dequeueReusableSupplementaryView(ofKind elementKind: String,
                                                   withReuseIdentifier identifier: String,
                                                   for indexPath: IndexPath) -> UICollectionReusableView {
        dequeueSupplementaryViewExpectation?.fulfill()
        return super.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath)
    }
}

class FakeFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String,
                                                       at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == fakeSupplementaryViewKind {
            return UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        }
        return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
    }
}
