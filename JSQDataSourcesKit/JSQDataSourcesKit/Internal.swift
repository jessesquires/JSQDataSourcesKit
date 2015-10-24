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

internal func assert(
    fetchedResultsController controller: NSFetchedResultsController,
    fetchesObjectsOfClassName className: String,
    function: StaticString = __FUNCTION__,
    file: StaticString = __FILE__,
    line: UInt = __LINE__) {

        let fetchedClass: AnyClass = NSClassFromString(controller.fetchRequest.entity!.managedObjectClassName)!
        let expectedClass: AnyClass = NSClassFromString(className)!
        assert(
            fetchedClass == expectedClass,
            "FetchedResultsController should fetch the same type of objects as CellFactory. "
                + "Expected objects of type <\(expectedClass)>, but found <\(fetchedClass)> instead. ",
            file: file,
            line: line)
}
