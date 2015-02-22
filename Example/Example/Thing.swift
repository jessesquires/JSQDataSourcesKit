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

public class Thing: NSManagedObject {

    @NSManaged public var name: String
    @NSManaged public var number: Int

    public convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entityForName("Thing", inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }

    public class func newThing(context: NSManagedObjectContext) -> Thing {
        let t = Thing(context: context)
        t.name = NSProcessInfo.processInfo().globallyUniqueString
        t.number = Int(arc4random_uniform(10000))
        return t
    }

}
