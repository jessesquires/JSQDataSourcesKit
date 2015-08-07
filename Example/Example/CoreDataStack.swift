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
//  Copyright (c) 2015 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation
import CoreData

//  A quick and dirty core data stack, don't do this

public class CoreDataStack {
    
    public let context: NSManagedObjectContext
    public let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    public init(inMemory: Bool = false) {
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        
        let model = NSManagedObjectModel(contentsOfURL: modelURL)!

        do {
            let documentsDirectoryURL = try NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
            let storeURL = documentsDirectoryURL.URLByAppendingPathComponent("Model.sqlite")

            persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
            try persistentStoreCoordinator.addPersistentStoreWithType(inMemory ? NSInMemoryStoreType : NSSQLiteStoreType, configuration: nil, URL: inMemory ? nil : storeURL, options: nil)

            context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            context.persistentStoreCoordinator = persistentStoreCoordinator

        } catch {
            fatalError("*** Error adding persistent store: \(error)")
        }


    }

    public func saveAndWait() throws {
        if !self.context.hasChanges {
            return
        }

        self.context.performBlockAndWait { () -> Void in
            do {
                try self.context.save()
            } catch {
                print("*** Error saving managed object context: \(error)")
            }
        }
    }

}
