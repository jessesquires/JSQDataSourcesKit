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
            cell.accessibilityIdentifier = "\(cell.textLabel?.text!)"
            return cell
        }

        // 2. create fetched results controller
        frc = fetchedResultsController(inContext: stack.context)

        // 3. create delegate provider
        delegateProvider = FetchedResultsDelegateProvider(cellFactory: factory, tableView: tableView)
        frc.delegate = delegateProvider.tableFetchedDelegate

        // 4. create data source provider
        dataSourceProvider = DataSourceProvider(dataSource: frc, cellFactory: factory, supplementaryFactory: factory)

        tableView.dataSource = dataSourceProvider?.tableViewDataSource
    }

    override func viewWillAppear(animated: Bool) {
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

    @IBAction func didTapActionButton(sender: UIBarButtonItem) {
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

        let newThing = Thing.newThing(stack.context)
        stack.saveAndWait()

        fetchData()

        if let indexPath = frc.indexPathForObject(newThing) {
            tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Middle)
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
