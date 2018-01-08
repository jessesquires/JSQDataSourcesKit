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

import CoreData
import Foundation

// A quick and dirty core data stack for testing
// DO NOT DO THIS IN REAL LIFE
// In fact, use https://github.com/jessesquires/JSQCoreDataKit

// swiftlint:disable force_try

public class CoreDataStack {

    public let context: NSManagedObjectContext
    public let persistentStoreCoordinator: NSPersistentStoreCoordinator

    public init(inMemory: Bool = false) {
        let modelURL = Bundle(for: CoreDataStack.self).url(forResource: "Model", withExtension: "momd")!

        let model = NSManagedObjectModel(contentsOf: modelURL)!
        let documentsDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let storeURL = documentsDirectoryURL.appendingPathComponent("Model.sqlite")

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

// swiftlint:enable force_try
