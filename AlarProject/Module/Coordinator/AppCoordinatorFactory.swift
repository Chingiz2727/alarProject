import Core

final class AppCoordinatorFactory {
    init() {}
    
    func makeLoginModule() -> LoginModule {
        let vc = LoginViewController()
        let viewModel = LoginViewModelImpl()
        vc.viewModel = viewModel
        return vc
    }
    
    func makeListModule(code: String) -> DataListModule {
        let vc = DataListViewController(code: code)
        let nav = BaseNavigationController(rootViewController: vc)
        return vc
    }
    
    func makeDetailView(data: Data) -> MapModule {
        let mapViewModel = MapManager(engine: MapViewModel())
        let controller = MapViewController(data: data, viewModel: mapViewModel)
        return controller
    }
}
