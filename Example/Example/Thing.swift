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

    public init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entityForName("Thing", inManagedObjectContext: context)!
        super.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public class func newThing(context: NSManagedObjectContext) -> Thing {
        let t = Thing(context: context)
        t.category = Category.random.rawValue
        t.name = NSProcessInfo.processInfo().globallyUniqueString.componentsSeparatedByString("-").first!
        t.number = Int32(arc4random_uniform(10000))
        return t
    }

    public class func fetchRequest() -> NSFetchRequest {
        let request = NSFetchRequest(entityName: "Thing")
        request.sortDescriptors = [NSSortDescriptor(key: "category", ascending: true), NSSortDescriptor(key: "number", ascending: true)]
        return request
    }

}


public enum Category: String {
    case Red = "Red"
    case Blue = "Blue"
    case Green = "Green"

    var color: UIColor {
        switch(self) {
        case .Red: return .redColor()
        case .Blue: return .blueColor()
        case .Green: return .greenColor()
        }
    }

    static var random: Category {
        let i = Int(arc4random_uniform(UInt32(allCases.count))) % allCases.count
        return allCases[i]
    }

    static let allCases: [Category] = [.Red, .Blue, .Green]
}
