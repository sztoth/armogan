//
//  BaseCoordinator.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
import RxSwift

class BaseCoordinator {
    fileprivate(set) lazy var disposeBag = DisposeBag()

    var finished: Observable<Void> {
        return _finished.asObservable()
    }

    fileprivate(set) weak var parentCoordinator: BaseCoordinator?
    fileprivate(set) var childCoordinators = [BaseCoordinator]()

    fileprivate let _finished = PublishSubject<Void>()

    func start() {
        fatalError("Must be overridden in subclass")
    }

    func finish() {
        _finished.onNext()
        removeFromParentCoordinator()
    }
}

extension BaseCoordinator {
    func addChild(_ coordinator: BaseCoordinator) {
        if coordinator.parentCoordinator == nil && !childCoordinators.contains(where: { $0 === coordinator }) {
            coordinator.parentCoordinator = self
            childCoordinators.append(coordinator)
        }
    }

    func removeFromParentCoordinator() {
        if let parentCoordinator = parentCoordinator {
            parentCoordinator.removeChild(self)
        }
    }
}

fileprivate extension BaseCoordinator {
    func removeChild(_ coordinator: BaseCoordinator) {
        if let index = childCoordinators.index(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}

