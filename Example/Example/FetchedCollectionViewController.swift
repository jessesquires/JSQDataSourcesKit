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
import CoreData
import JSQDataSourcesKit

class FetchedCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    let stack = CoreDataStack()

    var dataSourceProvider: CollectionViewFetchedResultsDataSourceProvider<Thing, CollectionViewCellFactory<CollectionViewCell, Thing> >?

    var delegateProvider: CollectionViewFetchedResultsDelegateProvider<Thing, CollectionViewCellFactory<CollectionViewCell, Thing> >?

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        collectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionCellId)

        let factory = CollectionViewCellFactory(reuseIdentifier: collectionCellId) { (cell: CollectionViewCell, model: Thing, collectionView: UICollectionView, indexPath: NSIndexPath) -> CollectionViewCell in
            cell.label.text = model.displayName
            cell.label.textColor = UIColor.whiteColor()
            cell.backgroundColor = model.displayColor
            return cell
        }

        let frc: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: Thing.fetchRequest(), managedObjectContext: stack.context, sectionNameKeyPath: "category", cacheName: nil)

        self.delegateProvider = CollectionViewFetchedResultsDelegateProvider(collectionView: collectionView, cellFactory: factory, controller: frc)

        self.dataSourceProvider = CollectionViewFetchedResultsDataSourceProvider(fetchedResultsController: frc, cellFactory: factory, collectionView: collectionView)
    }


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.dataSourceProvider?.performFetch()
    }


    @IBAction func didTapAddButton(sender: UIBarButtonItem) {
        println("add")

        let newThing = Thing.newThing(stack.context)
        stack.saveAndWait()
        dataSourceProvider?.performFetch()
    }


    @IBAction func didTapDeleteButton(sender: UIBarButtonItem) {
        println("delete")
    }

}
