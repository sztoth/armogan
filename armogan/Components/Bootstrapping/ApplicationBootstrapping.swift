//
//  ApplicationBootstrapping.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import ReSwift
import UIKit

class ApplicationBootstrapping: Bootstrapping {
    fileprivate(set) var coordinator: AppCoordinator?

    fileprivate let navigationController: BaseNavigationController

    init(navigationController: BaseNavigationController) {
        self.navigationController = navigationController
    }

    func bootstrap(_ bootstrapped: Bootstrapped) throws {
        let state = AppStateFactory.defaultState()
        let store = MainStore(reducer: CombinedReducer([AppReducer(), LocationPermissionReducer()]), state: state, middleware: [loggingMiddleware])
        let locator = Locator(store: store)
        let forecaster = Forecaster(resourceFactory: DarkSkyResourceFactory(), store: store)

        coordinator = AppCoordinator(
            navigationController: navigationController,
            locator: locator,
            forecaster: forecaster,
            store: store
        )
    }
}

let loggingMiddleware: Middleware = { dispatch, getState in
    return { next in
        return { action in
            // perform middleware logic
            print("Type: \(type(of: action))")

            // call next middleware
            return next(action)
        }
    }
}
