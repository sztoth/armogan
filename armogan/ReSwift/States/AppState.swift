//
//  AppState.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import ReSwift

struct AppState: StateType {
    let currentLocation: Location?
    let weatherItems: [WeatherItem]
}

extension AppState {
    init() {
        self.init(currentLocation: nil, weatherItems: [])
    }
}
