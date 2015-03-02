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

    // MARK: outlets

    @IBOutlet weak var collectionView: UICollectionView!

    
    // MARK: properties

    let stack = CoreDataStack()

    typealias ThingCellFactory = CollectionViewCellFactory<CollectionViewCell, Thing>
    typealias ThingSupplementaryViewFactory = CollectionViewSupplementaryViewFactory<UICollectionReusableView, Thing>
    var dataSourceProvider: CollectionViewFetchedResultsDataSourceProvider<Thing, ThingCellFactory, ThingSupplementaryViewFactory>?

    var delegateProvider: CollectionViewFetchedResultsDelegateProvider<Thing>?


    // MARK: view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // configure layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.headerReferenceSize = CGSizeMake(collectionView.frame.size.width, 50)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView.allowsMultipleSelection = true

        // register cells and supplementary views
        collectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionCellId)
        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")

        // create cell factory
        let cellFactory = CollectionViewCellFactory(reuseIdentifier: collectionCellId) { (cell: CollectionViewCell, model: Thing, collectionView: UICollectionView, indexPath: NSIndexPath) -> CollectionViewCell in
            cell.label.text = model.displayName
            cell.label.textColor = UIColor.whiteColor()
            cell.backgroundColor = model.displayColor
            return cell
        }

        // create supplementary view factory
        let headerFactory = CollectionViewSupplementaryViewFactory(reuseIdentifier: "header") { (view, model: Thing, kind, collectionView, indexPath: NSIndexPath) -> UICollectionReusableView in
            view.backgroundColor = model.displayColor
            return view
        }

        // create fetched results controller
        let frc: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: Thing.fetchRequest(), managedObjectContext: stack.context, sectionNameKeyPath: "category", cacheName: nil)

        // create delegate provider
        // by passing `frc` the provider automatically sets `frc.delegate = self.delegateProvider.delegate`
        self.delegateProvider = CollectionViewFetchedResultsDelegateProvider(collectionView: collectionView, controller: frc)

        // create data source provider
        // by passing `self.collectionView`, the provider automatically sets `self.collectionView.dataSource = self.dataSourceProvider.dataSource`
        self.dataSourceProvider = CollectionViewFetchedResultsDataSourceProvider(fetchedResultsController: frc, cellFactory: cellFactory, supplementaryViewFactory: headerFactory, collectionView: collectionView)
    }


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.dataSourceProvider?.performFetch()
    }


    // MARK: actions

    @IBAction func didTapAddButton(sender: UIBarButtonItem) {
        collectionView.deselectAllItems()

        let newThing = Thing.newThing(stack.context)
        stack.saveAndWait()
        dataSourceProvider?.performFetch()

        if let indexPath = dataSourceProvider?.fetchedResultsController.indexPathForObject(newThing) {
            collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredVertically)
        }

        println("Added new thing: \(newThing)")
    }


    @IBAction func didTapDeleteButton(sender: UIBarButtonItem) {
        if let indexPaths = collectionView.indexPathsForSelectedItems() as? [NSIndexPath] {

            println("Deleting things at indexPaths: \(indexPaths)")

            for i in indexPaths {
                let thingToDelete = dataSourceProvider?.fetchedResultsController.objectAtIndexPath(i) as! Thing
                stack.context.deleteObject(thingToDelete)
            }

            stack.saveAndWait()
            dataSourceProvider?.performFetch()
        }

    }

}


// MARK: extensions

extension UICollectionView {

    func deselectAllItems() {
        if let indexPaths = indexPathsForSelectedItems() as? [NSIndexPath] {
            for i in indexPaths {
                deselectItemAtIndexPath(i, animated: true)
            }
        }
    }

}
