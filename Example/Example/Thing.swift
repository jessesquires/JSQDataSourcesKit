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
import UIKit


public enum Color: String {
    case Red
    case Blue
    case Green

    var displayColor: UIColor {
        switch(self) {
        case .Red: return .redColor()
        case .Blue: return .blueColor()
        case .Green: return .greenColor()
        }
    }
}


public class Thing: NSManagedObject {

    @NSManaged public var name: String

    @NSManaged public var colorName: String

    public var color: Color {
        get {
            return Color(rawValue: colorName)!
        }
        set {
            colorName = newValue.rawValue
        }
    }

    public var displayName: String {
        return "Thing\n\(name)"
    }

    public var displayColor: UIColor {
        return color.displayColor
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
        let allColors = [Color.Red, Color.Blue, Color.Green]
        t.color = allColors[Int(arc4random_uniform(UInt32(allColors.count)))]
        t.name = NSUUID().UUIDString.componentsSeparatedByString("-").first!
        return t
    }

    public class func fetchRequest() -> NSFetchRequest {
        let request = NSFetchRequest(entityName: "Thing")
        request.sortDescriptors = [NSSortDescriptor(key: "colorName", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
        return request
    }

    public override var description: String {
        get {
            return "<Thing: \(name), \(color)>"
        }
    }

}
