//
//  Location.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import CoreLocation

struct Location {
    let coordinate: CLLocationCoordinate2D
    let placemark: Placemark
}

extension Location {
    init() {
        self.init(coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), placemark: Placemark())
    }

    init(coordinate: CLLocationCoordinate2D, placemark: CLPlacemark) {
        self.init(coordinate: coordinate, placemark: Placemark(placemark))
    }
}

extension Location: Equatable {
    static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.coordinate == rhs.coordinate && lhs.placemark == rhs.placemark
    }
}
