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

import UIKit

import JSQDataSourcesKit


class TableViewController: UITableViewController {

    typealias Section = TableViewSection<TViewModel>
    typealias CellFactory = TableViewCellFactory<UITableViewCell, TViewModel>
    var dataSourceProvider: TableViewDataSourceProvider<TViewModel, Section, CellFactory>?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. create view models
        let section0 = TableViewSection(items: TViewModel(), TViewModel(), TViewModel(), headerTitle: "First")
        let section1 = TableViewSection(items: TViewModel(), TViewModel(), TViewModel(), TViewModel(), headerTitle: "Second", footerTitle: "Only 2nd has a footer")
        let section2 = TableViewSection(items: TViewModel(), TViewModel(), headerTitle: "Third")
        let allSections = [section0, section1, section2]

        // 2. create cell factory
        let factory = TableViewCellFactory(reuseIdentifier: tableCellId) { (cell: UITableViewCell, model: TViewModel, tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell in
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = "\(indexPath.section), \(indexPath.row)"
            return cell
        }

        // 3. create data source provider
        dataSourceProvider = TableViewDataSourceProvider(sections: allSections, cellFactory: factory, tableView: tableView)
    }

}
