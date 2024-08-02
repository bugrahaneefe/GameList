# ``ListingKit/ListSection``

## Topics

### Required Properties For ListingKit
- ``context``
- ``items``

### Cell Creation
- ``cell(for:at:)``
- ``dequeueCell(at:)``
- ``dequeueCell(at:bundle:)``
- ``dequeueCell(withNibName:bundle:at:)``

### Supplementary View Creation
- ``dequeHeaderView(at:)``
- ``dequeHeaderView(at:bundle:)``
- ``dequeHeaderView(nibName:bundle:at:)``
- ``dequeFooterView(at:)``
- ``dequeFooterView(at:bundle:)``
- ``dequeFooterView(nibName:bundle:at:)``
- ``dequeueSupplementaryView(ofKind:at:)``
- ``dequeueSupplementaryView(ofKind:nibName:bundle:at:)``

### Section Lifecycle
- ``didMoveToList()-xgxi``
- ``didBecomeActive()-2bzh5``
- ``didBecomeDeactive()-5ucxe``

### Collection View Events
- ``didSelectItem(for:at:)-5k0e3``
- ``willDisplay(at:)-25s0f``
- ``didEndDisplay(at:)-6am4r``

### Reloading Items
- ``reconfigure(items:animatingDifferences:completion:)``
- ``update(reconfigureItems:reloadHeaderAndFooter:animatingDifferences:completion:)``
- ``reload(completion:)``

### Rearranging Items
- ``insertItems(_:afterItem:animatingDifferences:completion:)``
- ``insertItems(_:beforeItem:animatingDifferences:completion:)``
- ``deleteItems(_:animatingDifferences:completion:)``
- ``moveItem(_:afterItem:animatingDifferences:completion:)``
- ``moveItem(_:beforeItem:animatingDifferences:completion:)``

### Flow Layout Properties
- ``inset-4ntm8``
- ``minimumLineSpacing-83xw8``
- ``minimumInteritemSpacing-9sd97``
- ``size(at:)-92azk``

### Compositional Layout Properties
- ``layout(in:)-1dplc``

### Scrolling To a Cell
- ``scrollTo(item:at:animated:)``

### Getting Section Information
- ``listSize``
- ``sectionIndex``

### Pagination
- ``hasPagination(for:)-3gsn2``
