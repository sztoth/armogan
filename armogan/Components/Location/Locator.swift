//
//  Locator.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 04..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import CoreLocation
import ReSwift
import RxSwift

class Locator {
    fileprivate let disposeBag = DisposeBag()

    fileprivate let updater: LocationUpdater
    fileprivate let translator: LocationToAddressTranslator
    fileprivate let store: MainStore

    init(
        updater: LocationUpdater = LocationUpdater(),
        translator: LocationToAddressTranslator = LocationToAddressTranslator(),
        store: MainStore
    ) {
        self.updater = updater
        self.translator = translator
        self.store = store

        setupBindings()
    }

    func askForPermission() {
        updater.askForPermission()
    }
}

fileprivate extension Locator {
    func setupBindings() {
        let coordinate = updater.coordinate

        let translateLocationSignal = coordinate
            .throttle(2.0, latest: true, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest { [weak self] in
                self?.translator.placemark(with: $0) ?? Observable.empty()
            }

        let updateSignal = Observable.zip(coordinate, translateLocationSignal) { (coordinate, placemark) in
            return Location(coordinate: coordinate, placemark: placemark)
        }

        updateSignal
            .map { UpdateCurrentLocation(location: $0) }
            .subscribe(onNext: { [weak self] in
                self?.dispathAction($0)
            })
            .addDisposableTo(disposeBag)

        updater.authorized
            .map { UpdateLocationPermission(authorized: $0) }
            .subscribe(onNext: { [weak self] in
                self?.dispathAction($0)
            })
            .addDisposableTo(disposeBag)
    }
}

fileprivate extension Locator {
    func dispathAction(_ action: Action) {
        store.dispathOnMain(action)
    }
}
