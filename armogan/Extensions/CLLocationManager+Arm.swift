//
//  CLLocationManager+Arm.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import CoreLocation

extension CLLocationManager {
    var arm_enabled: Bool {
        let status = CLLocationManager.authorizationStatus()
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }
}
