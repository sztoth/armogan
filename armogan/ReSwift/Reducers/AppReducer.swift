//
//  AppReducer.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import ReSwift

struct AppReducer: Reducer {
    func handleAction(action: Action, state: AppState?) -> AppState {
        return AppState(
            currentLocation: CurrentLocationReducer.reduce(location: state?.currentLocation, action: action),
            weatherItems: WeatherItemsReducer.reduce(items: state?.weatherItems, location: state?.currentLocation, action: action)
        )
    }
}
