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
import XCTest

@testable import JSQDataSourcesKit


final class BridgedFetchedResultsDelegateTests: XCTestCase {

    func test_thatFetchedResultsDelegate_callsClosures_whenDelegateMethodsAreCalled() {
        let willChangeContentExpectation = self.expectationWithDescription("will change content")
        let didChangeSectionExpectation = self.expectationWithDescription("will change content")
        let didChangeObjectExpectation = self.expectationWithDescription("will change content")
        let didChangeContentExpectation = self.expectationWithDescription("will change content")

        // GIVEN: a fetched results delegate
        let delegate = BridgedFetchedResultsDelegate(
            willChangeContent: { (controller) in
                willChangeContentExpectation.fulfill()
            },
            didChangeSection: { (controller, sectionInfo, sectionIndex, changeType) in
                didChangeSectionExpectation.fulfill()
            },
            didChangeObject: { (controller, anyObject, indexPath: NSIndexPath?, changeType, newIndexPath: NSIndexPath?) in
                didChangeObjectExpectation.fulfill()
            },
            didChangeContent: { (controller) in
                didChangeContentExpectation.fulfill()
        })

        let controller = NSFetchedResultsController()

        class FakeSectionInfo: NSObject, NSFetchedResultsSectionInfo {
            @objc var numberOfObjects: Int = 0
            @objc var objects: [AnyObject]?
            @objc var name: String = "name"
            @objc var indexTitle: String?
        }

        // WHEN: we call the NSFetchedResultsControllerDelegate methods
        delegate.controllerWillChangeContent(controller)
        delegate.controller(controller, didChangeSection: FakeSectionInfo(), atIndex: 0, forChangeType: .Update)
        delegate.controller(controller, didChangeObject: NSObject(), atIndexPath: nil, forChangeType: .Update, newIndexPath: nil)
        delegate.controllerDidChangeContent(controller)

        // THEN: the delegate executes its closures
        waitForExpectationsWithTimeout(defaultTimeout) { (error) in
            XCTAssertNil(error, "Expectations should not error")
        }
    }
}
