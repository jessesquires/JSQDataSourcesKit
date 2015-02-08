//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQDataSourcesKit
//
//
//  GitHub
//  https://github.com/jessesquires/JSQDataSourcesKit
//
//
//  License
//  Copyright (c) 2015 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation
import UIKit


extension UITableView {

    public func registerNibs(nibs: [UINib], forReuseIdentifiers identifiers: [String]) {
        assert(nibs.count == identifiers.count, "Arrays of nibs and identifiers must have equal counts")

        for index in 0..<nibs.count {
            registerNib(nibs[index], forCellReuseIdentifier: identifiers[index])
        }
    }

    public func registerClasses(classes: [AnyClass], forReuseIdentifiers identifiers: [String]) {
        assert(classes.count == identifiers.count, "Arrays of classes and identifiers must have equal counts")

        for index in 0..<classes.count {
            registerClass(classes[index], forCellReuseIdentifier: identifiers[index])
        }
    }

}


public protocol TableViewCellFactoryType {

    typealias DataItem
    typealias Cell: UITableViewCell

    func cellForItem(item: DataItem, inTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> Cell

    func configureCell(cell: Cell, forItem item: DataItem, inTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> Cell

}


public struct TableViewCellFactory<Cell: UITableViewCell, DataItem>: TableViewCellFactoryType {

    typealias CellConfigurationClosure = (Cell, DataItem, UITableView, NSIndexPath) -> Cell

    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurationClosure

    public init(reuseIdentifier: String, cellConfigurator: CellConfigurationClosure) {
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }

    public func cellForItem(item: DataItem, inTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> Cell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as Cell
        return configureCell(cell, forItem: item, inTableView: tableView, atIndexPath: indexPath)
    }

    public func configureCell(cell: Cell, forItem item: DataItem, inTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> Cell {
        return self.cellConfigurator(cell, item, tableView, indexPath)
    }

}


public class TableViewDataSource <SectionCollection: CollectionType, CellFactory: TableViewCellFactoryType, DataItem
                                    where
                                    SectionCollection.Index == Int,
                                    SectionCollection.Generator.Element: CollectionType,
                                    SectionCollection.Generator.Element.Generator.Element == DataItem,
                                    SectionCollection.Generator.Element.Index == Int,
                                    CellFactory.DataItem == DataItem>: NSObject, UITableViewDataSource {

    public var sections: SectionCollection

    public let cellFactory: CellFactory

    public init(sections: SectionCollection, cellFactory: CellFactory) {
        self.sections = sections
        self.cellFactory = cellFactory
    }

    // MARK: table view data source

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return countElements(sections)
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countElements(sections[section])
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cellFactory.cellForItem(sections[indexPath.section][indexPath.row], inTableView: tableView, atIndexPath: indexPath)
    }

}
