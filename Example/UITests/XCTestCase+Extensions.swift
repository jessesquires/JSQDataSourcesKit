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

typealias XCUIElementType = XCUIElement.ElementType

extension XCTestCase {

    /**
     Returns to the previous screen in navigation stack if Back button is availible
     */
    func returnBackIfPossible() {
        let backButton = XCUIApplication().navigationBars.buttons.matching(identifier: "Back").element(boundBy: 0)

        if backButton.exists && backButton.isHittable {
            backButton.tap()
        }
    }

    /**
     Scrolls down the current view halfscreen.
     */
    func scrollHalfScreenDown() {
        scrollScreenVerticallyWithOffset(-0.8 * XCUIApplication().windows.element(boundBy: 0).frame.height / 2)
    }

    /**
     Scrolls down the current view halfscreen.
     */
    func scrollHalfScreenUp() {
        scrollScreenVerticallyWithOffset(0.8 * XCUIApplication().windows.element(boundBy: 0).frame.height / 2)
    }

    /**
     Scrolls the current view.
     
     - parameter offset: Number of points that a view should be scrolled by.
     */
    func scrollScreenVerticallyWithOffset(_ offset: CGFloat) {
        let mainWindow = XCUIApplication().windows.element(boundBy: 0)

        // `start` is exactly the center of the main window
        let start = mainWindow.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))

        let end = start.withOffset(CGVector(dx: 0, dy: offset))

        start.press(forDuration: 0, thenDragTo: end)
    }

    /**
     Taps the status bar so the view is scrolled up at the beginning.
     
     - warning: Will not work if In-Call status bar is presented.
     */
    func scrollOnStatusBarTap() {
        XCUIApplication().statusBars.element.tap()
    }

    /**
     Counts elements of a specific type in `view` by repeatedly scrolling it.
     
     **Example**
     
     let foo = countElements(ofType: .Cell,
     inView: table,
     byUniqueIdentifier: { $0.identifier })
     
     - important: This method scrolls from the current position down to the end. Make sure you scroll to the top before and
     after calling it.
     - parameter type: A type of elements to count.
     - parameter view: A view to count elements in.
     - parameter indentifier: A closure that takes an element and returns some value associated with it. This value has
     to be unique, otherwise this method will not function properly.
     
     - returns: The number of presented unique elements.
     */
    func countElements(ofType type: XCUIElementType,
                       inView view: XCUIElement,
                       byUniqueIdentifier identifier: (XCUIElement) -> String) -> Int {
        var accumulator = Set<String>()

        var setOfVisibleElementsIdentifiersBeforeScroll = Set<String>()
        var setOfVisibleElementsIdentifiersAfterScroll = Set<String>()

        // Repeat until scrolling makes no changes.
        repeat {
            setOfVisibleElementsIdentifiersAfterScroll = setOfVisibleElementsIdentifiersBeforeScroll

            let currentlyVisibleElements = view.descendants(matching: type).allElementsBoundByIndex.filter { $0.isHittable }

            setOfVisibleElementsIdentifiersBeforeScroll = Set(currentlyVisibleElements.map { identifier($0) })

            accumulator = accumulator.union(setOfVisibleElementsIdentifiersBeforeScroll)

            scrollHalfScreenDown()

        } while setOfVisibleElementsIdentifiersAfterScroll != setOfVisibleElementsIdentifiersBeforeScroll

        return accumulator.count
    }

    ///  Sends a tap event to hittable elements of specified type.
    func tapOn(_ numberOfElementsToTapOn: Int,
               hittableElementsOfType type: XCUIElementType,
               inView view: XCUIElement) {
        let hittableElements = view.descendants(matching: type).allElementsBoundByIndex.filter { $0.isHittable }

        if hittableElements.count < numberOfElementsToTapOn {
            return
        }

        var numberOfElementsTapped = 0
        for element in hittableElements where numberOfElementsTapped < numberOfElementsToTapOn {
            element.tap()
            numberOfElementsTapped += 1
        }
    }
}
