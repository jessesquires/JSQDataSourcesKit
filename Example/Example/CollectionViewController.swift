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


struct CViewModel {
    let text = "Text"
}


let collectionCellId = "cell"


class CollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var dataSourceProvider: CollectionViewDataSourceProvider<CViewModel, CollectionViewSection<CViewModel>, CollectionViewCellFactory<CollectionViewCell, CViewModel> >?

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        collectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionCellId)

        let section0 = CollectionViewSection(dataItems: [ CViewModel(), CViewModel(), CViewModel(), CViewModel() ])
        let section1 = CollectionViewSection(dataItems: [ CViewModel(), CViewModel(), CViewModel() ])

        let allSections = [section0, section1]

        let factory = CollectionViewCellFactory(reuseIdentifier: collectionCellId) { (cell: CollectionViewCell, model: CViewModel, collectionView: UICollectionView, indexPath: NSIndexPath) -> CollectionViewCell in
            cell.label.text = model.text + "\n\(indexPath.section), \(indexPath.item)"
            return cell
        }

        self.dataSourceProvider = CollectionViewDataSourceProvider(sections: allSections, cellFactory: factory, collectionView: self.collectionView)

    }

}
