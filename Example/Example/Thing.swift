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

import Foundation
import CoreData
import UIKit



public class Thing: NSManagedObject {

    @NSManaged public var category: String
    @NSManaged public var name: String
    @NSManaged public var number: Int32

    public var displayName: String {
        return "Thing(\(name), \(number))"
    }

    public var displayColor: UIColor {
        return Category(rawValue: category)!.color
    }

    public convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entityForName("Thing", inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }

    public class func newThing(context: NSManagedObjectContext) -> Thing {
        let t = Thing(context: context)
        t.category = Category.random.rawValue
        t.name = split(NSProcessInfo.processInfo().globallyUniqueString, { $0 == "-" }).first!
        t.number = Int32(arc4random_uniform(10000))
        return t
    }

    public class func fetchRequest() -> NSFetchRequest {
        let request = NSFetchRequest(entityName: "Thing")
        request.sortDescriptors = [NSSortDescriptor(key: "category", ascending: true), NSSortDescriptor(key: "number", ascending: true)]
        return request
    }

}
