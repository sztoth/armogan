//
//  MKMapView+Arm.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 28..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import MapKit

extension MKMapView {
    func arm_zoomToUserLocationAnimated(_ animated: Bool) {
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        setRegion(region, animated: animated)
    }
}
