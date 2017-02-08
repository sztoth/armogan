//
//  ForecastData.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

struct ForecastData {
    let summary: String
    let icon: String
    let temperature: Double
    let apparentTemperature: Double
    let precipProbability: Double
}

extension ForecastData {
    init?(dictionary: [String: Any]) {
        guard
            let summary = dictionary["summary"] as? String,
            let icon = dictionary["icon"] as? String,
            let temperature = dictionary["temperature"] as? Double,
            let apparentTemperature = dictionary["apparentTemperature"] as? Double,
            let precipProbability = dictionary["precipProbability"] as? Double
        else {
            return nil
        }

        self.init(
            summary: summary,
            icon: icon,
            temperature: temperature,
            apparentTemperature: apparentTemperature,
            precipProbability: precipProbability
        )
    }
}

extension ForecastData: Equatable {
    public static func ==(lhs: ForecastData, rhs: ForecastData) -> Bool {
        return
            lhs.summary == rhs.summary &&
            lhs.icon == rhs.icon &&
            lhs.temperature == rhs.temperature &&
            lhs.apparentTemperature == rhs.apparentTemperature &&
            lhs.precipProbability == rhs.precipProbability
    }
}
