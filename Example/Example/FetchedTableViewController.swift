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

    @IBOutlet weak var tableView: UITableView!

    let stack = CoreDataStack()

    var dataSourceProvider: TableViewFetchedResultsDataSourceProvider<Thing, TableViewCellFactory<TableViewCell, Thing> >?

    var fetchedResultsDelegate: TableViewFetchedResultsDelegate<Thing, TableViewCellFactory<TableViewCell, Thing> >?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: tableCellId)

        let factory = TableViewCellFactory(reuseIdentifier: tableCellId) { (cell: TableViewCell, model: Thing, tableView: UITableView, indexPath: NSIndexPath) -> TableViewCell in
            cell.textLabel?.text = model.displayName
            cell.textLabel?.textColor = model.displayColor
            cell.detailTextLabel?.text = "\(indexPath.section), \(indexPath.row)"
            return cell
        }

        let frc: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: Thing.fetchRequest(), managedObjectContext: stack.context, sectionNameKeyPath: "category", cacheName: nil)

        self.fetchedResultsDelegate = TableViewFetchedResultsDelegate(tableView: self.tableView, cellFactory: factory)
        frc.delegate = self.fetchedResultsDelegate

        self.dataSourceProvider = TableViewFetchedResultsDataSourceProvider(fetchedResultsController: frc, cellFactory: factory, tableView: tableView)
    }


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.dataSourceProvider?.performFetch()
    }


    @IBAction func didTapAddButton(sender: UIBarButtonItem) {
        let newThing = Thing.newThing(self.stack.context)

        println("Added new thing: \(newThing)")

        self.dataSourceProvider?.performFetch()
        self.tableView.reloadData()
        
        if let indexPath = self.dataSourceProvider?.fetchedResultsController.indexPathForObject(newThing) {
            self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Middle)
        }
    }
    

    @IBAction func didTapDeleteButton(sender: UIBarButtonItem) {
        println("delete")
    }

}
