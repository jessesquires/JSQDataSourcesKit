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

import UIKit


public protocol TableViewCellFactoryType {

    typealias DataItem
    typealias Cell: UITableViewCell

    func cellForItem(item: DataItem, inTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> Cell

    func configureCell(cell: Cell, forItem item: DataItem, inTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> Cell

}


public struct TableViewCellFactory<Cell: UITableViewCell, DataItem>: TableViewCellFactoryType {

    typealias CellConfigurationHandler = (Cell, DataItem, UITableView, NSIndexPath) -> Cell

    private let reuseIdentifier: String
    
    private let cellConfigurator: CellConfigurationHandler

    public init(reuseIdentifier: String, cellConfigurator: CellConfigurationHandler) {
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


public class TableViewDataSourceProvider <SectionCollection: CollectionType, CellFactory: TableViewCellFactoryType, DataItem
                                            where
                                            SectionCollection.Index == Int,
                                            SectionCollection.Generator.Element: CollectionType,
                                            SectionCollection.Generator.Element.Generator.Element == DataItem,
                                            SectionCollection.Generator.Element.Index == Int,
                                            CellFactory.DataItem == DataItem> {

    public var sections: SectionCollection

    public let cellFactory: CellFactory

    public var dataSource: UITableViewDataSource { return bridgedDataSource }

    private let bridgedDataSource: BridgedTableViewDataSource!

    public init(sections: SectionCollection, cellFactory: CellFactory, tableView: UITableView? = nil) {
        self.sections = sections
        self.cellFactory = cellFactory

        self.bridgedDataSource = BridgedTableViewDataSource(
            numberOfSections: {
                [unowned self] () -> Int in
                return countElements(self.sections)
            },
            numberOfRowsInSection: {
                [unowned self] (section) -> Int in
                return countElements(self.sections[section])
            },
            cellForRowAtIndexPath: {
                [unowned self] (tableView, indexPath) -> UITableViewCell in
                return self.cellFactory.cellForItem(sections[indexPath.section][indexPath.row], inTableView: tableView, atIndexPath: indexPath)
        })

        tableView?.dataSource = self.dataSource
    }

}


private class BridgedTableViewDataSource: NSObject, UITableViewDataSource {

    typealias NumberOfSectionsHandler = () -> Int
    typealias NumberOfRowsIntSectionHandler = (Int) -> Int
    typealias CellForRowAtIndexPathHandler = (UITableView, NSIndexPath) -> UITableViewCell

    private let numberOfSections: NumberOfSectionsHandler
    private let numberOfRowsInSection: NumberOfRowsIntSectionHandler
    private let cellForRowAtIndexPath: CellForRowAtIndexPathHandler

    init(numberOfSections: NumberOfSectionsHandler, numberOfRowsInSection: NumberOfRowsIntSectionHandler, cellForRowAtIndexPath: CellForRowAtIndexPathHandler) {
        self.numberOfSections = numberOfSections
        self.numberOfRowsInSection = numberOfRowsInSection
        self.cellForRowAtIndexPath = cellForRowAtIndexPath
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection(section)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cellForRowAtIndexPath(tableView, indexPath)
    }

}
