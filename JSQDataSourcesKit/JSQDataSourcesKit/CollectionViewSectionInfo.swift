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


/// An instance conforming to `CollectionViewSectionInfo` represents a section of items in a collection view.
public protocol CollectionViewSectionInfo {

    // MARK: Associated types

    /// The type of elements stored in the section.
    typealias Item


    // MARK: Properties

    /// The elements in the collection view section.
    var items: [Item] { get set }
}
