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
 Avoid making DelegateProvider inherit from NSObject.
 Keep classes pure Swift.
 Keep responsibilies focused.
 */
@objc internal final class BridgedFetchedResultsDelegate: NSObject, NSFetchedResultsControllerDelegate {

    typealias WillChangeContentHandler = (NSFetchedResultsController) -> Void
    typealias DidChangeSectionHandler = (NSFetchedResultsController, NSFetchedResultsSectionInfo, Int, NSFetchedResultsChangeType) -> Void
    typealias DidChangeObjectHandler = (NSFetchedResultsController, AnyObject, NSIndexPath?, NSFetchedResultsChangeType, NSIndexPath?) -> Void
    typealias DidChangeContentHandler = (NSFetchedResultsController) -> Void

    let willChangeContent: WillChangeContentHandler
    let didChangeSection: DidChangeSectionHandler
    let didChangeObject: DidChangeObjectHandler
    let didChangeContent: DidChangeContentHandler

    init(willChangeContent: WillChangeContentHandler,
         didChangeSection: DidChangeSectionHandler,
         didChangeObject: DidChangeObjectHandler,
         didChangeContent: DidChangeContentHandler) {

        self.willChangeContent = willChangeContent
        self.didChangeSection = didChangeSection
        self.didChangeObject = didChangeObject
        self.didChangeContent = didChangeContent
    }

    @objc func controllerWillChangeContent(controller: NSFetchedResultsController) {
        willChangeContent(controller)
    }

    @objc func controller(controller: NSFetchedResultsController,
                          didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                                           atIndex sectionIndex: Int,
                                                   forChangeType type: NSFetchedResultsChangeType) {
        didChangeSection(controller, sectionInfo, sectionIndex, type)
    }

    @objc func controller(controller: NSFetchedResultsController,
                          didChangeObject anObject: AnyObject,
                                          atIndexPath indexPath: NSIndexPath?,
                                                      forChangeType type: NSFetchedResultsChangeType,
                                                                    newIndexPath: NSIndexPath?) {
        didChangeObject(controller, anObject, indexPath, type, newIndexPath)
    }

    @objc func controllerDidChangeContent(controller: NSFetchedResultsController) {
        didChangeContent(controller)
    }
}
