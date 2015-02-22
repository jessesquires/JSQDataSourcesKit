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
import UIKit


let tableCellId = "cell"

let collectionCellId = "cell"

struct TViewModel {
    let title = "My Cell Title"
}

struct CViewModel {
    let text = "Text"
}

public enum Category: String {
    case Red = "Red"
    case Blue = "Blue"
    case Green = "Green"

    var color: UIColor {
        switch(self) {
        case .Red: return UIColor.redColor()
        case .Blue: return UIColor.blueColor()
        case .Green: return UIColor.greenColor()
        }
    }

    static var random: Category {
        let i = Int(arc4random_uniform(UInt32(allCases.count))) % allCases.count
        return allCases[i]
    }

    static let allCases: [Category] = [.Red, .Blue, .Green]
}
