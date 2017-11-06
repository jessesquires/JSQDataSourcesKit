//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://jessesquires.github.io/JSQDataSourcesKit
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
import XCTest

@testable import JSQDataSourcesKit


final class BridgedFetchedResultsDelegateTests: XCTestCase {

    func test_thatFetchedResultsDelegate_callsClosures_whenDelegateMethodsAreCalled() {
        let willChangeContentExpectation = self.expectation(description: "will change content")
        let didChangeSectionExpectation = self.expectation(description: "will change content")
        let didChangeObjectExpectation = self.expectation(description: "will change content")
        let didChangeContentExpectation = self.expectation(description: "will change content")

        // GIVEN: a fetched results delegate
        let delegate = BridgedFetchedResultsDelegate(
            willChangeContent: { (controller) in
                willChangeContentExpectation.fulfill()
            },
            didChangeSection: { (controller, sectionInfo, sectionIndex, changeType) in
                didChangeSectionExpectation.fulfill()
            },
            didChangeObject: { (controller, anyObject, indexPath: IndexPath?, changeType, newIndexPath: IndexPath?) in
                didChangeObjectExpectation.fulfill()
            },
            didChangeContent: { (controller) in
                didChangeContentExpectation.fulfill()
        })

        let controller = NSFetchedResultsController<NSFetchRequestResult>()

        class FakeSectionInfo: NSObject, NSFetchedResultsSectionInfo {
            @objc public var numberOfObjects: Int = 0
            @objc public var objects: [Any]?
            @objc public var name: String = "name"
            @objc public var indexTitle: String?
        }

        // WHEN: we call the NSFetchedResultsControllerDelegate methods
        delegate.controllerWillChangeContent(controller)
        delegate.controller(controller, didChange: FakeSectionInfo(), atSectionIndex: 0, for: .update)
        delegate.controller(controller, didChange: NSObject(), at: nil, for: .update, newIndexPath: nil)
        delegate.controllerDidChangeContent(controller)

        // THEN: the delegate executes its closures
        waitForExpectations(timeout: defaultTimeout) { (error) in
            XCTAssertNil(error, "Expectations should not error")
        }
    }
}
