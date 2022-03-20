import Core

final class DataListViewModel: FeedViewModel {
    
    let code: String
    
    lazy var dataSection: DataListSectionViewModel = {
        let builder = DataSectionBuilder(configureControllerBlock: nil)
        let viewModel = DataListSectionViewModel(code: code, sectionControllerBuilder: builder)
        return viewModel
    }()
 
    init(code: String) {
        self.code = code
        super.init(stateInitializator: nil)
        setStateInitializator()
    }
    
    override func stateUpdated(reloadSection sectionToReload: Int? = nil) {
        onStateUpdated?(self.state, DataListReloadType.reload)
    }
    
    private func setStateInitializator() {
        self.stateInitializator = { [weak self] _ in
            return self?.makeState() ?? FeedSectionsState(sections: [])
        }
    }
    
    private func makeState() -> FeedSectionsState {
        return FeedSectionsState(sections: [dataSection])
    }
}
