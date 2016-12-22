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
import CoreData

/**
 An instance conforming to `DataSourceProtocol` represents a data source of items to be displayed
 in either a collection view or table view.
 */
public protocol DataSourceProtocol {

    // MARK: Associated types

    /// The type of items in the data source.
    associatedtype Item


    // MARK: Methods

    /**
     - returns: The number of sections.
     */
    func numberOfSections() -> Int

    /**
     - parameter section: A section in the data source.

     - returns: The number of items in the specified section.
     */
    func numberOfItems(inSection section: Int) -> Int

    /**
     - parameter section: A section in the data source.

     - returns: The items in the specified section.
     */
    func items(inSection section: Int) -> [Item]?

    /**
     - parameter row:     A row in the data source.
     - parameter section: A section in the data source.

     - returns: The item specified by the section and row, or `nil`.
     */
    func item(atRow row: Int, inSection section: Int) -> Item?

    /**
     - parameter section: A section in the data source.

     - returns: The header title for the specified section.
     */
    func headerTitle(inSection section: Int) -> String?

    /**
     - parameter section: A section in the data source.

     - returns: The footer title for the specified section.
     */
    func footerTitle(inSection section: Int) -> String?
}


extension DataSourceProtocol {
    /**
     - parameter indexPath: An index path specifying a row and section in the data source.

     - returns: The item specified by indexPath, or `nil`.
     */
    public func item(atIndexPath indexPath: IndexPath) -> Item? {
        return item(atRow: indexPath.row, inSection: indexPath.section)
    }
}


/**
 A instance of `DataSource` is a concrete `DataSourceProtocol`.
 It is a collection of section-based data.
 */
public struct DataSource<S: SectionInfoProtocol>: DataSourceProtocol {

    // MARK: Properties

    /// The sections in the data source.
    public var sections: [S]


    // MARK: Initialization

    /**
     Constructs a new `DataSource`.

     - parameter sections: The sections for the data source.

     - returns: A new `DataSource` instance.
     */
    public init(_ sections: [S]) {
        self.sections = sections
    }

    /**
     Constructs a new `DataSource`.

     - parameter sections: The sections for the data source.

     - returns: A new `DataSource` instance.
     */
    public init(sections: S...) {
        self.sections = sections
    }

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
    public func items(inSection section: Int) -> [S.Item]? {
        guard section < sections.count else { return nil }
        return sections[section].items
    }

    /// :nodoc:
    public func item(atRow row: Int, inSection section: Int) -> S.Item? {
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


    // MARK: Methods
    
    /**
     Inserts the item at the specified index path.
     
     - parameter item:      The item to be inserted.
     - parameter indexPath: The index path specifying the location for the item.
     */
    public mutating func insert(item: S.Item, at indexPath: IndexPath) {
        insert(item: item, atRow: indexPath.row, inSection: indexPath.section)
    }
    
    /**
     Inserts the item at the specified row and section.
     
     - parameter item:    The item to be inserted.
     - parameter row:     The row location for the item.
     - parameter section: The section location for the item.
     */
    public mutating func insert(item: S.Item, atRow row: Int, inSection section: Int) {
        guard section < numberOfSections() else { return }
        guard row <= numberOfItems(inSection: section) else { return }
        sections[section].items.insert(item, at: row)
    }
    
    /**
     Appends the item at the specified section.
     
     - parameter item:    The item to be appended.
     - parameter section: The section location for the item.
     */
    public mutating func append(_ item: S.Item, inSection section: Int) {
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
    public mutating func remove(atRow row: Int, inSection section: Int) -> S.Item? {
        guard item(atRow: row, inSection: section) != nil else { return nil }
        return sections[section].items.remove(at: row)
    }

    /**
     Removes the item at the specified index path.

     - parameter indexPath: The index path specifying the location of the item.
     - returns: The item at `indexPath`, or `nil` if it does not exist.
     */
    @discardableResult
    public mutating func remove(at indexPath: IndexPath) -> S.Item? {
        return remove(atRow: indexPath.row, inSection: indexPath.section)
    }


    // MARK: Subscripts

    /**
     - parameter index: The index of a section.
     - returns: The section at `index`.
     */
    public subscript (index: Int) -> S {
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
    public subscript (indexPath: IndexPath) -> S.Item {
        get {
            return sections[indexPath.section].items[indexPath.row]
        }
        set {
            sections[indexPath.section].items[indexPath.row] = newValue
        }
    }
}


/// A generic `NSFetchedResultsController`.
public class FetchedResultsController<T: NSFetchRequestResult>: NSFetchedResultsController<NSFetchRequestResult> {

    /**
     Returns a fetch request controller initialized using the given arguments.

     - parameter fetchRequest:       The fetch request used to get the objects.
     - parameter context:            The managed object against which `fetchRequest` is executed.
     - parameter sectionNameKeyPath: A key path on result objects that returns the section name.
     - parameter name:               The name of the cache file the receiver should use.

     - returns: An initialized fetch request controller.
     */
    public init<T: NSFetchRequestResult>(fetchRequest: NSFetchRequest<T>,
                managedObjectContext context: NSManagedObjectContext,
                sectionNameKeyPath: String?,
                cacheName name: String?) {
        super.init(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>,
                   managedObjectContext: context,
                   sectionNameKeyPath: sectionNameKeyPath,
                   cacheName: name)
    }

    /**
     - parameter indexPath: The index path of an object.
     - returns: The object at `indexPath`.
     */
    public subscript (indexPath: IndexPath) -> T {
        get {
            return object(at: indexPath) as! T
        }
    }
}


extension FetchedResultsController: DataSourceProtocol {
    /// :nodoc:
    public typealias Item = T

    /// :nodoc:
    public func numberOfSections() -> Int {
        return sections?.count ?? 0
    }

    /// :nodoc:
    public func numberOfItems(inSection section: Int) -> Int {
        guard section < numberOfSections() else { return 0 }
        return sections?[section].numberOfObjects ?? 0
    }

    /// :nodoc:
    public func items(inSection section: Int) -> [Item]? {
        guard section < numberOfSections() else { return nil }
        return sections?[section].objects as! [Item]?
    }

    /// :nodoc:
    public func item(atRow row: Int, inSection section: Int) -> Item? {
        guard section < numberOfSections() else { return nil }
        guard let objects = sections?[section].objects else { return nil }
        guard row < objects.count else { return nil }
        return object(at: IndexPath(row: row, section: section)) as? Item
    }

    /// :nodoc:
    public func headerTitle(inSection section: Int) -> String? {
        guard section < numberOfSections() else { return nil }
        return sections?[section].name
    }
    
    /// :nodoc:
    public func footerTitle(inSection section: Int) -> String? {
        return nil
    }
}

extension FetchedResultsController {

    /// :nodoc:
    public func item(atIndexPath indexPath: IndexPath) -> Item? {
        return object(at: indexPath) as? Item
    }
}
