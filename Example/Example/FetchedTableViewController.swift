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
import CoreData
import JSQDataSourcesKit

class FetchedTableViewController: UIViewController {

    // MARK: outlets

    @IBOutlet weak var tableView: UITableView!


    // MARK: properties

    let stack = CoreDataStack()

    typealias CellFactory = TableViewCellFactory<TableViewCell, Thing>
    
    var dataSourceProvider: TableViewFetchedResultsDataSourceProvider<Thing, CellFactory>?

    var delegateProvider: TableViewFetchedResultsDelegateProvider<Thing, CellFactory>?


    // MARK: view lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // register cells
        tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: tableCellId)

        // create factory
        let factory = TableViewCellFactory(reuseIdentifier: tableCellId) { (cell: TableViewCell, model: Thing, tableView: UITableView, indexPath: NSIndexPath) -> TableViewCell in
            cell.textLabel?.text = model.displayName
            cell.textLabel?.textColor = model.displayColor
            cell.detailTextLabel?.text = "\(indexPath.section), \(indexPath.row)"
            return cell
        }

        // create fetched results controller
        let frc: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: Thing.fetchRequest(), managedObjectContext: stack.context, sectionNameKeyPath: "category", cacheName: nil)

        // create delegate provider
        // by passing `frc` the provider automatically sets `frc.delegate = self.delegateProvider.delegate`
        self.delegateProvider = TableViewFetchedResultsDelegateProvider(tableView: tableView, cellFactory: factory, controller: frc)

        // create data source provider
        // by passing `self.tableView`, the provider automatically sets `self.tableView.dataSource = self.dataSourceProvider.dataSource`
        self.dataSourceProvider = TableViewFetchedResultsDataSourceProvider(fetchedResultsController: frc, cellFactory: factory, tableView: tableView)
    }


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.dataSourceProvider?.performFetch()
    }


    // MARK: actions

    @IBAction func didTapAddButton(sender: UIBarButtonItem) {
        tableView.deselectAllRows()

        let newThing = Thing.newThing(stack.context)
        stack.saveAndWait()
        dataSourceProvider?.performFetch()

        if let indexPath = dataSourceProvider?.fetchedResultsController.indexPathForObject(newThing) {
            tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Middle)
        }

        println("Added new thing: \(newThing)")
    }


    @IBAction func didTapDeleteButton(sender: UIBarButtonItem) {
        if let indexPaths = tableView.indexPathsForSelectedRows() as? [NSIndexPath] {

            println("Deleting things at indexPaths: \(indexPaths)")

            for i in indexPaths {
                let thingToDelete = dataSourceProvider?.fetchedResultsController.objectAtIndexPath(i) as! Thing
                stack.context.deleteObject(thingToDelete)
            }
            
            stack.saveAndWait()
            dataSourceProvider?.performFetch()
        }

    }
    
}


// MARK: extensions

extension UITableView {

    func deselectAllRows() {
        if let indexPaths = indexPathsForSelectedRows() as? [NSIndexPath] {
            for i in indexPaths {
                deselectRowAtIndexPath(i, animated: true)
            }
        }
    }

}
