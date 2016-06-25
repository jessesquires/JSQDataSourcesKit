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


public protocol DataSourceProtocol {
    associatedtype Item

    func numberOfSections() -> Int

    func numberOfItemsIn(section section: Int) -> Int

    func itemsIn(section section: Int) -> [Item]?

    func itemAt(section section: Int, row: Int) -> Item?

    func itemAt(indexPath indexPath: NSIndexPath) -> Item?

    func headerTitleIn(section section: Int) -> String?

    func footerTitleIn(section section: Int) -> String?
}


public struct DataSource<S: SectionInfoProtocol>: DataSourceProtocol {
    public var sections: [S]

    public init(_ sections: [S]) {
        self.sections = sections
    }

    public func numberOfSections() -> Int {
        return sections.count
    }

    public func numberOfItemsIn(section section: Int) -> Int {
        return sections[section].items.count
    }

    public func itemsIn(section section: Int) -> [S.Item]? {
        return sections[section].items
    }

    public func itemAt(section section: Int, row: Int) -> S.Item? {
        return sections[section].items[row]
    }

    public func itemAt(indexPath indexPath: NSIndexPath) -> S.Item? {
        return itemAt(section: indexPath.section, row: indexPath.row)
    }

    public func headerTitleIn(section section: Int) -> String? {
        return sections[section].headerTitle
    }

    public func footerTitleIn(section section: Int) -> String? {
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

    public func numberOfItemsIn(section section: Int) -> Int {
        return sections?[section].numberOfObjects ?? 0
    }

    public func itemsIn(section section: Int) -> [Item]? {
        return (sections?[section].objects as! [Item])
    }

    public func itemAt(section section: Int, row: Int) -> Item? {
        return itemAt(indexPath: NSIndexPath(forRow: row, inSection: section))
    }

    public func itemAt(indexPath indexPath: NSIndexPath) -> Item? {
        return (objectAtIndexPath(indexPath) as! Item)
    }

    public func headerTitleIn(section section: Int) -> String? {
        return sections?[section].name
    }

    public func footerTitleIn(section section: Int) -> String? {
        return nil
    }
}
