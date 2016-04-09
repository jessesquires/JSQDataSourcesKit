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

let DefaultTimeout = NSTimeInterval(5)

struct FakeViewModel: Equatable, CustomStringConvertible {
    let name = NSUUID().UUIDString

    var description: String {
        get {
            return "<\(FakeViewModel.self): \(name)>"
        }
    }
}

func ==(lhs: FakeViewModel, rhs: FakeViewModel) -> Bool {
    return lhs.name == rhs.name
}
