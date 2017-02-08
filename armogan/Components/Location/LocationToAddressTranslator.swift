//
//  LocationToAddressTranslator.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 04..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import CoreLocation
import RxSwift

class LocationToAddressTranslator {
    fileprivate let geocoder: CLGeocoder

    init(geocoder: CLGeocoder = CLGeocoder()) {
        self.geocoder = geocoder
    }

    func placemark(with coordinate: CLLocationCoordinate2D) -> Observable<CLPlacemark> {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        return Observable<CLPlacemark>.create { observer in
            self.geocoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
                guard let placemark = placemarks?.first else {
                    observer.onError(OperationError.noPlacemarkAvailable)
                    return
                }

                if let error = error {
                    observer.onError(error)
                }
                else {
                    observer.onNext(placemark)
                    observer.onCompleted()
                }
            }

            return Disposables.create {
                self.geocoder.cancelGeocode()
            }
        }
    }
}

extension LocationToAddressTranslator {
    enum OperationError: Error {
        case noPlacemarkAvailable
    }
}
