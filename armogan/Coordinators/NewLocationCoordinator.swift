//
//  NewLocationCoordinator.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 11..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import ReSwift
import RxSwift
import UIKit

class NewLocationCoordinator: BaseCoordinator {
    fileprivate let navigationController: BaseNavigationController
    fileprivate let store: MainStore

    init(navigationController: BaseNavigationController, store: MainStore) {
        self.navigationController = navigationController
        self.store = store
    }

    override func start() {
        let viewModel = NewLocationViewModel(store: store, locationTranslator: LocationToAddressTranslator())
        let controller = NewLocationViewController(viewModel: viewModel)

        viewModel.action
            .subscribe(onNext: { [unowned self] action in
                switch action {
                case .close:
                    controller.dismiss(animated: true, completion: nil)
                    self.finish()
                }
            })
            .addDisposableTo(disposeBag)

        let navController = BaseNavigationController(rootViewController: controller)
        navigationController.present(navController, animated: true, completion: nil)
    }
}
