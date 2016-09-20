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

import CoreData
import Foundation


/*
 This class is responsible for implementing the `NSFetchedResultsControllerDelegate` protocol.
 It avoids making `FetchedResultsDelegateProvider` inherit from `NSObject`, and keeps classes small and focused.
 */
@objc internal final class BridgedFetchedResultsDelegate: NSObject {

    typealias WillChangeContentHandler = (NSFetchedResultsController<NSFetchRequestResult>) -> Void
    typealias DidChangeSectionHandler = (NSFetchedResultsController<NSFetchRequestResult>, NSFetchedResultsSectionInfo, Int, NSFetchedResultsChangeType) -> Void
    typealias DidChangeObjectHandler = (NSFetchedResultsController<NSFetchRequestResult>, Any, IndexPath?, NSFetchedResultsChangeType, IndexPath?) -> Void
    typealias DidChangeContentHandler = (NSFetchedResultsController<NSFetchRequestResult>) -> Void

    let willChangeContent: WillChangeContentHandler
    let didChangeSection: DidChangeSectionHandler
    let didChangeObject: DidChangeObjectHandler
    let didChangeContent: DidChangeContentHandler

    init(willChangeContent: @escaping WillChangeContentHandler,
         didChangeSection: @escaping DidChangeSectionHandler,
         didChangeObject: @escaping DidChangeObjectHandler,
         didChangeContent: @escaping DidChangeContentHandler) {

        self.willChangeContent = willChangeContent
        self.didChangeSection = didChangeSection
        self.didChangeObject = didChangeObject
        self.didChangeContent = didChangeContent
    }
}


extension BridgedFetchedResultsDelegate: NSFetchedResultsControllerDelegate {

    @objc func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        willChangeContent(controller)
    }

    @objc func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                          didChange sectionInfo: NSFetchedResultsSectionInfo,
                          atSectionIndex sectionIndex: Int,
                          for type: NSFetchedResultsChangeType) {
        didChangeSection(controller, sectionInfo, sectionIndex, type)
    }

    @objc func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                          didChange anObject: Any,
                          at indexPath: IndexPath?,
                          for type: NSFetchedResultsChangeType,
                          newIndexPath: IndexPath?) {
        didChangeObject(controller, anObject, indexPath, type, newIndexPath)
    }

    @objc func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        didChangeContent(controller)
    }
}
