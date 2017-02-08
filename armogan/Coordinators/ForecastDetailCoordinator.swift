//
//  ForecastDetailCoordinator.swift
//  armogan
//
//  Created by Szabolcs Toth on 2017. 01. 01..
//  Copyright © 2017. Szabolcs Toth. All rights reserved.
//

import UIKit

class ForecastDetailCoordinator: BaseCoordinator {
    fileprivate let viewController: UIViewController
    fileprivate let store: MainStore

    init(viewController: UIViewController, store: MainStore) {
        self.viewController = viewController
        self.store = store
    }

    override func start() {
        let detailController = ForecastDetailViewController()
        viewController.present(detailController, animated: true, completion: nil)
    }
}
