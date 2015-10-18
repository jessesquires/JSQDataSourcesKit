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


/// An instance conforming to `TableViewSectionInfo` represents a section of items in a table view.
public protocol TableViewSectionInfo {

    // MARK: Associated types

    /// The type of elements stored in the section.
    typealias Item

    
    // MARK: Properties

    /// The elements in the table view section.
    var items: [Item] { get set }

    /// Returns the header title for the section.
    var headerTitle: String? { get }

    /// Returns the footer title for the section.
    var footerTitle: String? { get }
}
