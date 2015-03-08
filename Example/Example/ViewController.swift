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

class ViewController: UITableViewController {

    let stack = CoreDataStack()


    @IBAction func didTapDeleteButton(sender: UIBarButtonItem) {
        println("Deleting all things...")

        if let results = stack.context.executeFetchRequest(Thing.fetchRequest(), error: nil) {
            for thing in results {
                stack.context.deleteObject(thing as! Thing)
            }

            assert(stack.saveAndWait())
        }

        println("Done")
    }


    @IBAction func didTapAddButton(sender: UIBarButtonItem) {
        println("Adding some fake things...")

        for i in 1...5 {
            let t = Thing.newThing(stack.context)
        }

        assert(stack.saveAndWait())

        println("Done")
    }

}
