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

import JSQDataSourcesKit
import UIKit

final class TableViewController: UITableViewController {

    typealias TableCellConfig = ReusableViewConfig<CellViewModel, UITableViewCell>
    var dataSourceProvider: DataSourceProvider<DataSource<CellViewModel>, TableCellConfig, TableCellConfig>?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. create view models
        let section0 = Section(items: CellViewModel(), CellViewModel(), CellViewModel(), headerTitle: "First")
        let section1 = Section(items: CellViewModel(), CellViewModel(), CellViewModel(), CellViewModel(), headerTitle: "Second", footerTitle: "Only 2nd has a footer")
        let section2 = Section(items: CellViewModel(), CellViewModel(), headerTitle: "Third")
        let dataSource = DataSource(sections: section0, section1, section2)

        // 2. create cell config
        let config = ReusableViewConfig(reuseIdentifier: CellId) { (cell, model: CellViewModel?, _, _, indexPath) -> UITableViewCell in
            cell.textLabel?.text = model!.text
            cell.detailTextLabel?.text = "\(indexPath.section), \(indexPath.row)"
            cell.accessibilityIdentifier = "\(indexPath.section), \(indexPath.row)"
            return cell
        }

        // ** optional editing **
        // if needed, enable the editing functionality on the tableView
        let editingController: TableEditingController<DataSource<CellViewModel>> = TableEditingController(
            canEditRow: { _, tableView, indexPath -> Bool in
                true
        },
            commitEditing: { (dataSource: inout DataSource, tableView, editingStyle, indexPath) in
                if editingStyle == .delete {
                    if dataSource.remove(at: indexPath) != nil {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
        })

        // 3. create data source provider
        dataSourceProvider = DataSourceProvider(dataSource: dataSource,
                                                cellConfig: config,
                                                supplementaryConfig: config,
                                                tableEditingController: editingController)

        // 4. set data source
        tableView.dataSource = dataSourceProvider?.tableViewDataSource
    }
}
