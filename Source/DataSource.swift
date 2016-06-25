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

    /// The type of items in the data source.
    associatedtype Item

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
    func item(atIndexPath indexPath: NSIndexPath) -> Item? {
        return item(atRow: indexPath.row, inSection: indexPath.section)
    }
}


extension DataSourceProtocol where Self: NSFetchedResultsController {
    /**
     - parameter indexPath: An index path specifying a row and section in the data source.

     - returns: The item specified by indexPath, or `nil`.
     */
    public func item(atIndexPath indexPath: NSIndexPath) -> Item? {
        return (objectAtIndexPath(indexPath) as! Item)
    }
}


public struct DataSource<S: SectionInfoProtocol>: DataSourceProtocol {
    public var sections: [S]

    public init(_ sections: [S]) {
        self.sections = sections
    }

    public init(sections: S...) {
        self.sections = sections
    }

    public func numberOfSections() -> Int {
        return sections.count
    }

    public func numberOfItems(inSection section: Int) -> Int {
        guard section < sections.count else { return 0 }
        return sections[section].items.count
    }

    public func items(inSection section: Int) -> [S.Item]? {
        guard section < sections.count else { return nil }
        return sections[section].items
    }

    public func item(atRow row: Int, inSection section: Int) -> S.Item? {
        guard let items = items(inSection: section) else { return nil }
        guard row < items.count else { return nil }
        return items[row]
    }

    public func headerTitle(inSection section: Int) -> String? {
        guard section < sections.count else { return nil }
        return sections[section].headerTitle
    }

    public func footerTitle(inSection section: Int) -> String? {
        guard section < sections.count else { return nil }
        return sections[section].footerTitle
    }

    public subscript (index: Int) -> S {
        get {
            return sections[index]
        }
        set {
            sections[index] = newValue
        }
    }

    public subscript (indexPath: NSIndexPath) -> S.Item {
        get {
            return sections[indexPath.section].items[indexPath.row]
        }
        set {
            sections[indexPath.section].items[indexPath.row] = newValue
        }
    }
}


public class FetchedResultsController<T: NSManagedObject>: NSFetchedResultsController {
    public override init(fetchRequest: NSFetchRequest,
                  managedObjectContext context: NSManagedObjectContext,
                                       sectionNameKeyPath: String?,
                                       cacheName name: String?) {
        super.init(fetchRequest: fetchRequest,
                   managedObjectContext: context,
                   sectionNameKeyPath: sectionNameKeyPath,
                   cacheName: name)
    }

    public subscript (indexPath: NSIndexPath) -> T {
        get {
            return objectAtIndexPath(indexPath) as! T
        }
    }
}


extension FetchedResultsController: DataSourceProtocol {
    public typealias Item = T

    public func numberOfSections() -> Int {
        return sections?.count ?? 0
    }

    public func numberOfItems(inSection section: Int) -> Int {
        return sections?[section].numberOfObjects ?? 0
    }

    public func items(inSection section: Int) -> [Item]? {
        return (sections?[section].objects as! [Item])
    }

    public func item(atRow row: Int, inSection section: Int) -> Item? {
        return item(atIndexPath: NSIndexPath(forRow: row, inSection: section))
    }

    public func headerTitle(inSection section: Int) -> String? {
        return sections?[section].name
    }

    public func footerTitle(inSection section: Int) -> String? {
        return nil
    }
}
