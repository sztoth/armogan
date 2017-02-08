//
//  WeatherItem.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import UIKit

struct WeatherItem {
    let id: UUID
    let type: PositionType
    let state: State
    let location: Location
    let forecast: Forecast?
    let updatedAt: Date?
}

extension WeatherItem {
    init(location: Location, type: PositionType = .fix, state: State = .idle) {
        self.init(id: UUID(), type: type, state: state, location: location, forecast: nil, updatedAt: nil)
    }
}

extension WeatherItem: Equatable {
    static func ==(lhs: WeatherItem, rhs: WeatherItem) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.type == rhs.type &&
            lhs.state == rhs.state &&
            lhs.location == rhs.location &&
            lhs.forecast == rhs.forecast &&
            lhs.updatedAt == rhs.updatedAt
    }
}

extension WeatherItem {
    enum PositionType {
        case GPSBased
        case fix
    }

    enum State {
        case idle
        case positionChanged
        case loading
        case updated
        case disabled
        case failedToUpdate
    }
}
