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
//  Copyright (c) 2015 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import UIKit

///  A `TitledCollectionReusableView` is a `UICollectionReusableView` subclass with a single `UILabel` intended for use as an
///  analog to a `UITableView` header title (via `tableView(_:titleForHeaderInSection:)`)
///  when using a `CollectionViewFetchedResultsDelegateProvider`.
///  These views can be created via a `TitledCollectionReusableViewFactory`. 
public class TitledCollectionReusableView: UICollectionReusableView {

    // MARK: Outlets

    @IBOutlet private weak var _label: UILabel!
    @IBOutlet private weak var _leadingSpacing: NSLayoutConstraint!
    @IBOutlet private weak var _topSpacing: NSLayoutConstraint!
    @IBOutlet private weak var _trailingSpacing: NSLayoutConstraint!
    @IBOutlet private weak var _bottomSpacing: NSLayoutConstraint!

    // MARK: Properties

    /// Returns the label of the reusable view.
    public var label: UILabel {
        get {
            return _label
        }
    }

    /// Returns the leading spacing constraint between the label and its superview.
    public var leadingSpacing: NSLayoutConstraint {
        get {
            return _leadingSpacing
        }
    }

    /// Returns the top spacing constraint between the label and its superview.
    public var topSpacing: NSLayoutConstraint {
        get {
            return _topSpacing
        }
    }

    /// Returns the trailing constraint between the label and its superview.
    public var trailingSpacing: NSLayoutConstraint {
        get {
            return _trailingSpacing
        }
    }

    /// Returns the bottom spacing constraint between the label and its superview.
    public var bottomSpacing: NSLayoutConstraint {
        get {
            return _bottomSpacing
        }
    }

    /// The view’s background color. Note: setting this property also sets the background color for `label`.
    public override var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        set {
            super.backgroundColor = newValue
            _label?.backgroundColor = newValue
        }
    }

    // MARK: Class properties

    /// Returns the default string used to identify instances of `TitledCollectionReusableView`.
    public class var identifier: String {
        get {
            return toString(TitledCollectionReusableView.self)
        }
    }

    /// Returns the `UINib` object initialized for the view.
    public class var nib: UINib {
        get {
            return UINib(nibName: "TitledCollectionReusableView", bundle: NSBundle(forClass: TitledCollectionReusableView.self))
        }
    }

    // MARK: Methods

    ///  Performs any clean up necessary to prepare the view for use again.
    override public func prepareForReuse() {
        super.prepareForReuse()
        _label?.text = nil
        _label?.attributedText = nil
    }
}
