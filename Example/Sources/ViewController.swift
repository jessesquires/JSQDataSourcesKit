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

import ExampleModel
import UIKit

final class ViewController: UITableViewController {

    let stack = CoreDataStack()

    @IBAction func didTapDeleteButton(_ sender: UIBarButtonItem) {
        removeAllThingsInStack(stack)
    }

    @IBAction func didTapAddButton(_ sender: UIBarButtonItem) {
        addThingsInStack(stack, count: 5)
    }
}
