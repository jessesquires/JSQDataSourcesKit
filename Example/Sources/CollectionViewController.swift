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

import JSQDataSourcesKit


final class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    typealias Source = DataSource< Section<CellViewModel> >
    typealias CollectionCellFactory = ViewFactory<CellViewModel, CollectionViewCell>
    typealias HeaderViewFactory = TitledSupplementaryViewFactory<CellViewModel>

    var dataSourceProvider: DataSourceProvider<Source, CollectionCellFactory, HeaderViewFactory>?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView(collectionView!)

        // 1. create view models
        let section0 = Section(items: CellViewModel(), CellViewModel(), CellViewModel())
        let section1 = Section(items: CellViewModel(), CellViewModel(), CellViewModel(), CellViewModel(), CellViewModel(), CellViewModel())
        let section2 = Section(items: CellViewModel())
        let dataSource = DataSource(sections: section0, section1, section2)

        // 2. create cell factory
        let cellFactory = ViewFactory(reuseIdentifier: CellId) { (cell, model: CellViewModel?, type, collectionView, indexPath) -> CollectionViewCell in
            cell.label.text = model!.text + "\n\(indexPath.section), \(indexPath.item)"
            cell.accessibilityIdentifier = "\(indexPath.section), \(indexPath.item)"
            return cell
        }

        // 3. create supplementary view factory
        let headerFactory = TitledSupplementaryViewFactory { (header, item: CellViewModel?, kind, collectionView, indexPath) -> TitledSupplementaryView in
            header.label.text = "Section \(indexPath.section)"
            header.backgroundColor = .darkGrayColor()
            header.label.textColor = .whiteColor()
            return header
        }

        // 4. create data source provider
        self.dataSourceProvider = DataSourceProvider(dataSource: dataSource,
                                                     cellFactory: cellFactory,
                                                     supplementaryFactory: headerFactory)

        // 5. set data source
        collectionView?.dataSource = self.dataSourceProvider?.collectionViewDataSource
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
}
