# JSQDataSourcesKit

*Type-safe, value-oriented data source objects that keep your view controllers light*

A Swift framework of data source and delegate objects inspired by [Andy Matuschak's](https://github.com/andymatuschak) *type-safe, value-oriented collection view data source [gist](https://gist.github.com/andymatuschak/f1e1691fa1a327468f8e)*. 

>#### NOTE: work in-progress, but almost done!
>
> See what's left to do [here](https://github.com/jessesquires/JSQDataSourcesKit/milestones/Release%201.0.0)

## About

This framework reduces the boilerplate code regarding the `UITableView`, `UICollectionView`, and `NSFetchedResultsController` data source objects, as well as the `NSFetchedResultsControllerDelegate` object. It helps [keep view controllers light](http://www.objc.io/issue-1/), while focusing on type-safety, [SOLID](http://en.wikipedia.org/wiki/SOLID_(object-oriented_design)) design principles, and easy interoperability with Cocoa. Further, it brings a more focused and data-driven perspective to these data sources. That is, if you want to change your view, you change your data and its structure.

## Installation

> TODO

## Documentation

Read the fucking [docs](http://www.jessesquires.com/JSQDataSourcesKit/). Generated with [jazzy](https://github.com/realm/jazzy). Hosted by [GitHub Pages](https://pages.github.com).

````bash
# re-generate documentation
$ cd /path/to/JSQDataSourcesKit/
$ ./build_docs.sh
$ open _docs/
````

## Getting Started

````swift
import JSQDataSourcesKit
````
> TODO

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



## License

`JSQDataSourcesKit` is released under an [MIT License][mitLink]. See `LICENSE` for details.

>**Copyright &copy; 2015 Jesse Squires.**

*Please provide attribution, it is greatly appreciated.*

[mitLink]:http://opensource.org/licenses/MIT
