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

class ViewController: UITableViewController {

    let stack = CoreDataStack()


    @IBAction func didTapDeleteButton(sender: UIBarButtonItem) {
        print("Deleting all things...")

        do {
            let results = try stack.context.executeFetchRequest(Thing.fetchRequest())
            for thing in results {
                stack.context.deleteObject(thing as! Thing)
            }

            assert(stack.saveAndWait())
        } catch {
            print("Fetch error = \(error)")
        }

        print("Done")
    }


    @IBAction func didTapAddButton(sender: UIBarButtonItem) {
        print("Adding some fake things...")

        for _ in 1...5 {
            Thing.newThing(stack.context)
        }

        assert(stack.saveAndWait())

        print("Done")
    }
}


// MARK: extensions

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
