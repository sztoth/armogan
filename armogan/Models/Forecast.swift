//
//  Forecast.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import UIKit

struct Forecast {
    let current: ForecastData
    let nextHoursSummary: String
    let nextHoursIcon: String
    let nextHours: [ForecastData]
}

extension Forecast {
    init?(dictionary: [String: Any]) {
        guard
            let currentlyDict = dictionary["currently"] as? [String: Any],
            let current = ForecastData(dictionary: currentlyDict),
            let hourlyDict = dictionary["hourly"] as? [String: Any],
            let hourlySummary = hourlyDict["summary"] as? String,
            let hourlyIcon = hourlyDict["icon"] as? String,
            let hourlyData = hourlyDict["data"] as? [[String: Any]]
        else {
            return nil
        }

        guard let hoursData = hourlyData.failingFlatMap({ ForecastData(dictionary: $0) }) else { return nil }

        self.init(current: current, nextHoursSummary: hourlySummary, nextHoursIcon: hourlyIcon, nextHours: hoursData)
    }
}

extension Forecast: Equatable {
    public static func ==(lhs: Forecast, rhs: Forecast) -> Bool {
        return
            lhs.current == rhs.current &&
            lhs.nextHoursSummary == rhs.nextHoursSummary &&
            lhs.nextHoursIcon == rhs.nextHoursIcon &&
            lhs.nextHours == rhs.nextHours
    }
}
