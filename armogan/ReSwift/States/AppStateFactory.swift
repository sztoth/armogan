//
//  AppStateFactory.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 05..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

struct AppStateFactory {
    static func defaultState() -> AppState {
        let location = Location()
        let weatherItem = WeatherItem(location: location, type: .GPSBased, state: .disabled)

        return AppState(currentLocation: nil, weatherItems: [weatherItem])
    }
}

