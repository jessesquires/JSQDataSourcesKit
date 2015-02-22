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

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var dataSourceProvider: TableViewDataSourceProvider<TViewModel, TableViewSection<TViewModel>, TableViewCellFactory<TableViewCell, TViewModel> >?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: tableCellId)

        let section0 = TableViewSection(dataItems: [ TViewModel(), TViewModel(), TViewModel() ], headerTitle: "First")
        let section1 = TableViewSection(dataItems: [ TViewModel(), TViewModel(), TViewModel(), TViewModel(), TViewModel(), TViewModel() ], headerTitle: "Second", footerTitle: "Only 2nd has a footer")
        let section2 = TableViewSection(dataItems: [ TViewModel(), TViewModel() ], headerTitle: "Third")

        let allSections = [section0, section1, section2]

        let factory = TableViewCellFactory(reuseIdentifier: tableCellId) { (cell: TableViewCell, model: TViewModel, tableView: UITableView, indexPath: NSIndexPath) -> TableViewCell in
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = "\(indexPath.section), \(indexPath.row)"
            return cell
        }

        self.dataSourceProvider = TableViewDataSourceProvider(sections: allSections, cellFactory: factory, tableView: self.tableView)
        
    }

}
