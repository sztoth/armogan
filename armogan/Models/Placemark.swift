//
//  Placemark.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 07..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import CoreLocation

// I had to make the CLPlacemark optional and I did not want ot mess up the Location struct
struct Placemark {
    let placemark: CLPlacemark?

    init(_ placemark: CLPlacemark? = nil) {
        self.placemark = placemark
    }
}

extension Placemark: Equatable {
    public static func ==(lhs: Placemark, rhs: Placemark) -> Bool {
        return lhs.placemark == rhs.placemark
    }
}
