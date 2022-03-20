//
//  AppDelegate.swift
//  AlarProject
//
//  Created by Sberbussines on 17.03.2022.
//

import UIKit
import Core

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var diContainer: Container!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let di: RootContainerConfigurator = .init(otherConfigurators: [])
        diContainer = di.configureContainer()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        makeCoordinator().start()
        window?.makeKeyAndVisible()

        // Override point for customization after application launch.
        return true
    }
    
    func makeCoordinator() -> Coordinator {
        let routable = AppRouterImpl(window: window)
        let coordinator = AppCoordinatorImpl(router: routable)
        return coordinator
    }
}

