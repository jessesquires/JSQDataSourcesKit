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

/// A `DataSourceContainer` is a map of generic data source implementations, keyed by their type.
public struct DataSourceContainer {

    private var map: Dictionary<String, Any> = [:]
    
    /// Add a data source implementation to the container. The data
    /// source can be retrieved using the type of the object. Its easier
    /// to keep track of the type of the data source by explicitly casting
    /// it to the protocol it implements (i.e UITableViewDataSource/UICollectionViewDataSource)
    ///
    /// - Parameter dataSource: the data source implementation to add
    public mutating func add<T>(dataSource: T)
    {
        map[key(for: T.self)] = dataSource
    }
    
    /// Retrieves a previously added data source implementation of the specified
    /// type, or nil if no implementation has been added.
    ///
    /// - Parameter dataSourceType: The type of the data source to retrieve
    public subscript<T> (dataSourceType: T.Type) -> T?
    {
        get {
            guard let value = map[key(for: dataSourceType)] else {
                return nil
            }
            guard let dataSource = value as? T else {
                // This *shouldn't* ever happen
                preconditionFailure("Received unexpected dataSource \(value). Expected object of type \(dataSourceType)")
            }
            return dataSource
        }
    }
    
    private func key<T>(for dataSourceType: T.Type) -> String
    {
        return String(describing: dataSourceType)
    }
}
