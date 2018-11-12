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

import CoreData
import Foundation

/// A generic `NSFetchedResultsController`.
public class FetchedResultsController<T: NSFetchRequestResult>: NSFetchedResultsController<NSFetchRequestResult> {

    /// Returns a fetch request controller initialized using the given arguments.
    ///
    /// - Parameters:
    ///   - fetchRequest:       The fetch request used to get the objects.
    ///   - context:            The managed object against which `fetchRequest` is executed.
    ///   - sectionNameKeyPath: A key path on result objects that returns the section name.
    ///   - name:               The name of the cache file the receiver should use.

    /// - Returns: An initialized fetch request controller.
    public init<T>(fetchRequest: NSFetchRequest<T>,
                   managedObjectContext context: NSManagedObjectContext,
                   sectionNameKeyPath: String?,
                   cacheName name: String?) {
        super.init(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>,
                   managedObjectContext: context,
                   sectionNameKeyPath: sectionNameKeyPath,
                   cacheName: name)
    }

    /// - Parameter indexPath: The index path of an object.
    /// - Returns: The object at `indexPath`.
    public subscript (indexPath: IndexPath) -> T {
        return object(at: indexPath) as! T
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
