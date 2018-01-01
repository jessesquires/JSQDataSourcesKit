# Getting Started

Watch [my talk](https://www.skilled.io/u/swiftsummit/pushing-the-limits-of-protocol-oriented-programming) from [Swift Summit](https://swiftsummit.com). See the [slides here](https://speakerdeck.com/jessesquires/pushing-the-limits-of-protocol-oriented-programming).

````swift
import JSQDataSourcesKit
````

## Design

This library has four primary components:

1. `Section` — represents a section of data
2. `DataSource` — represents a collection of `Section` types
3. `ReusableViewConfig` — responsible for dequeuing and configuring cells (for `UITableView` or `UICollectionView`)
4. `DataSourceProvider` — owns a data source and view config, and provides a `UICollectionViewDataSource` or `UITableViewDataSource` object.

## Example

The following illustrates a simple example of how these components interact for a collection view.

````swift
// Given a view controller with a collection view

// 1. create Sections and a DataSource with your model objects
let section0 = Section(items: ...)
let section1 = Section(items: ...)
let section2 = Section(items: ...)
let dataSource = DataSource(sections: section0, section1, section2)

// 2. create cell config
let cellConfig = ReusableViewConfig(reuseIdentifier: "CellId") { (cell, model?, type, collectionView, indexPath) -> MyCellClass in
    // configure the cell with the model
    return cell
}

// 3. create supplementary view config
let type = ReusableViewType.supplementaryView(kind: UICollectionElementKindSectionHeader)
let headerConfig = ReusableViewConfig(reuseIdentifier: "HeaderId", type: type) { (view, model?, type, collectionView, indexPath) -> MyHeaderView in
    // configure header view
    return view
}

// 4. create data source provider
let dataSourceProvider =  DataSourceProvider(dataSource: dataSource,
                                             cellConfig: cellConfig,
                                             supplementaryConfig: headerConfig)

// 5. set the collection view's data source
collectionView.dataSource = dataSourceProvider.collectionViewDataSource
````

## Demo Project

The [example project](https://github.com/jessesquires/JSQDataSourcesKit/tree/develop/Example) included exercises *all* functionality in this library.
