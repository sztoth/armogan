//
//  NetworkResource.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 04..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import CoreLocation

protocol NetworkResource {
    var url: URL { get }
    func forecast(from dictionary: [String: Any]) -> Forecast?
}

protocol NetworkResourceFactory {
    func resource(for coordinate: CLLocationCoordinate2D) -> NetworkResource
}
