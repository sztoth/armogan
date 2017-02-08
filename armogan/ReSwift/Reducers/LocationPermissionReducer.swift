//
//  LocationPermissionReducer.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 04..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
import ReSwift

struct LocationPermissionReducer: Reducer {
    func handleAction(action: Action, state: AppState?) -> AppState {
        var weatherItems = state?.weatherItems ?? [WeatherItem]()

        switch action {
        case let action as UpdateLocationPermission:
            weatherItems = updateGPSBasedWeather(in: weatherItems, enabled: action.authorized)
        default:
            break
        }

        return AppState(currentLocation: state?.currentLocation, weatherItems: weatherItems)
    }
}

extension LocationPermissionReducer {
    func updateGPSBasedWeather(in items: [WeatherItem], enabled state: Bool) -> [WeatherItem] {
        guard let index = items.index(where: { $0.type == .GPSBased }) else { return items }

        var items = items
        var builder = WeatherItemBuilder(item: items[index])

        builder.state = state ? .idle : .disabled
        items[index] = WeatherItem(builder: builder)

        return items
    }
}
