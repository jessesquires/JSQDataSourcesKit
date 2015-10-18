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

import Foundation
import CoreData


func addThingsInStack(stack: CoreDataStack, count: Int) {
    for _ in 0..<count {
        Thing.newThing(stack.context)
    }
    assert(stack.saveAndWait())
}


func removeAllThingsInStack(stack: CoreDataStack) {
    do {
        let results = try stack.context.executeFetchRequest(Thing.fetchRequest())
        for thing in results {
            stack.context.deleteObject(thing as! Thing)
        }

        assert(stack.saveAndWait())
    } catch {
        print("Fetch error = \(error)")
    }
}


func thingFRCinContext(context: NSManagedObjectContext) -> NSFetchedResultsController {
    return NSFetchedResultsController(
        fetchRequest: Thing.fetchRequest(),
        managedObjectContext: context,
        sectionNameKeyPath: "colorName",
        cacheName: nil)
}
