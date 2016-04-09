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

import Foundation
import UIKit
import XCTest

import JSQDataSourcesKit


// Fakes for testing

typealias CellFactory = CollectionViewCellFactory<FakeCollectionCell, FakeViewModel>
typealias SupplementaryViewFactory = CollectionSupplementaryViewFactory<FakeCollectionSupplementaryView, FakeViewModel>
typealias Section = CollectionViewSection<FakeViewModel>
typealias Provider = CollectionViewDataSourceProvider<Section, CellFactory, SupplementaryViewFactory>


class FakeCollectionCell: UICollectionViewCell {

}


class FakeCollectionSupplementaryView: UICollectionReusableView {

}


class FakeCollectionView: UICollectionView {

    var dequeueCellExpectation: XCTestExpectation?

    var dequeueSupplementaryViewExpectation: XCTestExpectation?

    override func dequeueReusableCellWithReuseIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        dequeueCellExpectation?.fulfill()
        return super.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
    }

    override func dequeueReusableSupplementaryViewOfKind(elementKind: String, withReuseIdentifier identifier: String, forIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        dequeueSupplementaryViewExpectation?.fulfill()
        return super.dequeueReusableSupplementaryViewOfKind(elementKind, withReuseIdentifier: identifier, forIndexPath: indexPath)
    }
}


let FakeSupplementaryViewKind = "FakeSupplementaryViewKind"


class FakeFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == FakeSupplementaryViewKind {
            return UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
        }

        return super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: indexPath)
    }
}
