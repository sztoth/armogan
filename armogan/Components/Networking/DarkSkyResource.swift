//
//  DarkSkyResource.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 04..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import CoreLocation

struct DarkSkyResource: NetworkResource {
    let url: URL

    init(key: String, latitude: Double, longitude: Double) {
        url = URL(string: "https://api.darksky.net/forecast/\(key)/\(latitude),\(longitude)")!
    }

    func forecast(from dictionary: [String : Any]) -> Forecast? {
        return Forecast(dictionary: dictionary)
    }
}

class DarkSkyResourceFactory: NetworkResourceFactory {
    fileprivate let key = "f938869f394a1ec76ac0871cd0c00099"

    func resource(for coordinate: CLLocationCoordinate2D) -> NetworkResource {
        return DarkSkyResource(key: key, latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
