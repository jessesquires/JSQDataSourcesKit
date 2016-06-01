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
    class func showActionAlert(presenter: UIViewController,
                               addNewAction: () -> Void,
                               deleteAction: () -> Void,
                               changeNameAction: () -> Void,
                               changeColorAction: () -> Void,
                               changeAllAction: () -> Void) {
        let alert = UIAlertController(title: "You must select items first", message: nil, preferredStyle: .ActionSheet)

        alert.addAction(UIAlertAction(title: "Add new", style: .Default) { action in
            addNewAction()
            })

        alert.addAction(UIAlertAction(title: "Delete selected", style: .Default) { action in
            deleteAction()
            })

        alert.addAction(UIAlertAction(title: "Change name selected", style: .Default) { action in
            changeNameAction()
            })

        alert.addAction(UIAlertAction(title: "Change color selected", style: .Default) { action in
            changeColorAction()
            })

        alert.addAction(UIAlertAction(title: "Change all selected", style: .Default) { action in
            changeAllAction()
            })

        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))

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

    func deleteThingsAtIndexPaths(indexPaths: [NSIndexPath]?) {
        guard let indexPaths = indexPaths else {
            return
        }

        for i in indexPaths {
            let thingToDelete = objectAtIndexPath(i) as! Thing
            managedObjectContext.deleteObject(thingToDelete)
        }
    }

    func changeThingNamesAtIndexPaths(indexPaths: [NSIndexPath]?) {
        guard let indexPaths = indexPaths else {
            return
        }

        for i in indexPaths {
            let thingToChange = objectAtIndexPath(i) as! Thing
            thingToChange.changeNameRandomly()
        }
    }

    func changeThingColorsAtIndexPaths(indexPaths: [NSIndexPath]?) {
        guard let indexPaths = indexPaths else {
            return
        }

        for i in indexPaths {
            let thingToChange = objectAtIndexPath(i) as! Thing
            thingToChange.changeColorRandomly()
        }
    }

    func changeThingsAtIndexPaths(indexPaths: [NSIndexPath]?) {
        guard let indexPaths = indexPaths else {
            return
        }

        for i in indexPaths {
            let thingToChange = objectAtIndexPath(i) as! Thing
            thingToChange.changeRandomly()
        }
    }
}
