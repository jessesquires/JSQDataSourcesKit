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

import Foundation
import CoreData
import UIKit
import ExampleModel
import JSQDataSourcesKit


let CellId = "cell"
let FancyCellId = "fancyCell"

struct CellViewModel {
    let text = "My Title"
}


func addThingsInStack(stack: CoreDataStack, count: Int) {
    for _ in 0..<count {
        Thing.newThing(stack.context)
    }
    assert(stack.saveAndWait())
}


func removeAllThingsInStack(stack: CoreDataStack) {
    do {
        let results = try stack.context.executeFetchRequest(Thing.fetchRequest())
        for thing in results {
            stack.context.deleteObject(thing as! Thing)
        }

        assert(stack.saveAndWait())
    } catch {
        print("Fetch error = \(error)")
    }
}


func fetchedResultsController(inContext context: NSManagedObjectContext) -> FetchedResultsController<Thing> {
    return FetchedResultsController<Thing>(fetchRequest: Thing.fetchRequest(),
                                           managedObjectContext: context,
                                           sectionNameKeyPath: "colorName",
                                           cacheName: nil)
}


func configureCollectionView(collectionView: UICollectionView) {
    let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    layout.headerReferenceSize = CGSize(width: collectionView.frame.size.width, height: 50)

    collectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil),
                               forCellWithReuseIdentifier: CellId)

    collectionView.registerClass(TitledSupplementaryView.self,
                                 forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                 withReuseIdentifier: TitledSupplementaryView.identifier)

    collectionView.registerClass(TitledSupplementaryView.self,
                                 forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                                 withReuseIdentifier: TitledSupplementaryView.identifier)
}
