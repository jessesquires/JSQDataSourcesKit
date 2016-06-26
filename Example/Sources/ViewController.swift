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
import ExampleModel


final class ViewController: UITableViewController {

    let stack = CoreDataStack()

    @IBAction func didTapDeleteButton(sender: UIBarButtonItem) {
        removeAllThingsInStack(stack)
    }

    @IBAction func didTapAddButton(sender: UIBarButtonItem) {
        addThingsInStack(stack, count: 5)
    }
}
