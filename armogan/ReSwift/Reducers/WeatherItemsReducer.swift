//
//  WeatherItemsReducer.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
import ReSwift

struct WeatherItemsReducer {
    static func reduce(items: [WeatherItem]?, location: Location?, action: Action) -> [WeatherItem] {
        var items = items ?? []

        switch action {
        case let action as UpdateForecast:
            items = updateWeather(with: action.id, in: items, withStatus: action.status, withLocation: location)
        case let action as WeatherItemLoading:
            items = setLoadingStateForWeather(with: action.id, in: items)
        case let action as AddWeather:
            items = add(weather: action.weather, to: items)
        case let action as DeleteWeather:
            items = deleteWeather(with: action.id, in: items)
        case let action as MoveWeather:
            items = moveWeather(with: action.id, to: action.index, in: items)
        case is UpdateCurrentLocation:
            items = updateGPSBasedWeatherStatus(in: items)
        default:
            break
        }

        return items
    }
}

extension WeatherItemsReducer {
    static func updateWeather(
        with id: UUID,
        in items: [WeatherItem],
        withStatus status: UpdateForecast.Status,
        withLocation location: Location?
    ) -> [WeatherItem] {
        guard let index = items.index(where: { $0.id == id }) else { return items }

        var items = items
        var builder = WeatherItemBuilder(item: items[index])

        switch status {
        case .updated(let forecast):
            builder.state = .updated
            builder.forecast = forecast
            builder.updatedAt = Date()

            if let location = location, builder.type == .GPSBased {
                builder.location = location
            }
        case .failed:
            builder.state = .failedToUpdate
        }

        items[index] = WeatherItem(builder: builder)

        return items
    }

    static func setLoadingStateForWeather(with id: UUID, in items: [WeatherItem]) -> [WeatherItem] {
        guard let index = items.index(where: { $0.id == id }) else { return items }

        var items = items
        var builder = WeatherItemBuilder(item: items[index])

        builder.state = .loading
        items[index] = WeatherItem(builder: builder)

        return items
    }

    static func add(weather: WeatherItem, to items: [WeatherItem]) -> [WeatherItem] {
        var items = items
        items.append(weather)

        return items
    }

    static func deleteWeather(with id: UUID, in items: [WeatherItem]) -> [WeatherItem] {
        guard let index = items.index(where: { $0.id == id }) else { return items }

        var items = items
        items.remove(at: index)

        return items
    }

    static func moveWeather(with id: UUID, to destination: Int, in items: [WeatherItem]) -> [WeatherItem] {
        guard let index = items.index(where: { $0.id == id }) else { return items }

        var items = items
        items.moveElemetAt(index, to: destination)

        return items
    }

    static func updateGPSBasedWeatherStatus(in items: [WeatherItem]) -> [WeatherItem] {
        guard let index = items.index(where: { $0.type == .GPSBased }) else { return items }

        var items = items
        var builder = WeatherItemBuilder(item: items[index])

        builder.state = .positionChanged
        items[index] = WeatherItem(builder: builder)

        return items
    }
}
