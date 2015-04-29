# JSQDataSourcesKit 
[![Version Status](http://img.shields.io/cocoapods/v/JSQDataSourcesKit.png)][docsLink] [![license MIT](http://img.shields.io/badge/license-MIT-orange.png)][mitLink] [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

*Type-safe, value-oriented data source objects that keep your view controllers light*

A Swift framework of data source and delegate objects inspired by [Andy Matuschak's](https://github.com/andymatuschak) *type-safe, value-oriented collection view data source [gist](https://gist.github.com/andymatuschak/f1e1691fa1a327468f8e)*. 

## About

This framework reduces the boilerplate code regarding the `UITableView`, `UICollectionView`, and `NSFetchedResultsController` data source objects, as well as the `NSFetchedResultsControllerDelegate` object. It helps [keep view controllers light](http://www.objc.io/issue-1/), while focusing on type-safety, [SOLID](http://en.wikipedia.org/wiki/SOLID_(object-oriented_design)) design principles, and easy interoperability with Cocoa. Further, it brings a more focused and data-driven perspective to these data sources. If you want to change your view then you change your data and its structure, without needing to update any data source or delegate protocol methods.

## Requirements

* iOS 8
* Swift 1.2

## Installation

#### [CocoaPods](http://cocoapods.org)

````ruby
use_frameworks!

# For latest release in cocoapods
pod 'JSQDataSourcesKit'  

# Feeling adventurous? Get the latest on develop
pod 'JSQDataSourcesKit', :git => 'https://github.com/jessesquires/JSQDataSourcesKit.git', :branch => 'develop'
````

#### [Carthage](https://github.com/Carthage/Carthage)

````bash
github "jessesquires/JSQDataSourcesKit"
````

#### Manually

1. Clone this repo and add the `JSQDataSourcesKit.xcodeproj` to your project
2. Select your project app target "Build Phases" tab
3. Add the `JSQDataSourcesKit.framework` to the "Link Binary With Libraries"  
4. Create a new build phase of type "Copy Files" and set the "Destination" to "Frameworks"
5. Add the `JSQDataSourcesKit.framework` and check "Code Sign On Copy"

For an example, see the demo project included in this repo.

For more information, see the [Framework Programming Guide](https://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/BPFrameworks/Tasks/IncludingFrameworks.html#//apple_ref/doc/uid/20002257-BAJJBBHJ).

## Documentation

Read the fucking [docs][docsLink]. Generated with [jazzy](https://github.com/realm/jazzy). Hosted by [GitHub Pages](https://pages.github.com).

````bash
# regenerate documentation
$ cd /path/to/JSQDataSourcesKit/
$ ./build_docs.sh
$ open _docs/
````

## Getting Started

````swift
import JSQDataSourcesKit
````

##### Design

This framework is composed of different data source and delegate `Provider` classes. Instances of a `Provider` own a collection of model objects and a cell factory, and are responsible for *providing* a data source or delegate.

##### Example

The following illustrates a simple example of how these components interact for a table view. Other scenarios follow similarly, for example, a collection view.

````swift
// Given a view controller with a table view

// register cells
let nib = UINib(nibName: "MyCellNib", bundle: nil)
self.tableView.registerNib(nib, forCellReuseIdentifier: "MyCellIdentifier")

// create sections with your model objects
let section0 = TableViewSection(dataItems: [ /* array of type T */ ])
let section1 = TableViewSection(dataItems: [ /* array of type T */ ])
let allSections = [section0, section1]

// create cell factory, it receives a cell identifier and configuration closure
let factory = TableViewCellFactory(reuseIdentifier: "MyCellIdentifier") 
    { (cell: UITableViewCell, model: T, tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell in
      // configure the cell
      return cell
}

// create data source provider
self.dataSourceProvider = TableViewDataSourceProvider(sections: allSections, cellFactory: factory)

// set the table view's data source
self.tableView.dataSource = self.dataSourceProvider.dataSource

// Clients are responsible for the following:
//
// 1. registering cells with the table view (or collection view)
//
// 2. adding and removing cells as the data source is modified 
//    (i.e. as self.dataSourceProvider.sections changes)
````

##### Demo Project

The example app included exercises *all* functionality in this framework. Open `JSQDataSourcesKit.xcworkspace`, select the `Example` scheme, then build and run. 

## Unit tests

There's a suite of unit tests for the `JSQDataSourcesKit.framework`. To run them, open `JSQDataSourcesKit.xcworkspace`, select the `JSQDataSourcesKit` scheme, then &#x2318;-u.

These tests are well commented and serve as further documentation for how to use this library.

## Contribute

Please follow these sweet [contribution guidelines](https://github.com/jessesquires/HowToContribute).

## Credits

Created and maintained by [**@jesse_squires**](https://twitter.com/jesse_squires)

* Inspired by **[andymatuschak](https://github.com/andymatuschak) /** [gist f1e1691fa1a327468f8e](https://gist.github.com/andymatuschak/f1e1691fa1a327468f8e)
* Inspired by **[ashfurrow](https://github.com/ashfurrow) /** [UICollectionView-NSFetchedResultsController](https://github.com/ashfurrow/UICollectionView-NSFetchedResultsController)
* Derived from my work on [RSTDataSourceKit](https://github.com/rosettastone/RSTDataSourceKit)

## License

`JSQDataSourcesKit` is released under an [MIT License][mitLink]. See `LICENSE` for details.

>**Copyright &copy; 2015 Jesse Squires.**

*Please provide attribution, it is greatly appreciated.*

[mitLink]:http://opensource.org/licenses/MIT
[docsLink]:http://www.jessesquires.com/JSQDataSourcesKit
