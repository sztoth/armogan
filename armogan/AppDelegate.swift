//
//  AppDelegate.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder {
    var window: UIWindow?

    fileprivate var coordinator: AppCoordinator?
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let navigationController = BaseNavigationController()

        let components: [Bootstrapping] = [
            ApplicationBootstrapping(navigationController: navigationController)
        ]

        bootstrap(components)
        showWindow(with: navigationController)

        return true
    }
}

fileprivate extension AppDelegate {
    func bootstrap(_ components: [Bootstrapping]) {
        do {
            let bootstrapped = try Bootstrapper.bootstrap(components)
            let application = try bootstrapped.component(ApplicationBootstrapping.self)
            coordinator = application.coordinator
        }
        catch BootstrappingError.expectedComponentNotFound(let componentName) {
            fatalError("\(componentName) was not bootstrapped. Terminating.")
        }
        catch {
            fatalError("Application launch failed: \(error)")
        }
    }

    func showWindow(with rootViewController: BaseNavigationController) {
        guard let coordinator = coordinator else {
            fatalError("Could not sucessfully initialize the app coordinator")
        }

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = rootViewController
        coordinator.start()

        window.makeKeyAndVisible()
        self.window = window
    }
}
