//
//  LocationUpdater.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 04..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import CoreLocation
import RxSwift

class LocationUpdater {
    var coordinate: Observable<CLLocationCoordinate2D> {
        return locationManager.rx.didUpdateLocations
            .filter { $0.hasElement }
            .map { $0.first!.coordinate }
            .distinctUntilChanged { lhs, rhs in
                return lhs == rhs
            }
    }
    var authorized: Observable<Bool> {
        return locationManager.rx.didChangeAuthorizationStatus.map(isAuthorized)
    }
    var enabled: Bool {
        return locationManager.arm_enabled
    }

    fileprivate let disposeBag = DisposeBag()

    fileprivate let locationManager: LocationManager

    init(locationManager: LocationManager = LocationManager()) {
        self.locationManager = locationManager

        setupBindings()
    }

    func askForPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
}

fileprivate extension LocationUpdater {
    func setupBindings() {
        locationManager.rx.didChangeAuthorizationStatus
            .filter { [unowned self] in
                self.isAuthorized($0)
            }
            .mapToVoid()
            .subscribe(onNext: { [unowned self] in
                self.handleSuccesfulAuthorizetion()
            })
            .addDisposableTo(disposeBag)
    }
}

fileprivate extension LocationUpdater {
    func isAuthorized(_ status: CLAuthorizationStatus) -> Bool {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }

    func handleSuccesfulAuthorizetion() {
        locationManager.startUpdatingLocation()
    }
}
