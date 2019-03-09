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

/// Represents and manages a section of items.
// Example /Source/ change to test danger
public struct Section<Item> {

    // MARK: Properties

    /// The elements in the section.
    public var items: [Item]

    /// The header title for the section.
    public let headerTitle: String?

    /// The footer title for the section.
    public let footerTitle: String?

    /// The number of elements in the section.
    public var count: Int {
        return items.count
    }

    // MARK: Initialization

    /// Constructs a new section.
    ///
    /// - Parameters:
    ///   - items: The elements in the section.
    ///   - headerTitle: The section header title.
    ///   - footerTitle: The section footer title.
    public init(items: Item..., headerTitle: String? = nil, footerTitle: String? = nil) {
        self.init(items, headerTitle: headerTitle, footerTitle: footerTitle)
    }

    /// Constructs a new section.
    ///
    /// - Parameters:
    ///   - items: The elements in the section.
    ///   - headerTitle: The section header title.
    ///   - footerTitle: The section footer title.
    public init(_ items: [Item], headerTitle: String? = nil, footerTitle: String? = nil) {
        self.items = items
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
    }

    // MARK: Subscripts

    /// - Parameter index: The index of the item to return.
    /// - Returns: The item at `index`.
    public subscript (index: Int) -> Item {
        get {
            return items[index]
        }
        set {
            items[index] = newValue
        }
    }
}
