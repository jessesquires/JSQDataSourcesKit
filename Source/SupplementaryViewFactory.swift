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


public protocol SupplementaryViewFactoryProtocol {

    /// The type of elements backing the collection view.
    associatedtype Item

    /// The type of supplementary views that the factory produces.
    associatedtype View: ReusableViewProtocol

    /**
     Provides a view reuse identifer for the given item and indexPath.

     - parameter item:      The item at `indexPath`.
     - parameter kind:      An identifier that describes the type of the supplementary view.
     - parameter indexPath: The index path that specifies the location of the view.

     - returns: An identifier for a reusable supplementary view.
     */
    func reuseIdentiferFor(item item: Item?, kind: String, indexPath: NSIndexPath) -> String

    /**
     Configures and returns the specified supplementary view.

     - parameter view:       The view to configure.
     - parameter item:       The item at `indexPath`.
     - parameter kind:       An identifier that describes the type of the supplementary view.
     - parameter parentView: The collection view requesting this information.
     - parameter indexPath:  The index path that specifies the location of `view` and `item`.

     - returns: A configured supplementary view of type `View`.
     */
    func configure(view view: View, item: Item?, kind: String, parentView: View.ParentView, indexPath: NSIndexPath) -> View
}

public extension SupplementaryViewFactoryProtocol where View: UICollectionReusableView {

    /**
     Creates a new `View` instance, or dequeues an existing supplementary view for reuse, then configures and returns it.

     - parameter item:       The item at `indexPath`.
     - parameter kind:       An identifier that describes the type of the supplementary view.
     - parameter parentView: The collection view requesting this information.
     - parameter indexPath:  The index path that specifies the location of `view` and `item`.

     - returns: An initialized or dequeued, and fully configured view of type `View`.
     */
    public func supplementaryViewFor(item item: Item?, kind: String, parentView: View.ParentView, indexPath: NSIndexPath) -> View {
        let reuseIdentifier = reuseIdentiferFor(item: item, kind: kind, indexPath: indexPath)
        let view = parentView.dequeueReusableSupplementaryViewFor(kind: kind, identifier: reuseIdentifier, indexPath: indexPath) as! View
        return configure(view: view, item: item, kind: kind, parentView: parentView, indexPath: indexPath)
    }
}


/**
 A `SupplementaryViewFactory` is a concrete `SupplementaryViewFactoryProtocol` type.
 This factory is responsible for producing and configuring supplementary views for a specific item.
 */
public struct SupplementaryViewFactory<Item, View: ReusableViewProtocol>: SupplementaryViewFactoryProtocol  {

    /**
     Configures the view for the specified item, kind, parent view, and index path.

     - parameter cell:       The cell to be configured at the index path.
     - parameter item:       The item at `indexPath`.
     - parameter kind:       An identifier that describes the type of the supplementary view.
     - parameter parentView: The collection view requesting this information.
     - parameter indexPath:  The index path at which the view will be displayed.

     - returns: The configured view.
     */
    public typealias ViewConfigurator = (view: View, item: Item?, kind: String, parentView: View.ParentView, indexPath: NSIndexPath) -> View

    /**
     A unique identifier that describes the purpose of the views that the factory produces.
     The factory dequeues views from the collection view with this reuse identifier.

     - note: Clients are responsible for registering a view for this identifier with the collection view.
     */
    public let reuseIdentifier: String

    /// An identifier that describes the type of the supplementary view.
    public let kind: String

    /// A closure used to configure the view.
    public let viewConfigurator: ViewConfigurator

    /**
     Constructs a new supplementary view factory.

     - parameter reuseIdentifier:  The reuse identifier with which the factory will dequeue views.
     - parameter kind:             An identifier that describes the type of the supplementary view.
     - parameter viewConfigurator: The closure with which the factory will configure views.

     - returns: A new `SupplementaryViewFactory` instance.
     */
    public init(reuseIdentifier: String, kind: String, viewConfigurator: ViewConfigurator) {
        self.reuseIdentifier = reuseIdentifier
        self.kind = kind
        self.viewConfigurator = viewConfigurator
    }

    /// :nodoc:
    public func reuseIdentiferFor(item item: Item?, kind: String, indexPath: NSIndexPath) -> String {
        return reuseIdentifier
    }

    /// :nodoc:
    public func configure(view view: View, item: Item?, kind: String, parentView: View.ParentView, indexPath: NSIndexPath) -> View {
        return viewConfigurator(view: view, item: item, kind: kind, parentView: parentView, indexPath: indexPath)
    }
}

extension SupplementaryViewFactory: CustomStringConvertible {

    /// :nodoc:
    public var description: String {
        get {
            return "<\(SupplementaryViewFactory.self): \(reuseIdentifier), \(kind)>"
        }
    }
}
