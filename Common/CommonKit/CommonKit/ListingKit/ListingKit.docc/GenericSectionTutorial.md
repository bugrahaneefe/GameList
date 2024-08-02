# Generic Section

Creating in place sections for ListingKit.

## Overview

In ListingKit you use ``ListSection`` protocol to create sections for collection view. However there is another way to create sections. You can use `GenericSection`.

Here we are creating generic section for restaurant list.
```swift
let section = GenericSection(listIdentifier: "restaurantsSection", items: restaurantItems)
```
You can omit the `listIdentifier` parameter and `GenericSection` will use UUID string for `listIdentifier`

### Configuring Cells and Cell Size

After you create section you can chain methods to further configure it. Generic section can only display one type of cell. Here we are telling `GenericSection` what cell it will use and also we configure its size in flow layout:
```swift
let section = GenericSection(listIdentifier: "restaurantsSection", items: restaurantItems)
    .onCellConfigure(for: RestaurantCell.self) { restaurantItem, cell, indexPath in
        cell.configure(with: restaurantItem)
    }
    .onCellSize { restaurantItem, listSize in
        return CGSize(
            width: listSize.width,
            height: restaurantItem.isExpanded ? 200 : 100
        )
    }
```

### Header, Footer and Custom Supplementary views

To add header view you can use one of the methods that begin with `onHeaderConfigure`
```swift
section
    .onHeaderConfigure(for: RestaurantSectionHeaderView.self) { headerView, indexPath in
        // configure headerView here
    }
    .onHeaderSize { index, listSize in
        CGSize(width: .zero, height: 100)
    }
```

For footer view you can use one of the methods that begin with `onFooterConfigure`
```swift
section
    .onFooterConfigure(for: RestaurantSectionFooterView.self) { footerView, indexPath in
        // configure footerView here
    }
    .onFooterSize { index, listSize in
        CGSize(width: .zero, height: 100)
    }
```

For custom supplementary views you can use one of the `onSupplementaryViewConfigure` methods. You can add as many as custom supplementary view by calling this method repeatedly on GenericSection
```swift
section
    .onSupplementaryViewConfigure(for: RestaurantItemBadgeView.self, kind: "badge") { badgeView, indexPath in
        // customize badge view
    }
```

### Layout for flow layout
If you are using flow layout in collection view you can control the section's layout with the following methods: For cell sizing call ``GenericSection/onCellSize(_:)`` method. For footer and header sizing call ``GenericSection/onHeaderSize(_:)`` and ``GenericSection/onFooterSize(_:)`` methods. For controlling other flow layout properties call ``GenericSection/sectionInset(_:)``, ``GenericSection/minimumLineSpacing(_:)``, ``GenericSection/minimumInterItemSpacing(_:)`` methods

### Layout for compositional layout
You can define sections layout for compositional layout with calling ``GenericSection/onLayout(_:)`` method. Here we create grid layout in compositional layout
```swift
section.onLayout { environment in
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)

    return section
}
```
If you are going to use compositional layout you don't need to use ``GenericSection/onCellSize(_:)``, ``GenericSection/onHeaderSize(_:)``, ``GenericSection/onFooterSize(_:)``, ``GenericSection/minimumLineSpacing(_:)``, ``GenericSection/minimumInterItemSpacing(_:)``, ``GenericSection/sectionInset(_:)`` methods. These callbacks will be called if the layout is flow layout.

### Impression Handling
To get impression events in GenericSection call ``GenericSection/onImpression(_:)`` method
```swift
section.onImpression { restaurantItem, indexPath in
    // handle impression event for restaurant item
}
```
For more information how impression handling works in ListingKit head over the <doc:ImpressionHandling> article.

### When to use GenericSection over ListSection
After all this information you may ask yourself when to choose ``GenericSection`` or create custom section with adopting ``ListSection`` protocol. The rule is simple. If you are just listing one type of data and you don't have custom logic such as adding new items to section, arranging items in section then go ahead and use ``GenericSection``. But if you have custom logic and If you intend to use same section in different screens then create a custom reusable section with adopting ``ListSection`` protocol.

### Conclusion
Here is at the end how our generic section looks like:
```swift
let section = GenericSection(listIdentifier: "restaurantsSection", items: restaurantItems)
    .onCellConfigure(for: RestaurantCell.self) { restaurantItem, cell, indexPath in
        cell.configure(with: restaurantItem)
    }
    .onCellSize { restaurantItem, listSize in
        return CGSize(
            width: listSize.width,
            height: restaurantItem.isExpanded ? 200 : 100
        )
    }
    .onHeaderConfigure(for: RestaurantSectionHeaderView.self) { headerView, indexPath in
        // configure headerView here
    }
    .onHeaderSize { index, listSize in
        CGSize(width: .zero, height: 100)
    }
    .onImpression { restaurantItem, indexPath in
        // handle impression event for restaurant item
    }
```
