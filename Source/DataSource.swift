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

/// A `DataSource` is a concrete `DataSourceProtocol`.
/// It represents a collection of section-based data.
public struct DataSource<Item> {

    // MARK: Properties

    /// The sections in the data source.
    public var sections: [Section<Item>]

    // MARK: Initialization

    /// Constructs a new `DataSource`.
    ///
    /// - Parameter sections: The sections for the data source.
    public init(_ sections: [Section<Item>]) {
        self.sections = sections
    }

    /// Constructs a new `DataSource`.
    ///
    /// - Parameter sections: The sections for the data source.
    public init(sections: Section<Item>...) {
        self.sections = sections
    }

    // MARK: Methods

    /**
     Inserts the item at the specified index path.
     - parameter item:      The item to be inserted.
     - parameter indexPath: The index path specifying the location for the item.
     */
    public mutating func insert(item: Item, at indexPath: IndexPath) {
        insert(item: item, atRow: indexPath.row, inSection: indexPath.section)
    }

    /**
     Inserts the item at the specified row and section.
     - parameter item:    The item to be inserted.
     - parameter row:     The row location for the item.
     - parameter section: The section location for the item.
     */
    public mutating func insert(item: Item, atRow row: Int, inSection section: Int) {
        guard section < numberOfSections() else { return }
        guard row <= numberOfItems(inSection: section) else { return }
        sections[section].items.insert(item, at: row)
    }

    /**
     Appends the item at the specified section.
     - parameter item:    The item to be appended.
     - parameter section: The section location for the item.
     */
    public mutating func append(_ item: Item, inSection section: Int) {
        guard let items = items(inSection: section) else { return }
        insert(item: item, atRow: items.endIndex, inSection: section)
    }

    /**
     Removes the item at the specified row and section.
     - parameter row:     The row location of the item.
     - parameter section: The section location of the item.
     - returns: The item removed, or `nil` if it does not exist.
     */
    @discardableResult
    public mutating func remove(atRow row: Int, inSection section: Int) -> Item? {
        guard item(atRow: row, inSection: section) != nil else { return nil }
        return sections[section].items.remove(at: row)
    }

    /**
     Removes the item at the specified index path.
     - parameter indexPath: The index path specifying the location of the item.
     - returns: The item at `indexPath`, or `nil` if it does not exist.
     */
    @discardableResult
    public mutating func remove(at indexPath: IndexPath) -> Item? {
        return remove(atRow: indexPath.row, inSection: indexPath.section)
    }

    // MARK: Subscripts

    /**
     - parameter index: The index of a section.
     - returns: The section at `index`.
     */
    public subscript (index: Int) -> Section<Item> {
        get {
            return sections[index]
        }
        set {
            sections[index] = newValue
        }
    }

    /**
     - parameter indexPath: The index path of an item.
     - returns: The item at `indexPath`.
     */
    public subscript (indexPath: IndexPath) -> Item {
        get {
            return sections[indexPath.section].items[indexPath.row]
        }
        set {
            sections[indexPath.section].items[indexPath.row] = newValue
        }
    }
}

extension DataSource: DataSourceProtocol {
    /// :nodoc:
    public func numberOfSections() -> Int {
        return sections.count
    }

    /// :nodoc:
    public func numberOfItems(inSection section: Int) -> Int {
        guard section < sections.count else { return 0 }
        return sections[section].items.count
    }

    /// :nodoc:
    public func items(inSection section: Int) -> [Item]? {
        guard section < sections.count else { return nil }
        return sections[section].items
    }

    /// :nodoc:
    public func item(atRow row: Int, inSection section: Int) -> Item? {
        guard let items = items(inSection: section) else { return nil }
        guard row < items.count else { return nil }
        return items[row]
    }

    /// :nodoc:
    public func headerTitle(inSection section: Int) -> String? {
        guard section < sections.count else { return nil }
        return sections[section].headerTitle
    }

    /// :nodoc:
    public func footerTitle(inSection section: Int) -> String? {
        guard section < sections.count else { return nil }
        return sections[section].footerTitle
    }
}
