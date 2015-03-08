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

import UIKit

public class TitledCollectionReusableView: UICollectionReusableView {

    public typealias ConfigurationHandler = (TitledCollectionReusableView) -> Void

    @IBOutlet private weak var _label: UILabel!
    @IBOutlet private weak var _leftSpacing: NSLayoutConstraint!
    @IBOutlet private weak var _topSpacing: NSLayoutConstraint!
    @IBOutlet private weak var _rightSpacing: NSLayoutConstraint!
    @IBOutlet private weak var _bottomSpacing: NSLayoutConstraint!

    public var label: UILabel {
        get {
            return _label
        }
    }

    public var leftSpacing: NSLayoutConstraint {
        get {
            return _leftSpacing
        }
    }

    public var topSpacing: NSLayoutConstraint {
        get {
            return _topSpacing
        }
    }

    public var rightSpacing: NSLayoutConstraint {
        get {
            return _rightSpacing
        }
    }

    public var bottomSpacing: NSLayoutConstraint {
        get {
            return _bottomSpacing
        }
    }

    public override var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        set {
            super.backgroundColor = newValue
            _label?.backgroundColor = newValue
        }
    }

    public class var identifier: String {
        get {
            return toString(TitledCollectionReusableView.self)
        }
    }

    public class var nib: UINib {
        get {
            return UINib(nibName: "TitledCollectionReusableView", bundle: NSBundle(forClass: TitledCollectionReusableView.self))
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        _label?.text = nil
        _label?.attributedText = nil
    }

    public func configureWithHandler(handler: ConfigurationHandler) {
        handler(self)
    }
    
}
