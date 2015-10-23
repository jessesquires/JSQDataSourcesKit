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
import UIKit
import XCTest

import JSQDataSourcesKit


// Fakes for testing

class FakeTableCell: UITableViewCell {

}


class FakeTableView: UITableView {

    var dequeueCellExpectation: XCTestExpectation?

    override func dequeueReusableCellWithIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        dequeueCellExpectation?.fulfill()
        return super.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
    }
}
