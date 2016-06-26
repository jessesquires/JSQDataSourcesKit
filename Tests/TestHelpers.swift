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

import CoreData
import Foundation
import UIKit
import XCTest
import ExampleModel


let defaultTimeout = NSTimeInterval(5)


// MARK: model

struct FakeViewModel: Equatable, CustomStringConvertible {
    let name = NSUUID().UUIDString

    var description: String {
        get {
            return "<\(FakeViewModel.self): \(name)>"
        }
    }
}

func ==(lhs: FakeViewModel, rhs: FakeViewModel) -> Bool {
    return lhs.name == rhs.name
}

func generateThings(context: NSManagedObjectContext, color: Color) -> [Thing] {
    var all = [Thing]()
    for _ in 0..<3 {
        let thing = Thing.newThing(context)
        thing.color = color
        all.append(thing)
    }

    all.sortInPlace { (t1, t2) -> Bool in
        return t1.name <= t2.name
    }
    return all
}


// MARK: table view

class FakeTableCell: UITableViewCell { }

class FakeTableView: UITableView {
    var dequeueCellExpectation: XCTestExpectation?

    override func dequeueReusableCellWithIdentifier(identifier: String,
                                                    forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        dequeueCellExpectation?.fulfill()
        return super.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
    }
}


// MARK: collection view

class FakeCollectionCell: UICollectionViewCell { }

class FakeCollectionSupplementaryView: UICollectionReusableView { }

let fakeSupplementaryViewKind = "FakeSupplementaryViewKind"

class FakeCollectionView: UICollectionView {

    var dequeueCellExpectation: XCTestExpectation?

    var dequeueSupplementaryViewExpectation: XCTestExpectation?

    override func dequeueReusableCellWithReuseIdentifier(identifier: String,
                                                         forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        dequeueCellExpectation?.fulfill()
        return super.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
    }

    override func dequeueReusableSupplementaryViewOfKind(elementKind: String,
                                                         withReuseIdentifier identifier: String,
                                                                             forIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        dequeueSupplementaryViewExpectation?.fulfill()
        return super.dequeueReusableSupplementaryViewOfKind(elementKind, withReuseIdentifier: identifier, forIndexPath: indexPath)
    }
}

class FakeFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String,
                                                             atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == fakeSupplementaryViewKind {
            return UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
        }
        return super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: indexPath)
    }
}
