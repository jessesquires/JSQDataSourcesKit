//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//
//  Documentation
//  https://jessesquires.github.io/JSQDataSourcesKit
//
//
//  GitHub
//  https://github.com/jessesquires/JSQDataSourcesKit
//
//
//  License
//  Copyright © 2015-present Jesse Squires
//  Released under an MIT license: https://opensource.org/licenses/MIT
//

import CoreData
import ExampleModel
import Foundation
import JSQDataSourcesKit
import UIKit

let CellId = "cell"
let FancyCellId = "fancyCell"

struct CellViewModel {
    let text = "My Title"
}

func addThingsInStack(_ stack: CoreDataStack, count: Int) {
    for _ in 0..<count {
        Thing.newThing(stack.context)
    }
    assert(stack.saveAndWait())
}

func removeAllThingsInStack(_ stack: CoreDataStack) {
    do {
        let results = try stack.context.fetch(Thing.newFetchRequest())
        for thing in results {
            stack.context.delete(thing)
        }

        assert(stack.saveAndWait())
    } catch {
        print("Fetch error = \(error)")
    }
}

func fetchedResultsController(inContext context: NSManagedObjectContext) -> FetchedResultsController<Thing> {
    return FetchedResultsController<Thing>(fetchRequest: Thing.newFetchRequest(),
                                           managedObjectContext: context,
                                           sectionNameKeyPath: "colorName",
                                           cacheName: nil)
}

func configureCollectionView(_ collectionView: UICollectionView) {
    let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    layout.headerReferenceSize = CGSize(width: collectionView.frame.size.width, height: 50)

    collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil),
                            forCellWithReuseIdentifier: CellId)

    collectionView.register(TitledSupplementaryView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: TitledSupplementaryView.identifier)

    collectionView.register(TitledSupplementaryView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: TitledSupplementaryView.identifier)
}
