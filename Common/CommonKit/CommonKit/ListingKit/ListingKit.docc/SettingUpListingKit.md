# Setting Up ListingKit

ListingKit consists three components. A collection view, a data source object that manages the collection view and sections that represents each section in the collection view. Here is the diagram that displays ListingKit structure:

![ListingKit overview](ListingKitOverview)

To start using ListingKit you must first create your collection view. ListingKit does not impose any rules on how you create your collection view. You can use nib, storyboard or create in in code. One important thing is you must not set any delegate and dataSource of collection view.

After you have a collection view you should create a data source object. In ListingKit there is data source object. The data source manages the collection view. You can create a data source with the ``ListDataSource/init(collectImpression:alwaysUseReloadDataSource:prefetchingEnabled:useNewDiffableDataSource:viewController:)`` method.
```swift
let dataSource = ListDataSource()
```

After that call ``ListDataSource/prepare(for:)`` method with the collection view.
```swift
dataSource.prepare(for: collectionView)
```

Now you are ready to add sections to data source. You can call ``ListDataSource/reload(newSections:completion:)`` method for adding sections to data source. This will reload collection view with the cells provided by sections.
