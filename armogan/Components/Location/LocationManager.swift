//
//  LocationManager.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import CoreLocation

class LocationManager: CLLocationManager {
    override init() {
        super.init()

        desiredAccuracy = kCLLocationAccuracyHundredMeters
        pausesLocationUpdatesAutomatically = true
    }
}
