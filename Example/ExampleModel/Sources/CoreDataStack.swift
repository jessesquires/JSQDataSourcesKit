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
        let modelURL = Bundle(for: CoreDataStack.self).urlForResource("Model", withExtension: "momd")!

        let model = NSManagedObjectModel(contentsOf: modelURL)!
        let documentsDirectoryURL = try! FileManager.default().urlForDirectory(.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let storeURL = try! documentsDirectoryURL.appendingPathComponent("Model.sqlite")

        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! persistentStoreCoordinator.addPersistentStore(ofType: inMemory ? NSInMemoryStoreType : NSSQLiteStoreType, configurationName: nil, at: inMemory ? nil : storeURL, options: nil)

        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
    }

    @discardableResult
    public func saveAndWait() -> Bool {
        var success = true

        context.performAndWait {
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
