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
import CoreData
import ExampleModel
import JSQDataSourcesKit


class FetchedCollectionViewController: UICollectionViewController {

    // MARK: properties

    let stack = CoreDataStack()

    typealias ThingCellFactory = ViewFactory<Thing, CollectionViewCell>
    typealias ThingSupplementaryViewFactory = ComposedCollectionSupplementaryViewFactory<Thing>
    var dataSourceProvider: DataSourceProvider<FetchedResultsController<Thing>, ThingCellFactory, ThingSupplementaryViewFactory>!

    var delegateProvider: FetchedResultsDelegateProvider<ThingCellFactory>!

    var frc: FetchedResultsController<Thing>!


    // MARK: view lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView(collectionView!)
        collectionView!.allowsMultipleSelection = true
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.footerReferenceSize = CGSize(width: collectionView!.frame.size.width, height: 25)

        // 1. create cell factory
        let cellFactory = ViewFactory(reuseIdentifier: CellId) { (cell, model: Thing?, type, collectionView, indexPath) -> CollectionViewCell in
            cell.label.text = model!.displayName
            cell.label.textColor = UIColor.white
            cell.backgroundColor = model!.displayColor
            cell.accessibilityIdentifier = "\(String(describing: cell.label.text))"
            return cell
        }

        // 2. create supplementary view factory
        let headerFactory = TitledSupplementaryViewFactory { (header, item: Thing?, kind, collectionView, indexPath) -> TitledSupplementaryView in
            header.label.text = "\(item!.colorName) header (\(indexPath.section))"
            header.label.textColor = item?.displayColor
            header.backgroundColor = .darkGray
            return header
        }

        let footerFactory = TitledSupplementaryViewFactory { (footer, item: Thing?, kind, collectionView, indexPath) -> TitledSupplementaryView in
            footer.label.text = "\(item!.colorName) footer (\(indexPath.section))"
            footer.label.textColor = item?.displayColor
            footer.backgroundColor = .lightGray
            footer.label.font = .preferredFont(forTextStyle: .footnote)
            footer.label.textAlignment = .center
            return footer
        }

        let composedFactory = ComposedCollectionSupplementaryViewFactory(headerViewFactory: headerFactory, footerViewFactory: footerFactory)

        // 3. create fetched results controller
        frc = fetchedResultsController(inContext: stack.context)

        // 4. create delegate provider
        delegateProvider = FetchedResultsDelegateProvider(cellFactory: cellFactory, collectionView: collectionView!)

        // 5. set delegate
        frc.delegate = delegateProvider.collectionDelegate

        // 6. create data source provider
        dataSourceProvider = DataSourceProvider(dataSource: frc, cellFactory: cellFactory, supplementaryFactory: composedFactory)

        // 7. set data source
        collectionView?.dataSource = dataSourceProvider?.collectionViewDataSource
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }


    // MARK: Helpers

    private func fetchData() {
        do {
            try frc.performFetch()
        } catch {
            print("Fetch error = \(error)")
        }
    }


    // MARK: Actions

    @IBAction func didTapActionButton(_ sender: UIBarButtonItem) {
        UIAlertController.showActionAlert(self, addNewAction: {
            self.addNewThing()
            }, deleteAction: {
                self.deleteSelected()
            }, changeNameAction: {
                self.changeNameSelected()
            }, changeColorAction: {
                self.changeColorSelected()
            }, changeAllAction: {
                self.changeAllSelected()
        })
    }

    func addNewThing() {
        collectionView!.deselectAllItems()

        var newThing: Thing?
        stack.context.performAndWait {
            newThing = Thing.newThing(self.stack.context)
        }
        stack.saveAndWait()
        fetchData()

        if let indexPath = frc.indexPath(forObject: newThing!) {
            collectionView!.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        }
    }

    func deleteSelected() {
        let indexPaths = collectionView!.indexPathsForSelectedItems
        frc.deleteThingsAtIndexPaths(indexPaths)
        stack.saveAndWait()
        fetchData()
        collectionView!.reloadData()
    }

    func changeNameSelected() {
        let indexPaths = collectionView!.indexPathsForSelectedItems
        frc.changeThingNamesAtIndexPaths(indexPaths)
        stack.saveAndWait()
        fetchData()
    }

    func changeColorSelected() {
        let indexPaths = collectionView!.indexPathsForSelectedItems
        frc.changeThingColorsAtIndexPaths(indexPaths)
        stack.saveAndWait()
        fetchData()
    }

    func changeAllSelected() {
        let indexPaths = collectionView!.indexPathsForSelectedItems
        frc.changeThingsAtIndexPaths(indexPaths)
        stack.saveAndWait()
        fetchData()
    }
}
