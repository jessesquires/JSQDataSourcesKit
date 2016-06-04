//
//  XCTestCase.swift
//  Example
//
//  Created by Сергей on 04.06.16.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    /**
     Scrolls down the current view halfscreen.
     */
    internal func scrollHalfScreenDown() {
        scrollScreenVerticallyWithOffset(-1 * XCUIApplication().windows.elementBoundByIndex(0).frame.height / 2)
    }
    
    /**
     Scrolls down the current view halfscreen.
     */
    internal func scrollHalfScreenUp() {
        scrollScreenVerticallyWithOffset(XCUIApplication().windows.elementBoundByIndex(0).frame.height / 2)
    }
    
    /**
     Scrolls the current view.
     
     - parameter offset: Number of points that a view should be scrolled by.
     */
    internal func scrollScreenVerticallyWithOffset(offset: CGFloat) {
        let mainWindow = XCUIApplication().windows.elementBoundByIndex(0)
        
        // `start` is exactly the center of the main window
        let start = mainWindow.coordinateWithNormalizedOffset(CGVector(dx: 0.5, dy: 0.5))
        
        let end = start.coordinateWithOffset(CGVector(dx: 0, dy: offset))
        
        start.pressForDuration(0, thenDragToCoordinate: end)
    }
    
    /**
     Taps the status bar so the view is scrolled up at the beginning.
     
     - warning: Will not work if In-Call status bar is presented.
     */
    internal func scrollOnStatusBarTap() {
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
    internal func countElements(ofType type: XCUIElementType,
                                       inView view: XCUIElement,
                                              byUniqueIdentifier indentifier: (XCUIElement) -> String) -> Int {
        
        var accumulator = Set<String>()

        var setOfVisibleElementsIdentifiersBeforeScroll = Set<String>()
        var setOfVisibleElementsIdentifiersAfterScroll = Set<String>()
        
        // Repeat until scrolling makes no changes.
        repeat {
            
            setOfVisibleElementsIdentifiersBeforeScroll = setOfVisibleElementsIdentifiersAfterScroll
            
            setOfVisibleElementsIdentifiersAfterScroll.removeAll()
            
            let currentlyVisibleElements = view.descendantsMatchingType(type).allElementsBoundByIndex.filter{ $0.hittable }
            
            for cellIndex in 0 ..< currentlyVisibleElements.count {
                setOfVisibleElementsIdentifiersAfterScroll.insert(indentifier(currentlyVisibleElements[cellIndex]))
            }
            
            accumulator = accumulator.union(setOfVisibleElementsIdentifiersAfterScroll)
            
            scrollHalfScreenDown()
            
        } while setOfVisibleElementsIdentifiersAfterScroll != setOfVisibleElementsIdentifiersBeforeScroll
        
        
        return accumulator.count
    }
}
