# CHANGELOG

The changelog for `JSQDataSourcesKit`. Also see the [releases](https://github.com/jessesquires/JSQDataSourcesKit/releases) on GitHub.

--------------------------------------

8.0.0
-----

This release closes the [8.0.0 milestone](https://github.com/jessesquires/JSQDataSourcesKit/milestone/13?closed=1).

## Breaking

- iOS 11.0 minimum now required
- tvOS 11.0 minimum now required

## New

- Upgraded to Swift 4.2
- Update to Xcode 10.2
- Update SwiftLint to 0.31.0

7.0.0
-----

This release closes the [7.0.0 milestone](https://github.com/jessesquires/JSQDataSourcesKit/milestone/12?closed=1).

## Breaking

- Converted to Swift 4.0

- iOS 9.0 minimum now required

- tvOS 10.0 minimum now required

- **Significant renaming refactor:** renamed all "factory" references to "config", see #73 for details and reasoning
    - `ReusableViewFactoryProtocol` --> `ReusableViewConfigProtocol`
    - `ViewFactory` --> `ReusableViewConfig`
    - `TitledSupplementaryViewFactory` --> `TitledSupplementaryViewConfig`
    - Updated function param names `cellFactory:` --> `cellConfig:`
    - Updated function param names `supplementaryFactory:` --> `supplementaryConfig:`

- Removed `SectionInfoProtocol` in favor of using a concrete `Section`. `DataSource` now references `Section` directly. (#103)

## New

- Added new `DataSourceProtocol` extension convenience method `func item(atIndexPath indexPath: IndexPath) -> Item?`.
- Added new `TableEditingController` to support table view editing functionality provided by `UITableViewDataSource`. (#29, #80, #100)

6.0.0
-----

This release closes the [6.0.0 milestone](https://github.com/jessesquires/JSQDataSourcesKit/milestone/9).

**Swift 3.0 now required.**

5.0.0
-----

This release closes the [5.0.0 milestone](https://github.com/jessesquires/JSQDataSourcesKit/milestone/8).

**Swift 2.3 now required.**

4.0.1
-----

This release closes the [4.0.1 milestone](https://github.com/jessesquires/JSQDataSourcesKit/milestone/10).

- Fixed an issue with `carthage build` (#61, #62). Thanks @dcaunt!

4.0.0
-----

This release closes the [4.0.0 milestone](https://github.com/jessesquires/JSQDataSourcesKit/milestone/7).

This release is essentially a complete re-write of the library. If you are currently using this, migration to `4.0` will be pretty involved, but it will be worth it. The result is a *dramatically simpler* API.

As always, see the [updated documentation for details](http://www.jessesquires.com/JSQDataSourcesKit/index.html).

## New 🎉

- tvOS support
- Swift Package Manager support

## Bug fixes 🐛

- Fixed crash when dequeuing a supplementary view for an empty collection view section (#38). You can now have supplementary views for empty sections.

## ⚠️  Breaking changes ⚠️

### Swift

- Updated to Swift 2.2.
- **Swift 2.2. and above is now required.**

### Major API changes

This release includes a complete revamp of the API (#48). It is now much cleaner, simpler, and easier to use. It has also been updated to be more *Swifty* according to the latest Swift API Guidelines.

This library was originally written *before* **protocol extensions** were introduced in Swift. The reimagining of this library and it's APIs are now heavily based on protocol extensions.

##### New `DataSource`

- There's a new `DataSourceProtocol` and concrete `DataSource` model. This represents (and owns) your sections.
- There's a new `FetchedResultsController<T>`, which is a generic `NSFetchedResultsController` that conforms to `DataSourceProtocol`.

##### DataSourceProvider objects

All of the `*DataSourceProvider` classes have been unified into a single class, `DataSourceProvider`. This new class is initialized with a `DataSourceProtocol` and replaces all of the following:

- Removed `TableViewDataSourceProvider`
- Removed `TableViewFetchedResultsDataSourceProvider`
- Removed `CollectionViewDataSourceProvider`
- Removed `CollectionViewFetchedResultsDataSourceProvider`

##### Section objects

The section objects are now unified into a single `Section` object and `SectionInfoProtocol` protocol, instead of having table-specific and collection-specific models. The new `Section` and `SectionInfoProtocol` replace the following:

- Removed `CollectionViewSectionInfo`
- Removed `CollectionViewSection`
- Removed `TableViewSectionInfo`
- Removed `TableViewSection`

##### Cell factory objects

The cell factories have been unified into a single `ViewFactory` object and `ReusableViewFactoryProtocol` protocol, which replace the following:

- Removed `CollectionViewCellFactoryType`
- Removed `CollectionViewCellFactory`
- Removed `TableViewCellFactoryType`
- Removed `TableViewCellFactory`
- Removed `CollectionSupplementaryViewFactoryType`
- Removed `SupplementaryViewFactory`

##### FetchedResultsDelegateProviers

The `*FetchedResultsDelegateProvider` classes have been unified into a single class, `FetchedResultsDelegateProvider`, which replaces the following:

- Remove `CollectionViewFetchedResultsDelegateProvider`
- Remove `TableViewFetchedResultsDelegateProvider`

##### `TitledCollectionReusableView` changes:

* Renamed to `TitledSupplementaryView`
* `TitledCollectionReusableViewFactory` was replaced by `TitledSupplementaryViewFactory`
* No longer uses a `xib`, but programmatic layout
* `TitledCollectionReusableView.xib` was **removed**
* `TitledCollectionReusableView.nib` was **removed**
* The `leadingSpacing`, `topSpacing`, `trailingSpacing` and `bottomSpacing` constraint properties have been **removed** and replaced with `verticalInset` and `horizontalInset` properties

3.0.1
-----

Bug fixes from the [3.0.1](https://github.com/jessesquires/JSQDataSourcesKit/milestone/6) milestone.

3.0.0
-----

This release closes the [3.0.0 milestone](https://github.com/jessesquires/JSQDataSourcesKit/milestone/4).

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

Find the complete list of closed issues [here](https://github.com/jessesquires/JSQDataSourcesKit/milestone/3) for the 2.0.0 milestone.

## Documentation

All [documentation](http://www.jessesquires.com/JSQDataSourcesKit/index.html) has been updated. :scroll:

## Example app

The [example app](https://github.com/jessesquires/JSQDataSourcesKit/tree/develop/Example) is now much cleaner, and much more awesome. :sunglasses:

1.0.0
-----

It's here! :tada:

Checkout the `README` and documentation.
