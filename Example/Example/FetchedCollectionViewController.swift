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
//  Copyright (c) 2015 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import UIKit
import CoreData
import JSQDataSourcesKit

class FetchedCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    // MARK: outlets

    @IBOutlet weak var collectionView: UICollectionView!


    // MARK: properties

    let stack = CoreDataStack()

    typealias ThingCellFactory = CollectionViewCellFactory<CollectionViewCell, Thing>
    typealias ThingHeaderViewFactory = TitledCollectionReusableViewFactory<Thing>
    typealias ThingSupplementaryViewFactory = ComposedCollectionSupplementaryViewFactory<Thing>

    var dataSourceProvider: CollectionViewFetchedResultsDataSourceProvider<Thing, ThingCellFactory, ThingSupplementaryViewFactory>?

    var delegateProvider: CollectionViewFetchedResultsDelegateProvider<Thing>?


    // MARK: view lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Test", style: .Plain, target: self, action: Selector("didTapTest:"))

        // configure layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true

        // register cells and supplementary views
        collectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionCellId)
        collectionView.registerNib(TitledCollectionReusableView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: TitledCollectionReusableView.identifier)
        collectionView.registerNib(TitledCollectionReusableView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: TitledCollectionReusableView.identifier)

        // create cell factory
        let cellFactory = CollectionViewCellFactory(reuseIdentifier: collectionCellId) { (cell: CollectionViewCell, model: Thing, collectionView: UICollectionView, indexPath: NSIndexPath) -> CollectionViewCell in
            cell.label.text = model.displayName
            cell.label.textColor = UIColor.whiteColor()
            cell.backgroundColor = model.displayColor
            return cell
        }

        // create supplementary view factories
        let headerFactory = TitledCollectionReusableViewFactory(
            dataConfigurator: { (header, item: Thing, kind, collectionView, indexPath) -> TitledCollectionReusableView in
                header.label.text = "\(item.category) (header \(indexPath.section))"
                header.label.textColor = item.displayColor
                return header
            },
            styleConfigurator: { (header) -> Void in
                header.backgroundColor = UIColor.darkGrayColor()
        })

        let footerFactory = TitledCollectionReusableViewFactory(
            dataConfigurator: { (footer, item: Thing, kind, collectionView, indexPath) -> TitledCollectionReusableView in
                footer.label.text = "\(item.category) (footer \(indexPath.section))"
                footer.label.textColor = item.displayColor
                return footer
            },
            styleConfigurator: { (footer) -> Void in
                footer.backgroundColor = UIColor.lightGrayColor()
                footer.label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
                footer.label.textAlignment = .Center
        })

        let composedFactory = ComposedCollectionSupplementaryViewFactory(headerViewFactory: headerFactory, footerViewFactory: footerFactory)

        // create fetched results controller
        let frc: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: Thing.fetchRequest(), managedObjectContext: stack.context, sectionNameKeyPath: "category", cacheName: nil)

        // create delegate provider
        // by passing `frc` the provider automatically sets `frc.delegate = self.delegateProvider.delegate`
        delegateProvider = CollectionViewFetchedResultsDelegateProvider(collectionView: collectionView, controller: frc)

        // create data source provider
        // by passing `self.collectionView`, the provider automatically sets `self.collectionView.dataSource = self.dataSourceProvider.dataSource`
        dataSourceProvider = CollectionViewFetchedResultsDataSourceProvider(fetchedResultsController: frc, cellFactory: cellFactory, supplementaryViewFactory: composedFactory, collectionView: collectionView)
    }


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        do {
            try dataSourceProvider?.fetchedResultsController.performFetch()
        } catch {
            print("Fetch error = \(error)")
        }
    }


    // MARK: collection view delegate flow layout

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 25)
    }


    // MARK: actions

    @IBAction func didTapAddButton(sender: UIBarButtonItem) {

        collectionView.deselectAllItems()

        let newThing = Thing.newThing(stack.context)
        stack.saveAndWait()

        fetch()

        if let indexPath = dataSourceProvider?.fetchedResultsController.indexPathForObject(newThing) {
            collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredVertically)
        }

        print("Added new thing: \(newThing)")
    }


    @IBAction func didTapDeleteButton(sender: UIBarButtonItem) {
        if let indexPaths = collectionView.indexPathsForSelectedItems() {

            print("Deleting things at indexPaths: \(indexPaths)")

            for i in indexPaths {
                let thingToDelete = dataSourceProvider?.fetchedResultsController.objectAtIndexPath(i) as! Thing
                stack.context.deleteObject(thingToDelete)
            }

            stack.saveAndWait()

            fetch()
        }
    }


    @IBAction func didTapHelpButton(sender: UIBarButtonItem) {
        UIAlertController.showHelpAlert(self)
    }

    // MARK: Testing
    
    var test = false
    var thing: Thing?

    func didTapTest(sender: UIBarButtonItem) {
        if !test {
            thing = Thing.newThing(stack.context)
            thing?.category = Category.Red.rawValue

            let blue = Thing.newThing(stack.context)
            blue.category = Category.Blue.rawValue

            let green = Thing.newThing(stack.context)
            green.category = Category.Green.rawValue

            stack.saveAndWait()

            test = true
            return
        }

        if let thing = thing {
            thing.category = Category.Blue.rawValue
            stack.saveAndWait()
        }


    }

    // MARK: Private

    private func fetch() {
        do {
            try dataSourceProvider?.fetchedResultsController.performFetch()
        } catch {
            print("Fetch error = \(error)")
        }
    }

}


// MARK: extensions

extension UICollectionView {
    
    func deselectAllItems() {
        if let indexPaths = indexPathsForSelectedItems() {
            for i in indexPaths {
                deselectItemAtIndexPath(i, animated: true)
            }
        }
    }
    
}
