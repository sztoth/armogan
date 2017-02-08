//
//  WeatherItemBuilder.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 05..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

struct WeatherItemBuilder {
    var id: UUID
    var type: WeatherItem.PositionType
    var state: WeatherItem.State
    var location: Location
    var forecast: Forecast?
    var updatedAt: Date?
}

extension WeatherItemBuilder {
    init(item: WeatherItem) {
        id = item.id
        type = item.type
        state = item.state
        location = item.location
        forecast = item.forecast
        updatedAt = item.updatedAt
    }
}

extension WeatherItem {
    init(builder: WeatherItemBuilder) {
        self.init(
            id: builder.id,
            type: builder.type,
            state: builder.state,
            location: builder.location,
            forecast: builder.forecast,
            updatedAt: builder.updatedAt
        )
    }
}
