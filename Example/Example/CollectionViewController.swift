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
import JSQDataSourcesKit

class CollectionViewController: UIViewController {

    // MARK: outlets

    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: properties

    typealias CellFactory = CollectionViewCellFactory<CollectionViewCell, CViewModel>
    typealias SupplementaryViewFactory = CollectionSupplementaryViewFactory<TitledCollectionReusableView, CViewModel>
    typealias Section = CollectionViewSection<CViewModel>
    var dataSourceProvider: CollectionViewDataSourceProvider<CViewModel, Section, CellFactory, SupplementaryViewFactory>?

    // MARK: view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // configure layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.headerReferenceSize = CGSizeMake(collectionView.frame.size.width, 50)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        // register cells and supplementary views
        collectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionCellId)
        collectionView.registerNib(TitledCollectionReusableView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: TitledCollectionReusableView.identifier)

        // create view models
        let section0 = CollectionViewSection(dataItems: [ CViewModel(), CViewModel(), CViewModel()])
        let section1 = CollectionViewSection(dataItems: [ CViewModel(), CViewModel(), CViewModel(), CViewModel(), CViewModel(), CViewModel() ])
        let section2 = CollectionViewSection(dataItems: [ CViewModel() ])
        let allSections = [section0, section1, section2]

        // create cell factory
        let cellFactory = CollectionViewCellFactory(reuseIdentifier: collectionCellId) { (cell: CollectionViewCell, model: CViewModel, collectionView: UICollectionView, indexPath: NSIndexPath) -> CollectionViewCell in
            cell.label.text = model.text + "\n\(indexPath.section), \(indexPath.item)"
            return cell
        }

        // create supplementary view factory
        let headerFactory = CollectionSupplementaryViewFactory(reuseIdentifier: TitledCollectionReusableView.identifier) { (view: TitledCollectionReusableView, model: CViewModel, kind, collectionView, indexPath: NSIndexPath) -> TitledCollectionReusableView in
            view.label.text = "Section \(indexPath.section)"
            view.label.textColor = UIColor.whiteColor()
            view.backgroundColor = UIColor.darkGrayColor()
            return view
        }

        // create data source provider
        // by passing `self.collectionView`, the provider automatically sets `self.collectionView.dataSource = self.dataSourceProvider.dataSource`
        self.dataSourceProvider = CollectionViewDataSourceProvider(sections: allSections, cellFactory: cellFactory, supplementaryViewFactory: headerFactory, collectionView: self.collectionView)

    }

}
