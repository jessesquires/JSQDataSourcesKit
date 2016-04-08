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

internal func assert(fetchedResultsController controller: NSFetchedResultsController,
                                              fetchesObjectsOfClass objectClass: AnyClass,
                                                                    function: StaticString = #function,
                                                                    file: StaticString = #file,
                                                                    line: UInt = #line) {
    let fetchedClass: AnyClass = NSClassFromString(controller.fetchRequest.entity!.managedObjectClassName)!
    let fullyQualifiedClass: AnyClass? = NSClassFromString(String(reflecting: objectClass))

    // check for fully-qualified class name (ModuleName.ClassName), otherwise fallback to only class name
    let expectedClass: AnyClass = fullyQualifiedClass ?? NSClassFromString(String(objectClass))!
    assert(fetchedClass == expectedClass,
           "FetchedResultsController should fetch the same type of objects as CellFactory. "
            + "Expected objects of type <\(expectedClass)>, but found <\(fetchedClass)> instead. ",
           file: file,
           line: line)
}
