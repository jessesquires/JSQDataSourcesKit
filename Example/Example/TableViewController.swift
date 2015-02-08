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

import JSQDataSourcesKit


struct ViewModel {
    let title = "My Cell Title"
}


class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var dataSourceProvider: TableViewDataSourceProvider<[[ViewModel]], TableViewCellFactory<TableViewCell, ViewModel>, ViewModel>?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

        let sections = [
            [ ViewModel(), ViewModel(), ViewModel(), ViewModel(), ViewModel(), ViewModel() ],
            [ ViewModel(), ViewModel(), ViewModel(), ViewModel(), ViewModel(), ViewModel() ]
        ]

        let factory = TableViewCellFactory(reuseIdentifier: "cell") { (cell: TableViewCell, model: ViewModel, tableView: UITableView, indexPath: NSIndexPath) -> TableViewCell in
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = "\(indexPath.section), \(indexPath.row)"
            return cell
        }

        self.dataSourceProvider = TableViewDataSourceProvider(sections: sections, cellFactory: factory)

        self.tableView.dataSource = self.dataSourceProvider?.dataSource

    }

}
