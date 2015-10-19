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


/**
A `TableViewSection` is a concrete `TableViewSectionInfo`.
A section instance is responsible for managing the elements in a section.
*/
public struct TableViewSection <Item>: TableViewSectionInfo, CustomStringConvertible {

    // MARK: Properties

    /// The elements in the collection view section.
    public var items: [Item]

    /// The header title for the section.
    public let headerTitle: String?

    /// The footer title for the section.
    public let footerTitle: String?

    /// Returns the number of elements in the section.
    public var count: Int {
        return items.count
    }


    // MARK: Initialization

    /**
    Constructs a new table view section.

    - parameter items:       The elements in the section.
    - parameter headerTitle: The section header title.
    - parameter footerTitle: The section footer title.

    - returns: A new `TableViewSection` instance.
    */
    public init(items: Item..., headerTitle: String? = nil, footerTitle: String? = nil) {
        self.init(items, headerTitle: headerTitle, footerTitle: footerTitle)
    }

    /**
    Constructs a new table view section.

    - parameter items:       The elements in the section.
    - parameter headerTitle: The section header title.
    - parameter footerTitle: The section footer title.

    - returns: A new `TableViewSection` instance.
    */
    public init(_ items: [Item], headerTitle: String? = nil, footerTitle: String? = nil) {
        self.items = items
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
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
            return "<\(TableViewSection.self): items=\(items)>"
        }
    }
}
