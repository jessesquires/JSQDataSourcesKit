//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://jessesquires.github.io/JSQDataSourcesKit
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
import JSQDataSourcesKit


struct FancyViewModel {
    let text: String = "Fancy Text"
    let cornerRadius: CGFloat = 8
}

enum MixedItem {
    case standard(CellViewModel)
    case fancy(FancyViewModel)

    var reuseIdentifier: String {
        switch self {
        case .standard(_):
            return CellId
        case .fancy(_):
            return FancyCellId
        }
    }
}

final class MixedCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    typealias Source = DataSource< Section<MixedItem> >
    typealias CollectionCellFactory = ComposedCellViewFactory
    typealias HeaderViewFactory = TitledSupplementaryViewFactory<MixedItem>

    var dataSourceProvider: DataSourceProvider<Source, CollectionCellFactory, HeaderViewFactory>?

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

        // 2. create cell factories
        let standardCellFactory = ViewFactory(reuseIdentifier: CellId) { (cell, model: CellViewModel?, type, collectionView, indexPath) -> CollectionViewCell in
            if let model = model {
                cell.label.text = model.text + "\n\(indexPath.section), \(indexPath.item)"
            }
            return cell
        }
        let fancyCellFactory = ViewFactory(reuseIdentifier: CellId) { (cell, model: FancyViewModel?, type, collectionView, indexPath) -> FancyCollectionViewCell in
            if let model = model {
                cell.label.text = model.text + "\n\(indexPath.section), \(indexPath.item)"
                cell.layer.cornerRadius = model.cornerRadius
            }
            return cell
        }
        let cellFactory = ComposedCellViewFactory(standardCellFactory: standardCellFactory, fancyCellFactory: fancyCellFactory)

        // 3. create supplementary view factory
        let headerFactory = TitledSupplementaryViewFactory { (header, item: MixedItem?, kind, collectionView, indexPath) -> TitledSupplementaryView in
            header.label.text = "Section \(indexPath.section)"
            header.backgroundColor = .darkGray
            header.label.textColor = .white
            return header
        }

        // 4. create data source provider
        self.dataSourceProvider = DataSourceProvider(dataSource: dataSource,
                                                     cellFactory: cellFactory,
                                                     supplementaryFactory: headerFactory)

        // 5. set data source
        collectionView?.dataSource = self.dataSourceProvider?.collectionViewDataSource
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
}
