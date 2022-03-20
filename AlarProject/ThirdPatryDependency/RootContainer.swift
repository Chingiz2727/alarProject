import Foundation
import Core
// MARK: - Common configurator

protocol Configurator {
    func configure()
}

// MARK: - Generic Container

// TODO: - This file isn't in use yet. The plan is to migrate all the DI logic from AppDelegate to Containers
// In this case - RootContainer only for now

protocol Container: AnyObject {
    func resolve<Service>(_ type: Service.Type, name: String?) -> Service

    func resolve<Service>(_ type: Service.Type) -> Service
}

extension Resolver: Container {
    func resolve<Service>(_ type: Service.Type, name: String?) -> Service {
        return resolve(type, name: name, args: nil)
    }

    func resolve<Service>(_ type: Service.Type) -> Service {
        return resolve(type, name: nil)
    }
}

// MARK: - RootContainer

final class RootContainer: Container {

    private let baseSontainer: Resolver

    init(baseSontainer: Resolver) {
        self.baseSontainer = baseSontainer
    }

    func resolve<Service>(_ type: Service.Type = Service.self, name: String? = nil) -> Service {
        return baseSontainer.resolve(type, name: name)
    }

    func resolve<Service>(_ type: Service.Type = Service.self) -> Service {
        return resolve(type, name: nil)
    }
    
}

// MARK: - Configurator

final class RootContainerConfigurator {

    static let shared = RootContainerConfigurator(otherConfigurators: [])
    
    private let resolver: Resolver = Resolver.root
    private let otherConfigurators: [Configurator]

    init(otherConfigurators: [Configurator]) {
        self.otherConfigurators = otherConfigurators
    }

    func configureContainer() -> Container {
        let rootContainer = RootContainer(baseSontainer: resolver)
        let resolver = self.resolver
        resolver.register { NetworkAdapter(sessionManager: sessionManager) as NetworkService }.scope(Resolver.application)

        return rootContainer
    }

    // MARK: - Search
}
