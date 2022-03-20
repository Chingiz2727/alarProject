import Core

protocol AppCoordinator: Coordinator {}

final class AppCoordinatorImpl: BaseCoordinator, AppCoordinator {
    
    private let factory = AppCoordinatorFactory()
    
    override func start() {
        addDependency(self)
        let navController = BaseNavigationController()
        let router = NavigationRouterImpl(rootController: navController)
        
        setLogin()
    }
    
    private func setLogin() {
        var module = factory.makeLoginModule()
        module.onSuccess = { [weak self] code in
            guard let self = self else { return }
            self.setDataList(code: code)
        }
        
        router.setRootModule(module)
        
    }
    
    private func setDataList(code: String) {
        var module = factory.makeListModule(code: code)
        module.onDataSelect = { [weak self] data in
            self?.showMapData(data: data)
        }
        let vc = BaseNavigationController(rootViewController: module.toPresent()!)
        let navigationBarPage = NavigationRouterImpl(rootController: vc)
        router.setRootModule(navigationBarPage)
    }
    
    private func showMapData(data: Data) {
        let module = factory.makeDetailView(data: data)
        router.push(module)
    }
}

final class MainCoordinator: BaseCoordinator {
    let code: String
    private let factory = AppCoordinatorFactory()

    init(router: Routable, code: String) {
        self.code = code
        super.init(router: router)
    }
    
    override func start() {
        var module = factory.makeListModule(code: code)
        module.onDataSelect = { [weak self] data in
            self?.showMapData(data: data)
        }

        let vc = BaseNavigationController(rootViewController: module.toPresent()!)
        let routable = NavigationRouterImpl(rootController: vc)
        router.setRootModule(routable)
//        routable.setRootModule(module)
    }
    
    private func showMapData(data: Data) {
        let module = factory.makeDetailView(data: data)
        router.push(module)
    }
}
