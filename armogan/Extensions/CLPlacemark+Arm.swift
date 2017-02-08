//
//  CLPlacemark+Arm.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 29..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import MapKit

extension CLPlacemark {
    var arm_formattedAddress: String? {
        guard
            let addressDict = addressDictionary,
            let addressArray = addressDict["FormattedAddressLines"] as? [String]
        else {
            return nil
        }

        var array = addressArray
        if let city = addressDict["State"] as? String, let lastIndex = addressArray.index(where: { $0.contains(city) }) {
            array = Array(addressArray[0..<lastIndex])
        }

        return array.joined(separator: ", ")
    }
}
