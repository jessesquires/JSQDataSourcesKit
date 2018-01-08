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

final class TitledSupplementaryViewTests: XCTestCase {

    func test_thatView_initializesWithFrame() {
        let identifier = TitledSupplementaryView.identifier
        XCTAssertEqual(identifier, String(describing: TitledSupplementaryView.self))

        let view = TitledSupplementaryView(frame: CGRect(x: 0, y: 0, width: 320, height: 100))
        view.layoutIfNeeded()

        XCTAssertEqual(view.verticalInset, 8)
        XCTAssertEqual(view.horizontalInset, 8)
        XCTAssertEqual(view.label.frame, CGRect(x: 8, y: 8, width: 304, height: 84))
    }

    func test_thatView_adjustsLabelFrameForInsets() {
        let identifier = TitledSupplementaryView.identifier
        XCTAssertEqual(identifier, String(describing: TitledSupplementaryView.self))

        let view = TitledSupplementaryView(frame: CGRect(x: 0, y: 0, width: 320, height: 100))
        view.verticalInset = 10
        view.horizontalInset = 4
        view.layoutIfNeeded()

        XCTAssertEqual(view.label.frame, CGRect(x: 4, y: 10, width: 312, height: 80))
    }

    func test_thatView_preparesForReuse_ForText() {
        let view = TitledSupplementaryView(frame: CGRect(x: 0, y: 0, width: 320, height: 100))
        view.layoutIfNeeded()
        view.label.text = "title text"

        XCTAssertNotNil(view.label.text)

        view.prepareForReuse()

        XCTAssertNil(view.label.text)
    }

    func test_thatView_preparesForReuse_ForAttributedText() {
        let view = TitledSupplementaryView(frame: CGRect(x: 0, y: 0, width: 320, height: 100))
        view.layoutIfNeeded()
        view.label.attributedText = NSAttributedString(string: "title text")

        XCTAssertNotNil(view.label.attributedText)

        view.prepareForReuse()

        XCTAssertNil(view.label.attributedText)
    }

    func test_thatView_setsBackgoundColor() {
        let view = TitledSupplementaryView(frame: CGRect(x: 0, y: 0, width: 320, height: 100))
        view.layoutIfNeeded()
        view.backgroundColor = .red

        XCTAssertEqual(view.label.backgroundColor, view.backgroundColor)
        XCTAssertEqual(view.label.backgroundColor, .red)
    }
}
