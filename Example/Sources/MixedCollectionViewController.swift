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

struct FancyViewModel {
    let text: String = "Fancy Text"
    let cornerRadius: CGFloat = 8
}

enum MixedItem {
    case standard(CellViewModel)
    case fancy(FancyViewModel)

    var reuseIdentifier: String {
        switch self {
        case .standard:
            return CellId

        case .fancy:
            return FancyCellId
        }
    }
}

final class MixedCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    typealias Source = DataSource<MixedItem>
    typealias CollectionCellConfig = ComposedCellViewConfig
    typealias HeaderViewConfig = TitledSupplementaryViewConfig<MixedItem>

    var dataSourceProvider: DataSourceProvider<Source, CollectionCellConfig, HeaderViewConfig>?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView(collectionView!)
        collectionView!.register(UINib(nibName: "FancyCollectionViewCell", bundle: nil),
                                 forCellWithReuseIdentifier: FancyCellId)

        let standardItem = MixedItem.standard(CellViewModel())
        let fancyItem = MixedItem.fancy(FancyViewModel())

        // 1. create view models
        let section0 = Section(items: standardItem, fancyItem, fancyItem)
        let section1 = Section(items: fancyItem, standardItem, standardItem, standardItem, fancyItem, standardItem)
        let section2 = Section(items: fancyItem)
        let dataSource = DataSource(sections: section0, section1, section2)

        // 2. create cell configs
        let standardCellConfig = ReusableViewConfig(reuseIdentifier: CellId) { (cell, model: CellViewModel?, _, _, indexPath) -> CollectionViewCell in
            if let model = model {
                cell.label.text = model.text + "\n\(indexPath.section), \(indexPath.item)"
            }
            return cell
        }

        let fancyCellConfig = ReusableViewConfig(reuseIdentifier: CellId) { (cell, model: FancyViewModel?, _, _, indexPath) -> FancyCollectionViewCell in
            if let model = model {
                cell.label.text = model.text + "\n\(indexPath.section), \(indexPath.item)"
                cell.layer.cornerRadius = model.cornerRadius
            }
            return cell
        }
        let cellConfig = ComposedCellViewConfig(standardCellConfig: standardCellConfig, fancyCellConfig: fancyCellConfig)

        // 3. create supplementary view config
        let headerConfig = TitledSupplementaryViewConfig { (header, _: MixedItem?, _, _, indexPath) -> TitledSupplementaryView in
            header.label.text = "Section \(indexPath.section)"
            header.backgroundColor = .darkGray
            header.label.textColor = .white
            return header
        }

        // 4. create data source provider
        self.dataSourceProvider = DataSourceProvider(dataSource: dataSource,
                                                     cellConfig: cellConfig,
                                                     supplementaryConfig: headerConfig)

        // 5. set data source
        collectionView?.dataSource = self.dataSourceProvider?.collectionViewDataSource
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
}
