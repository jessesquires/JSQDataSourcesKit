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

    typealias CellFactory = TableViewCellFactory<UITableViewCell, Thing>
    var dataSourceProvider: TableViewFetchedResultsDataSourceProvider<CellFactory>?
    var delegateProvider: TableViewFetchedResultsDelegateProvider<CellFactory>?


    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. create factory
        let factory = TableViewCellFactory(reuseIdentifier: CellId) { (cell: UITableViewCell, model: Thing, tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell in
            cell.textLabel?.text = model.displayName
            cell.textLabel?.textColor = model.displayColor
            cell.detailTextLabel?.text = "\(indexPath.section), \(indexPath.row)"
            return cell
        }

        // 2. create fetched results controller
        let frc = thingFRCinContext(stack.context)

        // 3. create delegate provider
        delegateProvider = TableViewFetchedResultsDelegateProvider(
            tableView: tableView,
            cellFactory: factory,
            fetchedResultsController: frc)

        // 4. create data source provider
        dataSourceProvider = TableViewFetchedResultsDataSourceProvider(
            fetchedResultsController: frc,
            cellFactory: factory,
            tableView: tableView)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }


    // MARK: Helpers

    func fetchData() {
        do {
            try dataSourceProvider?.fetchedResultsController.performFetch()
        } catch {
            print("Fetch error = \(error)")
        }
    }


    // MARK: Actions

    @IBAction func didTapActionButton(sender: UIBarButtonItem) {
        UIAlertController.showActionAlert(self,
            addNewAction: {
                self.addNewThing()
            },
            deleteAction: {
                self.deleteSelected()
            },
            changeNameAction: {
                self.changeNameSelected()
            },
            changeColorAction: {
                self.changeColorSelected()
            },
            changeAllAction: {
                self.changeAllSelected()
        })
    }

    func addNewThing() {
        tableView.deselectAllRows()

        let newThing = Thing.newThing(stack.context)
        stack.saveAndWait()

        fetchData()

        if let indexPath = dataSourceProvider?.fetchedResultsController.indexPathForObject(newThing) {
            tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Middle)
        }
    }

    func deleteSelected() {
        dataSourceProvider?.fetchedResultsController.deleteThingsAtIndexPaths(tableView.indexPathsForSelectedRows)
        stack.saveAndWait()
        fetchData()
    }

    func changeNameSelected() {
        dataSourceProvider?.fetchedResultsController.changeThingNamesAtIndexPaths(tableView.indexPathsForSelectedRows)
        stack.saveAndWait()
        fetchData()
    }

    func changeColorSelected() {
        dataSourceProvider?.fetchedResultsController.changeThingColorsAtIndexPaths(tableView.indexPathsForSelectedRows)
        stack.saveAndWait()
        fetchData()
    }

    func changeAllSelected() {
        dataSourceProvider?.fetchedResultsController.changeThingsAtIndexPaths(tableView.indexPathsForSelectedRows)
        stack.saveAndWait()
        fetchData()
    }
    
}
