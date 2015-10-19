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


/**
A `CollectionViewSection` is a concrete `CollectionViewSectionInfo`.
A section instance is responsible for managing the elements in a section.
*/
public struct CollectionViewSection <Item>: CollectionViewSectionInfo, CustomStringConvertible {

    // MARK: Properties

    /// The elements in the collection view section.
    public var items: [Item]

    /// Returns the number of elements in the section.
    public var count: Int {
        return items.count
    }


    // MARK: Initialization

    /**
    Constructs a new collection view section.

    - parameter items: The elements in the section.
    - returns: A new `CollectionViewSection` instance.
    */
    public init(items: Item...) {
        self.init(items)
    }

    /**
    Constructs a new collection view section.

    - parameter items: The elements in the section.
    - returns: A new `CollectionViewSection` instance.
    */
    public init(_ items: [Item]) {
        self.items = items
    }


    // MARK: Subscripts

    /**
    - parameter index: The index of the item to return.
    - returns: The item at `index`.
    */
    public subscript (index: Int) -> Item {
        get {
            return items[index]
        }
        set {
            items[index] = newValue
        }
    }


    // MARK: CustomStringConvertible

    /// :nodoc:
    public var description: String {
        get {
            return "<\(CollectionViewSection.self): items=\(items)>"
        }
    }
}
