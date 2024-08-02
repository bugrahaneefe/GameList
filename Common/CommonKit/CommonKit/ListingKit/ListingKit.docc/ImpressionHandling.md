# Impression Handling

ListingKit comes with builtin impression handling support. Impression handling is getting callback when an item is first appeared in collection view. With impression handling you can send analytics events when items in collection view becomes visible.

## Overview

To enable impression handling first you need to create data source with the `collectImpression` config:
```swift
let dataSource = ListDataSource(collectImpression: true)
```

Then in your section conform to ``ImpressionDisplaySection`` protocol and implement ``ImpressionDisplaySection/didHaveImpression(for:at:)`` method. When the item becomes visible in collection view ListingKit will call this method with the identifier of visible item. You don't need to keep track of already visible items. ListingKit will not call the ``ImpressionDisplaySection/didHaveImpression(for:at:)`` when the item reappeared in the collection view again.
```swift
extension RestaurantsSection: ImpressionDisplaySection {
    func didHaveImpression(for item: String, at indexPath: IndexPath) {
        guard let restaurantItem = restaurants.first(where: { $0.listIdentifier == item }) else { return }
        // send analytics event for restaurant item
    }
}
```

If you are using ``GenericSection`` you can get impression events with calling ``GenericSection/onImpression(_:)`` method.
```swift
let section = GenericSection(items: items)
    .onImpression { restaurantItem, indexPath in
        // send analytics event for restaurant item
    }
```
