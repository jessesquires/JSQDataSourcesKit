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


// A quick and dirty core data stack for testing
// DO NOT DO THIS IN REAL LIFE
// In fact, use https://github.com/jessesquires/JSQCoreDataKit


public class CoreDataStack {

    public let context: NSManagedObjectContext
    public let persistentStoreCoordinator: NSPersistentStoreCoordinator

    public init(inMemory: Bool = false) {
        let modelURL = NSBundle(forClass: CoreDataStack.self).URLForResource("Model", withExtension: "momd")!

        let model = NSManagedObjectModel(contentsOfURL: modelURL)!
        let documentsDirectoryURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        let storeURL = documentsDirectoryURL.URLByAppendingPathComponent("Model.sqlite")

        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! persistentStoreCoordinator.addPersistentStoreWithType(inMemory ? NSInMemoryStoreType : NSSQLiteStoreType, configuration: nil, URL: inMemory ? nil : storeURL, options: nil)

        context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
    }

    public func saveAndWait() -> Bool {
        var success = true

        context.performBlockAndWait {
            if !self.context.hasChanges {
                success = true
            }
            do {
                try self.context.save()
            } catch {
                print("*** Error saving managed object context: \(error)")
                success = false
            }
        }
        return success
    }
    
}
