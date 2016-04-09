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

import UIKit

/**
 A `TitledCollectionReusableView` is a `UICollectionReusableView` subclass with a single `UILabel`
 intended for use as an analog to a `UITableView` header title (via `tableView(_:titleForHeaderInSection:)`)
 when using a `CollectionViewFetchedResultsDelegateProvider`.

 These views can be created via a `TitledCollectionReusableViewFactory`.
 */
public final class TitledCollectionReusableView: UICollectionReusableView {

    // MARK: Properties

    /// The label of the reusable view.
    @IBOutlet public private(set) weak var label: UILabel!

    /// The leading spacing constraint between the label and its superview.
    @IBOutlet public private(set) weak var leadingSpacing: NSLayoutConstraint!

    /// The top spacing constraint between the label and its superview.
    @IBOutlet public private(set) weak var topSpacing: NSLayoutConstraint!

    /// The trailing constraint between the label and its superview.
    @IBOutlet public private(set) weak var trailingSpacing: NSLayoutConstraint!

    /// The bottom spacing constraint between the label and its superview.
    @IBOutlet public private(set) weak var bottomSpacing: NSLayoutConstraint!

    /// :nodoc:
    public override var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        set {
            super.backgroundColor = newValue
            label?.backgroundColor = newValue
        }
    }


    // MARK: Class properties

    /// The default string used to identify instances of `TitledCollectionReusableView`.
    public class var identifier: String {
        get {
            return String(TitledCollectionReusableView.self)
        }
    }

    /// The `UINib` object initialized for the view.
    public class var nib: UINib {
        get {
            return UINib(
                nibName: "TitledCollectionReusableView",
                bundle: NSBundle(forClass: TitledCollectionReusableView.self))
        }
    }


    // MARK: Methods

    /// :nodoc:
    override public func prepareForReuse() {
        super.prepareForReuse()
        label?.text = nil
        label?.attributedText = nil
    }
}
