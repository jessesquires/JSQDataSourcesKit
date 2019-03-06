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

import JSQDataSourcesKit
import UIKit

/*
 Example of a composed config for collection view cells.
 Used for headers and footers in `MixedCollectionViewController` in the demo
 */
struct ComposedCellViewConfig: ReusableViewConfigProtocol {

    let standardCellConfig: ReusableViewConfig<CellViewModel, CollectionViewCell>

    let fancyCellConfig: ReusableViewConfig<FancyViewModel, FancyCollectionViewCell>

    init(standardCellConfig: ReusableViewConfig<CellViewModel, CollectionViewCell>,
         fancyCellConfig: ReusableViewConfig<FancyViewModel, FancyCollectionViewCell>) {
        self.standardCellConfig = standardCellConfig
        self.fancyCellConfig = fancyCellConfig
    }

    func reuseIdentiferFor(item: MixedItem?, type: ReusableViewType, indexPath: IndexPath) -> String {
        return item!.reuseIdentifier
    }

    func configure(view: UICollectionViewCell, item: MixedItem?, type: ReusableViewType, parentView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        view.accessibilityIdentifier = "\(indexPath.section), \(indexPath.item)"

        guard let model = item else {
            return view
        }

        switch model {
        case let .standard(standardModel):
            let cell = view as! CollectionViewCell
            return standardCellConfig.configure(view: cell, item: standardModel, type: type, parentView: parentView, indexPath: indexPath)

        case let .fancy(fancyModel):
            let cell = view as! FancyCollectionViewCell
            return fancyCellConfig.configure(view: cell, item: fancyModel, type: type, parentView: parentView, indexPath: indexPath)
        }
    }
}
