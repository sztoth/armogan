//
//  ForecastListCellViewModel.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

struct ForecastListCellViewModel {
    let location: String
    let temperature: String

    init(weatherItem: WeatherItem) {
        location = weatherItem.location.placemark.placemark?.arm_formattedAddress ?? "?"

        let temp = weatherItem.forecast?.current.apparentTemperature
        temperature = temp == nil ? "?" : "\(temp!)"
    }
}
