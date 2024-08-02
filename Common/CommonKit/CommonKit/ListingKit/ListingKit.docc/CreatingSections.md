# Creating Sections

Sections are building blocks of ``ListingKit``. Every section is responsible to create cells and header and footer views.

![Sample Section](sample_section)

By conforming a type ``ListSection`` you can create a section.

## Basic Section
```swift
class RestaurantsSection: ListSection {
    var context: ListContext?
    var items: [ListIdentifiable] {
        restaurants
    }
    let listIdentifier: String = "restaurants"

    private var restaurants: [RestaurantItem] = []

    func cell(for itemIdentifier: String, at indexPath: IndexPath) -> UICollectionViewCell? {
        guard
            let item = restaurants.first(where: { $0.listIdentifier == itemIdentifier }),
            let cell: RestaurantCell = dequeueCell(at: indexPath)
        else { return nil }

        cell.configure(with: item)

        return cell
    }
}
```

Here is we are creating a section that lists restaurants. First thing is to create `RestaurantsSection` type and conform to ``ListSection`` protocol. 

Then we need to add some properties that are required by ``ListSection`` protocol. The first property is ``ListSection/context`` property. You have to define it and never assign it a value. It is assigned by ``ListingKit`` when section is added to collection view. You can use context to interact with data source. For example you can add new items to list via ``ListContext/insertItems(_:afterItem:in:animatingDifferences:completion:)`` method.

The other property is ``ListSection/items``. It must return array of the items that will be displayed in collectionview. Every item in the array corresponds the one cell in collection view. The type returned here must conform ``ListIdentifiable`` protocol. Here we return `restaurants` array from ``ListSection/items``. ``ListingKit`` uses ``ListIdentifiable`` protocol to distinguish items in section. Every item must return a unique identifier from ``ListIdentifiable/listIdentifier`` property. Otherwise ``ListingKit`` will remove duplicate items in the list.

The next property is `listIdentifier` property. In ``ListingKit`` sections must also be unique. The same ``ListIdentifiable`` rules are applied here to. In fact ``ListSection`` inherites from ``ListIdentifiable`` protocol. So you must assign a unique identifier here too. If you have duplicate ``ListIdentifiable/listIdentifier`` for sections ``ListingKit`` will remove duplicate sections from the list before displaying them in collection view.

The last required method is ``ListSection/cell(for:at:)`` method. You must implement this method and return a cell for the given item identifier. Here we first search the item by its identifier and then dequeued a cell for it. For cells and other views you don't have to register them. ``ListingKit`` automatically registers cell before first usage.

## Header and Footer Views

If your section will also display header and footer views you can conform ``ListingKit/ListSectionSupplementaryViewSource`` protocol. You can implement ``ListSectionSupplementaryViewSource/headerView(for:)-9giy3`` and ``ListSectionSupplementaryViewSource/footerView(for:)-9kx9d`` methods and create header and footer views. You don't need to register header and footer footer views.

```swift
extension RestaurantsSection: ListSectionSupplementaryViewSource {
    func headerView(for indexPath: IndexPath) -> UICollectionReusableView? {
        guard let header: RestaurantSectionHeaderView = dequeHeaderView(at: indexPath) else { return nil }
        // configure header
        return header
    }
}
```

## Layout
ListingKit supports both flow layout and compositional layout. Layout is section based.

### Flow Layout
When using ListingKit with flow layout every section has the ability to determine its cells size. You can implement ``ListSection/size(at:)-22nlg`` method to calculate size for a cell

```swift
extension RestaurantsSection {
    func size(at indexPath: IndexPath) -> CGSize {
        guard
            let identifier = context?.itemIdentifier(at: indexPath),
            let restaurantItem = restaurants.first(where: { $0.listIdentifier == identifier })
        else { return .zero }

        return CGSize(
            width: listSize.width,
            height: restaurantItem.isExpanded ? 200 : 100
        )
    }
}
```

Here we implement ``ListSection/size(at:)-22nlg`` method. Inside it we first get the item identifier in listingkit at given indexPath. Then we get the actual restaurant item with the identifier. Them we return the cell size according to restaurant item is expanded or not. You can use ``ListSection/listSize`` property to get collection view's size here.

For footer and header size you can implement ``ListSectionSupplementaryViewSource/referenceSizeForFooterView(section:)-2bcqr`` and ``ListSectionSupplementaryViewSource/referenceSizeForHeaderView(section:)-3pjqs`` methods.

```swift
extension RestaurantsSection {
    func referenceSizeForHeaderView(section: Int) -> CGSize {
        CGSize(width: .zero, height: 100)
    }
}
```

For other properties in flow layout you can implement ``ListSection/inset-4ntm8``, ``ListSection/minimumLineSpacing-4x0sk``, ``ListSection/minimumInteritemSpacing-5odqw`` properties.
```swift
extension RestaurantsSection {
    var inset: UIEdgeInsets { .init(top: 10, left: 10, bottom: 10, right: 10) }
    var minimumLineSpacing: CGFloat { 10 }
    var minimumInteritemSpacing: CGFloat { 10 }
}
```

### Compositional Layout
To use compositional layout with ListingKit you have to create UICollectionViewCompositionalLayout with the following code:
```swift
let dataSource = ListDataSource()

let configuration = UICollectionViewCompositionalLayoutConfiguration()
configuration.scrollDirection = .vertical

let layout = UICollectionViewCompositionalLayout(
    sectionProvider: { section, environment in
        dataSource.compositionalSectionLayoutProvider(at: section, environment: environment)
    },
    configuration: configuration
)

collectionView.collectionViewLayout = layout
```

Then inside your section implement ``ListSection/layout(in:)-1dplc`` method and return `NSCollectionLayoutSection` instance from that method. Here we are creating a grid layout for restaurant cells:

```swift
extension RestaurantsSection {
    func layout(in environment: NSCollectionLayoutEnvironment?) -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        return section
    }
}
```

## Handle Item Selection
For listening cell selection events from section you can implement ``ListSection/didSelectItem(for:at:)-29ikj`` method inside your section:
```swift
extension RestaurantsSection {
    func didSelectItem(for itemIdentifier: String, at indexPath: IndexPath) {
        guard let restaurantItem = restaurants.first(where: { $0.listIdentifier == itemIdentifier }) else { return }
        // present restaurant detail screen
    }
}
```
Here we first find the restaurant item that is clicked by its `listIdentifier` and then present restaurant detail screen

## Updating Section's Contents
You can change the items in section after it added to collection view. For example you can delete an item when user swipes to delete a cell. Or you can load new items when user scrolled to end of the section. For this operations ``ListSection`` comes with loads of methods to manipulate collection view. Here we are appending new restaurant items at the end of the section. After appending new items we call ``ListSection/append(items:animatingDifferences:completion:)`` method to update collection view.
```swift
extension RestaurantsSection {
    func loadNextPage() {
        let newRestaurants = getNextPage()
        restaurants.append(contentsOf: newRestaurants)
        self.append(newRestaurants)
    }
}
```

To completely update section's content you can use ``ListSection/newUpdate(reloadingItems:reloadingHeader:reloadingFooter:animatingDifferences:completion:)`` method.
There are other methods in ``ListSection`` to update section's content. You can discover them in ``ListSection`` document.
