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


class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    typealias CollectionCellFactory = CellFactory<CellViewModel, CollectionViewCell>
    typealias HeaderViewFactory = TitledCollectionReusableViewFactory<CellViewModel>

    var dataSourceProvider: CollectionViewDataSourceProvider<Section<CellViewModel>, CollectionCellFactory, HeaderViewFactory>?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView(collectionView!)

        // 1. create view models
        let section0 = Section(items: CellViewModel(), CellViewModel(), CellViewModel())
        let section1 = Section(items: CellViewModel(), CellViewModel(), CellViewModel(), CellViewModel(), CellViewModel(), CellViewModel())
        let section2 = Section(items: CellViewModel())
        let allSections = [section0, section1, section2]

        // 2. create cell factory
        let cellFactory = CellFactory(reuseIdentifier: CellId) { (cell, model: CellViewModel, collectionView, indexPath) -> CollectionViewCell in
            cell.label.text = model.text + "\n\(indexPath.section), \(indexPath.item)"
            return cell
        }

        // 3. create supplementary view factory
        let headerFactory = TitledCollectionReusableViewFactory(
            dataConfigurator: { (header, item: CellViewModel?, kind, collectionView, indexPath) -> TitledCollectionReusableView in
                header.label.text = "Section \(indexPath.section)"
                return header
            },
            styleConfigurator: { (headerView) -> Void in
                headerView.backgroundColor = .darkGrayColor()
                headerView.label.textColor = .whiteColor()
        })

        // 4. create data source provider
        self.dataSourceProvider = CollectionViewDataSourceProvider(sections: allSections,
                                                                   cellFactory: cellFactory,
                                                                   supplementaryViewFactory: headerFactory,
                                                                   collectionView: collectionView)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }

}
