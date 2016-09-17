# JSQDataSourcesKit
[![Build Status](https://secure.travis-ci.org/jessesquires/JSQDataSourcesKit.svg)](http://travis-ci.org/jessesquires/JSQDataSourcesKit) [![Version Status](https://img.shields.io/cocoapods/v/JSQDataSourcesKit.svg)][podLink] [![license MIT](https://img.shields.io/cocoapods/l/JSQDataSourcesKit.svg)][mitLink] [![codecov](https://codecov.io/gh/jessesquires/JSQDataSourcesKit/branch/develop/graph/badge.svg)](https://codecov.io/gh/jessesquires/JSQDataSourcesKit) [![Platform](https://img.shields.io/cocoapods/p/JSQDataSourcesKit.svg)][docsLink] [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

*Protocol-oriented, type-safe data source objects that keep your view controllers light*

A Swift library of data source and delegate objects inspired by [Andy Matuschak's](https://github.com/andymatuschak) *type-safe, value-oriented collection view data source [gist](https://gist.github.com/andymatuschak/f1e1691fa1a327468f8e)*.

## About

This library reduces the boilerplate code regarding the `UITableView`, `UICollectionView`, and `NSFetchedResultsController` data source objects, as well as the `NSFetchedResultsControllerDelegate` object. It helps [keep view controllers light](http://www.objc.io/issue-1/), while focusing on type-safety, [SOLID](http://en.wikipedia.org/wiki/SOLID_(object-oriented_design)) design principles, and easy interoperability with Cocoa. Further, it brings a more focused and data-driven perspective to these data sources. If you want to change your view then you change your data and its structure, without needing to update any data source or delegate protocol methods.

## Requirements

* iOS 8+
* Swift 3.0
* Xcode 8

## Installation

#### [CocoaPods](http://cocoapods.org) (recommended)

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

## Documentation

Read the [docs][docsLink]. Generated with [jazzy](https://github.com/realm/jazzy). Hosted by [GitHub Pages](https://pages.github.com).

More information on the [`gh-pages`](https://github.com/jessesquires/JSQDataSourcesKit/tree/gh-pages) branch.

## Getting Started

````swift
import JSQDataSourcesKit
````

#### Design

This library has four primary components:

1. `Section` — represents a section of data
2. `DataSource` — represents a collection of `Section` types
3. `ReusableViewFactory` — responsible for dequeuing and configuring cells (for `UITableView` or `UICollectionView`)
4. `DataSourceProvider` — owns a data source and cell factory, and provides a `UICollectionViewDataSource` or `UITableViewDataSource` object.

#### Example

The following illustrates a simple example of how these components interact for a collection view.

````swift
// Given a view controller with a collection view
                                 
// 1. create Sections and a DataSource with your model objects
let section0 = Section(items: ...)
let section1 = Section(items: ...)
let section2 = Section(items: ...)
let dataSource = DataSource(sections: section0, section1, section2)

// 2. create cell factory
let cellFactory = ViewFactory(reuseIdentifier: "CellId") { (cell, model?, type, collectionView, indexPath) -> MyCellClass in
    // configure the cell with the model
    return cell
}

// 3. create supplementary view factory
let type = ReusableViewType.supplementaryView(kind: UICollectionElementKindSectionHeader)
let headerFactory = ViewFactory(reuseIdentifier: "HeaderId", type: type) { (view, model?, type, collectionView, indexPath) -> MyHeaderView in
    // configure header view
    return view
}

// 4. create data source provider
let dataSourceProvider =  DataSourceProvider(dataSource: dataSource,
                                             cellFactory: cellFactory,
                                             supplementaryFactory: headerFactory)

// 5. set the collection view's data source
collectionView.dataSource = dataSourceProvider.collectionViewDataSource
````

#### Demo Project

The [example project](https://github.com/jessesquires/JSQDataSourcesKit/tree/develop/Example) included exercises *all* functionality in this library.

## Unit tests

There's a suite of unit tests for `JSQDataSourcesKit`. Run them in the usual way from Xcode. These tests are well commented and serve as further documentation for how to use this library.

## Contribute

Please follow these sweet [contribution guidelines](https://github.com/jessesquires/HowToContribute).

## Credits

Created and maintained by [**@jesse_squires**](https://twitter.com/jesse_squires).

* Inspired by **[andymatuschak](https://github.com/andymatuschak) /** [gist f1e1691fa1a327468f8e](https://gist.github.com/andymatuschak/f1e1691fa1a327468f8e)
* Inspired by **[ashfurrow](https://github.com/ashfurrow) /** [UICollectionView-NSFetchedResultsController](https://github.com/ashfurrow/UICollectionView-NSFetchedResultsController)

## License

`JSQDataSourcesKit` is released under an [MIT License][mitLink]. See `LICENSE` for details.

>**Copyright &copy; 2015-present Jesse Squires.**

*Please provide attribution, it is greatly appreciated.*

[docsLink]:http://www.jessesquires.com/JSQDataSourcesKit
[podLink]:https://cocoapods.org/pods/JSQDataSourcesKit
[mitLink]:http://opensource.org/licenses/MIT
