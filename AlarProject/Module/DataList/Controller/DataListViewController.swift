import Core
import CoreUI
import UIKit

final class DataListViewController: UIViewController, ViewOwner, DataListModule {
    typealias RootView = DataListView
    private var dataSource: SectionDataSource!
    let viewModel: DataListViewModel
    var onDataSelect: OnDataSelect?
    
    lazy var dataSection: DataSectionController = {
        let builder = DataSectionBuilder(configureControllerBlock: nil)
        
        let displayDelegate = ListPaginationController<Data>(threshold: 3, dataProvider: viewModel.dataSection.dataProvider)
        let controller = builder.build(state: FeedState(items: [], loadingState: .notReady)) as! DataSectionController
        controller.displayDelegate = displayDelegate
        displayDelegate.sectionController = controller
        return controller
    }()
    
    init(code: String) {
        viewModel = DataListViewModel(code: code)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        view = DataListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.onStateUpdated = { [weak self] newState, update in
            guard let self = self else { return }
            if newState.isLoaded {
                let picksState = self.viewModel.dataSection.state
                self.dataSection.updateItems(picksState)
                
                self.dataSource.updateSections(sections: [self.dataSection], reloadType: .reload, completion: nil)
            }
        }
    }
    
    private func setupView() {
        let reloader = DefaultCollectionViewReloader()
        dataSource = SectionDataSource(sections: [], commonReloader: reloader)
        dataSource.setupView(collectionView: rootView.collectionView, controller: self)
        viewModel.reloadData(cachePolicy: .fetchIgnoringCacheData)
    }
    
}
