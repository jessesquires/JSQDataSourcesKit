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


class TitledCollectionReusableViewTests: XCTestCase {

    func test_ThatViewLoadsFromNib() {
        let nib = TitledCollectionReusableView.nib
        XCTAssertNotNil(nib)

        let identifier = TitledCollectionReusableView.identifier
        XCTAssertEqual(identifier, String(TitledCollectionReusableView.self))

        let views = NSBundle(forClass: TitledCollectionReusableView.self).loadNibNamed(
            "TitledCollectionReusableView",
            owner: nil,
            options: nil) as! [UIView]

        XCTAssertTrue(views.first is TitledCollectionReusableView)

        let titledView = views.first as! TitledCollectionReusableView
        XCTAssertNotNil(titledView.label)
        XCTAssertNotNil(titledView.topSpacing)
        XCTAssertNotNil(titledView.bottomSpacing)
        XCTAssertNotNil(titledView.leadingSpacing)
        XCTAssertNotNil(titledView.trailingSpacing)
    }

    func test_ThatViewPreparesForReuse() {
        let view = loadView()

        view.label.text = "title text"

        XCTAssertNotNil(view.label.text)

        view.prepareForReuse()

        XCTAssertNil(view.label.text)
    }

    func test_ThatViewSetsBackgoundColor() {
        let view = loadView()

        view.backgroundColor = .redColor()

        XCTAssertEqual(view.label.backgroundColor, view.backgroundColor)
        XCTAssertEqual(view.label.backgroundColor, .redColor())
    }


    // MARK: Helpers

    func loadView() -> TitledCollectionReusableView {
        return (NSBundle(forClass: TitledCollectionReusableView.self).loadNibNamed(
            "TitledCollectionReusableView",
            owner: nil,
            options: nil) as! [UIView]).first as! TitledCollectionReusableView
    }

}
