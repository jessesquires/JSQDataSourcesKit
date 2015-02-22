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

    var dataSourceProvider: CollectionViewDataSourceProvider<CViewModel, CollectionViewSection<CViewModel>, CollectionViewCellFactory<CollectionViewCell, CViewModel> >?

    // MARK: view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // configure layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        // register cells
        collectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionCellId)

        // create view models
        let section0 = CollectionViewSection(dataItems: [ CViewModel(), CViewModel(), CViewModel(), CViewModel() ])
        let section1 = CollectionViewSection(dataItems: [ CViewModel(), CViewModel(), CViewModel() ])
        let allSections = [section0, section1]

        // create cell factory
        let factory = CollectionViewCellFactory(reuseIdentifier: collectionCellId) { (cell: CollectionViewCell, model: CViewModel, collectionView: UICollectionView, indexPath: NSIndexPath) -> CollectionViewCell in
            cell.label.text = model.text + "\n\(indexPath.section), \(indexPath.item)"
            return cell
        }

        // create data source provider
        // by passing `self.collectionView`, the provider automatically sets `self.collectionView.dataSource = self.dataSourceProvider.dataSource`
        self.dataSourceProvider = CollectionViewDataSourceProvider(sections: allSections, cellFactory: factory, collectionView: self.collectionView)

    }

}
