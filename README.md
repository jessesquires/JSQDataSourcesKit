# JSQDataSourcesKit
[![Build Status](https://secure.travis-ci.org/jessesquires/JSQDataSourcesKit.svg)](https://travis-ci.org/jessesquires/JSQDataSourcesKit) [![Version Status](https://img.shields.io/cocoapods/v/JSQDataSourcesKit.svg)][podLink] [![license MIT](https://img.shields.io/cocoapods/l/JSQDataSourcesKit.svg)][mitLink] [![codecov](https://codecov.io/gh/jessesquires/JSQDataSourcesKit/branch/develop/graph/badge.svg)](https://codecov.io/gh/jessesquires/JSQDataSourcesKit) [![Platform](https://img.shields.io/cocoapods/p/JSQDataSourcesKit.svg)][docsLink] [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

*Protocol-oriented, type-safe data source objects that keep your view controllers light*

A Swift library of data source and delegate objects inspired by [Andy Matuschak's](https://github.com/andymatuschak) *type-safe, value-oriented collection view data source [gist](https://gist.github.com/andymatuschak/f1e1691fa1a327468f8e)*.

## About

This library reduces the boilerplate code regarding the `UITableView`, `UICollectionView`, and `NSFetchedResultsController` data source objects, as well as the `NSFetchedResultsControllerDelegate` object. It helps [keep view controllers light](http://www.objc.io/issue-1/), while focusing on type-safety, [SOLID](http://en.wikipedia.org/wiki/SOLID_(object-oriented_design)) design principles, and easy interoperability with Cocoa. Further, it brings a more focused and data-driven perspective to these data sources. If you want to change your view then you change your data and its structure, without needing to update any data source or delegate protocol methods.

## Requirements

* Xcode 10+
* Swift 4.2+
* iOS 11.0+
* tvOS 11.0+
* [SwiftLint](https://github.com/realm/SwiftLint)

## Installation

#### [CocoaPods](https://cocoapods.org) (recommended)

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

#### Generate

````bash
$ ./scripts/build_docs.sh
````

#### Preview

````bash
$ open index.html -a Safari
````

## Contribute

Please follow these [contribution guidelines](https://github.com/jessesquires/HowToContribute).

## Credits

Created and maintained by [**@jesse_squires**](https://twitter.com/jesse_squires)

* Inspired by **[andymatuschak](https://github.com/andymatuschak) /** [gist f1e1691fa1a327468f8e](https://gist.github.com/andymatuschak/f1e1691fa1a327468f8e)
* Inspired by **[ashfurrow](https://github.com/ashfurrow) /** [UICollectionView-NSFetchedResultsController](https://github.com/ashfurrow/UICollectionView-NSFetchedResultsController)

## License

`JSQDataSourcesKit` is released under an [MIT License][mitLink]. See `LICENSE` for details.

>**Copyright &copy; 2015-present Jesse Squires.**

*Please provide attribution, it is greatly appreciated.*

[docsLink]:https://jessesquires.github.io/JSQDataSourcesKit
[podLink]:https://cocoapods.org/pods/JSQDataSourcesKit
[mitLink]:https://opensource.org/licenses/MIT

adsfasdfasdf
