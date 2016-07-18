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
import ExampleModel
import JSQDataSourcesKit


extension UIAlertController {
    class func showActionAlert(_ presenter: UIViewController,
                               addNewAction: () -> Void,
                               deleteAction: () -> Void,
                               changeNameAction: () -> Void,
                               changeColorAction: () -> Void,
                               changeAllAction: () -> Void) {
        let alert = UIAlertController(title: "You must select items first", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Add new", style: .default) { action in
            addNewAction()
            })

        alert.addAction(UIAlertAction(title: "Delete selected", style: .default) { action in
            deleteAction()
            })

        alert.addAction(UIAlertAction(title: "Change name selected", style: .default) { action in
            changeNameAction()
            })

        alert.addAction(UIAlertAction(title: "Change color selected", style: .default) { action in
            changeColorAction()
            })

        alert.addAction(UIAlertAction(title: "Change all selected", style: .default) { action in
            changeAllAction()
            })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        presenter.present(alert, animated: true, completion: nil)
    }
}


extension UITableView {

    func deselectAllRows() {
        if let indexPaths = indexPathsForSelectedRows {
            for i in indexPaths {
                deselectRow(at: i, animated: true)
            }
        }
    }
}


extension UICollectionView {

    func deselectAllItems() {
        if let indexPaths = indexPathsForSelectedItems() {
            for i in indexPaths {
                deselectItem(at: i, animated: true)
            }
        }
    }
}


extension FetchedResultsController {

    func deleteThingsAtIndexPaths(_ indexPaths: [IndexPath]?) {
        guard let indexPaths = indexPaths else {
            return
        }

        managedObjectContext.perform {
            for i in indexPaths {
                let thingToDelete = self.object(at: i) as! Thing
                self.managedObjectContext.delete(thingToDelete)
            }
        }
    }

    func changeThingNamesAtIndexPaths(_ indexPaths: [IndexPath]?) {
        guard let indexPaths = indexPaths else {
            return
        }

        managedObjectContext.perform {
            for i in indexPaths {
                let thingToChange = self.object(at: i) as! Thing
                thingToChange.changeNameRandomly()
            }
        }
    }

    func changeThingColorsAtIndexPaths(_ indexPaths: [IndexPath]?) {
        guard let indexPaths = indexPaths else {
            return
        }

        managedObjectContext.perform {
            for i in indexPaths {
                let thingToChange = self.object(at: i) as! Thing
                thingToChange.changeColorRandomly()
            }
        }
    }

    func changeThingsAtIndexPaths(_ indexPaths: [IndexPath]?) {
        guard let indexPaths = indexPaths else {
            return
        }

        managedObjectContext.perform {
            for i in indexPaths {
                let thingToChange = self.object(at: i) as! Thing
                thingToChange.changeRandomly()
            }
        }
    }
}
