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

    typealias CellFactory = TableViewCellFactory<UITableViewCell, CellViewModel>
    var dataSourceProvider: TableViewDataSourceProvider<Section<CellViewModel>, CellFactory>?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. create view models
        let section0 = Section(items: CellViewModel(), CellViewModel(), CellViewModel(), headerTitle: "First")
        let section1 = Section(items: CellViewModel(), CellViewModel(), CellViewModel(), CellViewModel(), headerTitle: "Second", footerTitle: "Only 2nd has a footer")
        let section2 = Section(items: CellViewModel(), CellViewModel(), headerTitle: "Third")
        let allSections = [section0, section1, section2]

        // 2. create cell factory
        let factory = TableViewCellFactory(reuseIdentifier: CellId) {
            (cell: UITableViewCell, model: CellViewModel, tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell in
            cell.textLabel?.text = model.text
            cell.detailTextLabel?.text = "\(indexPath.section), \(indexPath.row)"
            return cell
        }

        // 3. create data source provider
        dataSourceProvider = TableViewDataSourceProvider(sections: allSections, cellFactory: factory, tableView: tableView)
    }
    
}
