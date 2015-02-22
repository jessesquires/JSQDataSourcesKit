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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let stack = CoreDataStack()
        let fetchRequest = Thing.fetchRequest()
        let results = stack.context.executeFetchRequest(fetchRequest, error: nil)

        if results?.count == 0 {
            
            for i in 1...20 {
                let t = Thing.newThing(stack.context)
                println("Add new thing = \(t)")
            }
            
            assert(stack.saveAndWait())
        }

    }

}
