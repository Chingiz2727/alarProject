import Core
import UIKit

class DataSectionBuilder: BaseSectionControllerBuilder {
    var dataProviderBlock: (() -> PaginatedDataProvider<Data>?)?

    override func build(state: FeedState) -> ListSectionController {
        let controller = DataSectionController()
        controller.updateItems(state)
        
        configure(controller)
        return controller
    }
}


class DataSectionController: BaseListSectionController {
    
    private(set) var viewModels: [Data] = []
    weak var dataProvider: PaginatedDataProvider<Data>?

    override var reloadsCollectionViewOnUpdate: Bool { return true }
    private let cellFactory: CardDataCellFactory
    
    override var items: [Any] {
        didSet {
            let data = items.compactMap { $0 as? Data }
            viewModels.append(contentsOf: data)
        }
    }
    
    override func updateItems(_ state: FeedState) {
        self.items = state.items
 
    }
    
    override func reload(with state: FeedState, completion: BoolBlock?) {
        let items = state.items.compactMap { $0 as? Data }
        let reloadInfo = diffItems(items)
        collection.reload(reloadInfo: reloadInfo, dataUpdateBlock: { [weak self] in
            self?.collection.section = items.count
            self?.viewModels = items
        }, completion: completion)
    }
    
    override var numberOfItems: Int {
        return viewModels.count
    }
    
    override func registerCells() {
        CardDataCollectionViewCell.register(in: collection.collectionView)
    }
    
    override init(layoutSource: ListLayoutSource? = HorizontalPicksLayoutSource(kind: .medium)) {
        self.cellFactory = CardDataTileFactory()
        super.init(layoutSource: layoutSource)
    }
    
    override func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = viewModels[indexPath.row]
        let cell = cellFactory.makeCell(from: viewModel, in: collection.collectionView, indexPath: indexPath)
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        guard let module = collection.viewController as? DataListModule else { return }
        module.onDataSelect?(viewModels[index])
    }
}

extension DataSectionController: DiffableSectionController {
    func diffItems(_ newItems: [Any]) -> ChangeWithIndexPath? {
        let newItems = newItems.compactMap { $0 as? Data }
        let changes = diff(old: self.viewModels, new: newItems)
        return IndexPathConverter().convert(changes: changes, section: collection.section)
    }
}
