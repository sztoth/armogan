//
//  RxMKMapViewDelegateProxy.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 28..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import MapKit
import RxSwift
import RxCocoa

class RxMKMapViewDelegateProxy: DelegateProxy, MKMapViewDelegate, DelegateProxyType {
    class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let mapView: MKMapView = (object as? MKMapView)!
        return mapView.delegate
    }

    class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let mapView: MKMapView = (object as? MKMapView)!
        mapView.delegate = delegate as? MKMapViewDelegate
    }
}
