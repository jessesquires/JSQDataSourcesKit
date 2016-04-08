# CHANGELOG

The changelog for `JSQDataSourcesKit`. Also see the [releases](https://github.com/jessesquires/JSQDataSourcesKit/releases) on GitHub.

--------------------------------------

3.0.1
-----

Bug fixes from the [3.0.1](https://github.com/jessesquires/JSQDataSourcesKit/issues?q=milestone%3A3.0.1) milestone.

3.0.0
-----

This release closes the [3.0.0 milestone](https://github.com/jessesquires/JSQDataSourcesKit/issues?q=milestone%3A3.0.0).

>**NOTE: This is actually a minor update, but there are breaking changes. Thus, the major version bump.**

## Breaking changes

* All `*DataSourceProvider` classes and `*DelegateProvider` classes no longer have an `Item` generic type parameter. As pointed out by @MrAlek in #25, this was actually superfluous. Example:

````swift
// Old
CollectionViewDataSourceProvider<Item, SectionInfo, CellFactory, SupplementaryViewFactory>
TableViewDataSourceProvider<Item, SectionInfo, CellFactory>

// New
CollectionViewDataSourceProvider<SectionInfo, CellFactory, SupplementaryViewFactory>
TableViewDataSourceProvider<SectionInfo, CellFactory>
````

All we need to ensure is that `SectionInfo.Item == CellFactory.Item` for type-safey across these components, thus the top-level `Item` simply isn't needed. The behavior of these classes remains unchanged, and initialization is now less verbose.

* :warning: The `*FetchedResultsDelegateProvider` and `*FetchedResultsDataSourceProvider` will now `assert` in `init` that the types of items that are fetched by the `NSFetchedResultsController` match the types of items that the `CellFactory`s configure. :warning: 

* Initializers for `*FetchedResultsDelegateProvider` class have changed to the following. Namely, the `controller:` parameter has been renamed to `fetchedResultsController:` and is no longer optional.

````swift
init(collectionView: cellFactory: fetchedResultsController:)
init(tableView: cellFactory: fetchedResultsController:)
````

## Documentation

All [documentation](http://www.jessesquires.com/JSQDataSourcesKit/index.html) has been updated. :scroll: 

2.0.0
-----

# :tada: `JSQDataSourcesKit` 2.0 is here! :tada: 

In short, this release contains tons of refinements and fixes. The codebase is substantially cleaner, and more user-friendly.

## Breaking changes

- Swift 2.0

- `CollectionViewFetchedResultsDelegateProvider` must now be initialized with a cell factory. This is similar to how `TableViewFetchedResultsDelegateProvider` has always worked.

- The `*DataSourceProvider` classes now provide an `NSIndexPath` subscripting interface.

- Initializers for `CollectionViewSection` and `TableViewSection` have changed to the following. In particular, the variadic `init` is much more natural.

    - `public init(items: Item...)`
    - `public init(_ items: [Item])`

- Previous instances of `DataItem` type parameters have been changed to `Item`.

## Issues closed

Find the complete list of closed issues [here](https://github.com/jessesquires/JSQDataSourcesKit/issues?q=milestone%3A2.0.0+is%3Aclosed) for the 2.0.0 milestone.

## Documentation

All [documentation](http://www.jessesquires.com/JSQDataSourcesKit/index.html) has been updated. :scroll: 

## Example app

The [example app](https://github.com/jessesquires/JSQDataSourcesKit/tree/develop/Example) is now much cleaner, and much more awesome. :sunglasses: 

1.0.0
-----

It's here! :tada:

Checkout the `README` and documentation.
