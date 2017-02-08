//
//  AppCoordinator.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import ReSwift
import UIKit

class AppCoordinator: BaseCoordinator {
    fileprivate let navigationController: BaseNavigationController
    fileprivate let locator: Locator
    fileprivate let forecaster: Forecaster
    fileprivate let store: MainStore

    init(navigationController: BaseNavigationController, locator: Locator, forecaster: Forecaster, store: MainStore) {
        self.navigationController = navigationController
        self.locator = locator
        self.forecaster = forecaster
        self.store = store
    }

    override func start() {
        locator.askForPermission()

        let forecastListCoordinator = ForecastListCoordinator(
            navigationController: navigationController,
            store: store,
            forecaster: forecaster
        )
        forecastListCoordinator.start()
        addChild(forecastListCoordinator)
    }
}
