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
        case .Red: return .red()
        case .Blue: return .blue()
        case .Green: return .green()
        }
    }
}


public class Thing: NSManagedObject {

    // MARK: Properties

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
        return "Thing \(name)"
    }

    public var displayColor: UIColor {
        return color.displayColor
    }

    public override var description: String {
        get {
            return "<Thing: \(name), \(color)>"
        }
    }

    // MARK: Init

    public init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Thing", in: context)!
        super.init(entity: entityDescription, insertInto: context)
    }

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }


    // MARK: Methods

    public func changeColorRandomly() {
        color = randomColor(withoutColor: color)
    }

    public func changeNameRandomly() {
        name = randomName()
    }

    public func changeRandomly() {
        changeColorRandomly()
        changeNameRandomly()
    }


    // MARK: Class

    @discardableResult
    public class func newThing(_ context: NSManagedObjectContext) -> Thing {
        let t = Thing(context: context)
        t.color = randomColor(withoutColor: nil)
        t.name = randomName()
        return t
    }

    public class func newFetchRequest() -> NSFetchRequest<Thing> {
        let request = NSFetchRequest<Thing>(entityName: "Thing")
        request.sortDescriptors = [
            SortDescriptor(key: "colorName", ascending: true),
            SortDescriptor(key: "name", ascending: true)
        ]
        return request
    }
}


private func randomColor(withoutColor color: Color?) -> Color {
    var colorSet = Set(arrayLiteral: Color.Red, Color.Blue, Color.Green)
    if let color = color {
        colorSet.remove(color)
    }
    let colors = Array(colorSet)
    return colors[Int(arc4random_uniform(UInt32(colors.count)))]
}


private func randomName() -> String {
    return UUID().uuidString.components(separatedBy: "-").first!
}
