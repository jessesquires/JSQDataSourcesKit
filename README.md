# JSQDataSourcesKit

*Type-safe, value-oriented data source objects that keep your view controllers light*

A Swift rewrite of [RSTDataSourceKit](https://github.com/rosettastone/RSTDataSourceKit) inspired by [Andy Matuschak's](https://github.com/andymatuschak) *type-safe, value-oriented collection view data source [gist](https://gist.github.com/andymatuschak/f1e1691fa1a327468f8e)*. 

>#### NOTE: work in-progress, but almost done!
>**TODO:**
>
> 0. support collection view supplementary views (headers & footers)
>
> 1. unit tests
>
> 2. docs
>
> 3. more info in README

## About

This framework aims to the reduce boilerplate code regarding the `UITableView`, `UICollectionView`, and `NSFetchedResultsController` data source objects, as well as the `NSFetchedResultsControllerDelegate` object. It helps [keep view controllers light](http://www.objc.io/issue-1/), while focusing on type-safety, [SOLID](http://en.wikipedia.org/wiki/SOLID_(object-oriented_design)) design principles, and easy interoperability with Cocoa.

##### Data Sources

`CollectionViewDataSourceProvider`

`TableViewDataSourceProvider`

##### Data Sources for `NSFetchedResultsController`

`CollectionViewFetchedResultsDataSourceProvider`

`TableViewFetchedResultsDataSourceProvider`

##### Delegates for `NSFetchedResultsControllerDelegate`

`CollectionViewFetchedResultsDelegateProvider`

`TableViewFetchedResultsDelegateProvider`

## Getting Started

> TODO

##### Demo Project

> TODO

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
