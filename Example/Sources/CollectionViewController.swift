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

final class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    typealias Source = DataSource<CellViewModel>
    typealias CollectionCellConfig = ReusableViewConfig<CellViewModel, CollectionViewCell>
    typealias HeaderViewConfig = TitledSupplementaryViewConfig<CellViewModel>

    var dataSourceProvider: DataSourceProvider<Source, CollectionCellConfig, HeaderViewConfig>?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView(collectionView!)

        // 1. create view models
        let section0 = Section(items: CellViewModel(), CellViewModel(), CellViewModel())
        let section1 = Section(items: CellViewModel(), CellViewModel(), CellViewModel(), CellViewModel(), CellViewModel(), CellViewModel())
        let section2 = Section(items: CellViewModel())
        let dataSource = DataSource(sections: section0, section1, section2)

        // 2. create cell config
        let cellConfig = ReusableViewConfig(reuseIdentifier: CellId) { (cell, model: CellViewModel?, _, _, indexPath) -> CollectionViewCell in
            cell.label.text = model!.text + "\n\(indexPath.section), \(indexPath.item)"
            cell.accessibilityIdentifier = "\(indexPath.section), \(indexPath.item)"
            return cell
        }

        // 3. create supplementary view config
        let headerConfig = TitledSupplementaryViewConfig { (header, _: CellViewModel?, _, _, indexPath) -> TitledSupplementaryView in
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
