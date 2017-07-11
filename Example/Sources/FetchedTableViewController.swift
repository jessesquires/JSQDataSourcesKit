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
import CoreData
import ExampleModel
import JSQDataSourcesKit


class FetchedTableViewController: UITableViewController {

    // MARK: Properties

    let stack = CoreDataStack()

    typealias TableCellFactory = ViewFactory<Thing, UITableViewCell>
    var dataSourceProvider: DataSourceProvider<FetchedResultsController<Thing>, TableCellFactory, TableCellFactory>!

    var delegateProvider: FetchedResultsDelegateProvider<TableCellFactory>!

    var frc: FetchedResultsController<Thing>!


    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. create factory
        let factory = ViewFactory(reuseIdentifier: CellId) { (cell, model: Thing?, type, tableView, indexPath) -> UITableViewCell in
            cell.textLabel?.text = model!.displayName
            cell.textLabel?.textColor = model!.displayColor
            cell.detailTextLabel?.text = "\(indexPath.section), \(indexPath.row)"
            cell.accessibilityIdentifier = "\(String(describing: cell.textLabel?.text!))"
            return cell
        }

        // 2. create fetched results controller
        frc = fetchedResultsController(inContext: stack.context)

        // 3. create delegate provider
        delegateProvider = FetchedResultsDelegateProvider(cellFactory: factory, tableView: tableView)

        // 4. set delegate
        frc.delegate = delegateProvider.tableDelegate

        // 5. create data source provider
        dataSourceProvider = DataSourceProvider(dataSource: frc, cellFactory: factory, supplementaryFactory: factory)

        // 6. set data source
        tableView.dataSource = dataSourceProvider?.tableViewDataSource
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }


    // MARK: Helpers

    func fetchData() {
        do {
            try frc.performFetch()
        } catch {
            print("Fetch error = \(error)")
        }
    }


    // MARK: Actions

    @IBAction func didTapActionButton(_ sender: UIBarButtonItem) {
        UIAlertController.showActionAlert(self, addNewAction: {
            self.addNewThing()
            }, deleteAction: {
                self.deleteSelected()
            }, changeNameAction: {
                self.changeNameSelected()
            }, changeColorAction: {
                self.changeColorSelected()
            }, changeAllAction: {
                self.changeAllSelected()
        })
    }

    func addNewThing() {
        tableView.deselectAllRows()

        var newThing: Thing?
        stack.context.performAndWait {
            newThing = Thing.newThing(self.stack.context)
        }
        stack.saveAndWait()
        fetchData()

        if let indexPath = frc.indexPath(forObject: newThing!) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        }
    }

    func deleteSelected() {
        frc.deleteThingsAtIndexPaths(tableView.indexPathsForSelectedRows)
        stack.saveAndWait()
        fetchData()
    }

    func changeNameSelected() {
        frc.changeThingNamesAtIndexPaths(tableView.indexPathsForSelectedRows)
        stack.saveAndWait()
        fetchData()
    }

    func changeColorSelected() {
        frc.changeThingColorsAtIndexPaths(tableView.indexPathsForSelectedRows)
        stack.saveAndWait()
        fetchData()
    }

    func changeAllSelected() {
        frc.changeThingsAtIndexPaths(tableView.indexPathsForSelectedRows)
        stack.saveAndWait()
        fetchData()
    }
    
}
