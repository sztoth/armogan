//
//  ForecastListCoordinator.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 05..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import ReSwift
import RxSwift
import UIKit

class ForecastListCoordinator: BaseCoordinator {
    fileprivate let navigationController: BaseNavigationController
    fileprivate let store: MainStore
    fileprivate let forecaster: Forecaster

    init(navigationController: BaseNavigationController, store: MainStore, forecaster: Forecaster) {
        self.navigationController = navigationController
        self.store = store
        self.forecaster = forecaster
    }

    override func start() {
        startWeatherListFlow()
    }
}

fileprivate extension ForecastListCoordinator {
    func startWeatherListFlow() {
        let dataSource = WeatherCollectionDataSource(store: store)
        let viewModel = ForecastListViewModel(dataSource: dataSource, forecaster: forecaster)
        let viewController = ForecastListViewController(viewModel: viewModel)

        viewModel.action
            .subscribe(onNext: { [unowned self] in
                self.handleWeatherListViewModelAction($0, from: viewController)
            })
            .addDisposableTo(disposeBag)

        navigationController.setViewControllers([viewController], animated: false)
    }

    func startNewLocationFlow() {
        let coordinator = NewLocationCoordinator(navigationController: navigationController, store: store)
        coordinator.start()
        addChild(coordinator)
    }

    func startDetailFlow(from viewController: UIViewController) {
        let coordinator = ForecastDetailCoordinator(viewController: viewController, store: store)
        coordinator.start()
        addChild(coordinator)
    }
}

fileprivate extension ForecastListCoordinator {
    func handleWeatherListViewModelAction(_ action: ForecastListViewModel.Action, from viewController: UIViewController) {
        switch action {
        case .addNewLocation:
            startNewLocationFlow()
        case .showDetails:
            startDetailFlow(from: viewController)
        }
    }
}
