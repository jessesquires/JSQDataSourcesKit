//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//
//  Documentation
//  https://jessesquires.github.io/JSQDataSourcesKit
//
//
//  GitHub
//  https://github.com/jessesquires/JSQDataSourcesKit
//
//
//  License
//  Copyright © 2015-present Jesse Squires
//  Released under an MIT license: https://opensource.org/licenses/MIT
// 

import Foundation

/// An instance conforming to `DataSourceProtocol` represents a sectioned data source
/// of items to be displayed in either a collection view or table view.
public protocol DataSourceProtocol {

    // MARK: Associated types

    /// The type of items in the data source.
    associatedtype Item

    // MARK: Methods

    /// - Returns: The number of sections.
    func numberOfSections() -> Int

    /// - Parameter section: A section index in the data source.
    /// - Returns: The number of items in the specified section.
    func numberOfItems(inSection section: Int) -> Int

    /// - Parameter section: A section in the data source.
    /// - Returns: The items in the specified section.
    func items(inSection section: Int) -> [Item]?

    /// - Parameters:
    ///   - row: A row in the data source.
    ///   - section: A section in the data source.
    /// - Returns: The item specified by the section and row, or `nil`.
    func item(atRow row: Int, inSection section: Int) -> Item?

    /// - Parameter section: A section in the data source.
    /// - Returns: The header title for the specified section.
    func headerTitle(inSection section: Int) -> String?

    /// - Parameter section: A section in the data source.
    /// - Returns: The footer title for the specified section.
    func footerTitle(inSection section: Int) -> String?
}

extension DataSourceProtocol {

    /// - Parameter indexPath: An index path specifying a row and section in the data source.
    /// - Returns: The item specified by indexPath, or `nil`.
    public func item(atIndexPath indexPath: IndexPath) -> Item? {
        return item(atRow: indexPath.row, inSection: indexPath.section)
    }
}
