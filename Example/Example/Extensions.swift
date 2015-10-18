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


import CoreData
import Foundation
import UIKit


extension UIAlertController {

    class func showHelpAlert(presenter: UIViewController) {
        let alert = UIAlertController(title: "Help",
            message: "Tap + to add a new item. The new item will be highlighted (selected) in gray."
                + "\n\nSelect item(s), then tap the trashcan to delete them.",
            preferredStyle: .Alert)

        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))

        presenter.presentViewController(alert, animated: true, completion: nil)
    }
}


extension UITableView {

    func deselectAllRows() {
        if let indexPaths = indexPathsForSelectedRows {
            for i in indexPaths {
                deselectRowAtIndexPath(i, animated: true)
            }
        }
    }
}


extension UICollectionView {

    func deselectAllItems() {
        if let indexPaths = indexPathsForSelectedItems() {
            for i in indexPaths {
                deselectItemAtIndexPath(i, animated: true)
            }
        }
    }
}


extension NSFetchedResultsController {

    func deleteObjectsAtIndexPaths(indexPaths: [NSIndexPath]?) {
        guard let indexPaths = indexPaths else {
            return
        }

        for i in indexPaths {
            let thingToDelete = objectAtIndexPath(i) as! Thing
            managedObjectContext.deleteObject(thingToDelete)
        }
    }
}
