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
//  Copyright (c) 2015 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import UIKit
import JSQDataSourcesKit

class TableViewController: UIViewController {

    // MARK: outlets

    @IBOutlet weak var tableView: UITableView!


    // MARK: properties
    
    typealias Section = TableViewSection<TViewModel>
    typealias CellFactory = TableViewCellFactory<TableViewCell, TViewModel>
    var dataSourceProvider: TableViewDataSourceProvider<TViewModel, Section, CellFactory>?


    // MARK: view lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // register cells
        tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: tableCellId)

        // create view models
        let section0 = TableViewSection(items: TViewModel(), TViewModel(), TViewModel(), headerTitle: "First")
        let section1 = TableViewSection(items: TViewModel(), TViewModel(), TViewModel(), TViewModel(), TViewModel(), TViewModel(), headerTitle: "Second", footerTitle: "Only 2nd has a footer")
        let section2 = TableViewSection(items: TViewModel(), TViewModel(), headerTitle: "Third")
        let allSections = [section0, section1, section2]

        // create factory
        let factory = TableViewCellFactory(reuseIdentifier: tableCellId) { (cell: TableViewCell, model: TViewModel, tableView: UITableView, indexPath: NSIndexPath) -> TableViewCell in
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = "\(indexPath.section), \(indexPath.row)"
            return cell
        }

        // create data source provider
        // by passing `self.tableView`, the provider automatically sets `self.tableView.dataSource = self.dataSourceProvider.dataSource`
        self.dataSourceProvider = TableViewDataSourceProvider(sections: allSections, cellFactory: factory, tableView: self.tableView)
        
    }

}
