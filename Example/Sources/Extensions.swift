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

import CoreData
import ExampleModel
import Foundation
import JSQDataSourcesKit
import UIKit

extension UIAlertController {
    // swiftlint:disable:next function_parameter_count
    class func showActionAlert(_ presenter: UIViewController,
                               addNewAction: @escaping () -> Void,
                               deleteAction: @escaping () -> Void,
                               changeNameAction: @escaping () -> Void,
                               changeColorAction: @escaping () -> Void,
                               changeAllAction: @escaping () -> Void) {
        let alert = UIAlertController(title: "You must select items first", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Add new", style: .default) { _ in
            addNewAction()
            })

        alert.addAction(UIAlertAction(title: "Delete selected", style: .default) { _ in
            deleteAction()
            })

        alert.addAction(UIAlertAction(title: "Change name selected", style: .default) { _ in
            changeNameAction()
            })

        alert.addAction(UIAlertAction(title: "Change color selected", style: .default) { _ in
            changeColorAction()
            })

        alert.addAction(UIAlertAction(title: "Change all selected", style: .default) { _ in
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
        if let indexPaths = indexPathsForSelectedItems {
            for i in indexPaths {
                deselectItem(at: i, animated: true)
            }
        }
    }
}

extension FetchedResultsController {

    func deleteThingsAtIndexPaths(_ indexPaths: [IndexPath]) {
        guard !indexPaths.isEmpty else {
            return
        }

        managedObjectContext.perform {
            for i in indexPaths {
                let thingToDelete = self.object(at: i) as! Thing
                self.managedObjectContext.delete(thingToDelete)
            }
        }
    }

    func changeThingNamesAtIndexPaths(_ indexPaths: [IndexPath]) {
        guard !indexPaths.isEmpty else {
            return
        }

        managedObjectContext.perform {
            for i in indexPaths {
                let thingToChange = self.object(at: i) as! Thing
                thingToChange.changeNameRandomly()
            }
        }
    }

    func changeThingColorsAtIndexPaths(_ indexPaths: [IndexPath]) {
        guard !indexPaths.isEmpty else {
            return
        }

        managedObjectContext.perform {
            for i in indexPaths {
                let thingToChange = self.object(at: i) as! Thing
                thingToChange.changeColorRandomly()
            }
        }
    }

    func changeThingsAtIndexPaths(_ indexPaths: [IndexPath]) {
        guard !indexPaths.isEmpty else {
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
