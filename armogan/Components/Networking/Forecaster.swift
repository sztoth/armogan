//
//  Forecaster.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 04..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import CoreLocation
import ReSwift

class Forecaster {
    fileprivate let queue: NetworkQueue
    fileprivate let resourceFactory: NetworkResourceFactory
    fileprivate let store: MainStore

    init(queue: NetworkQueue = NetworkQueue(), resourceFactory: NetworkResourceFactory, store: MainStore) {
        self.queue = queue
        self.resourceFactory = resourceFactory
        self.store = store

        self.store.subscribe(self)
    }

    deinit {
        store.unsubscribe(self)
    }

    func updateAllItems() {
        let items = store.state.weatherItems.filter { $0.state != .disabled }
        updateItems(items)
    }

    func updateFailedItems() {
        let items = store.state.weatherItems.filter { $0.state == .failedToUpdate }
        updateItems(items)
    }
}

extension Forecaster: StoreSubscriber {
    func newState(state: AppState) {
        let items = state.weatherItems.filter { $0.state == .idle || $0.state == .positionChanged }
        updateItems(items)
    }
}

fileprivate extension Forecaster {
    func updateItems(_ items: [WeatherItem]) {
        guard !items.isEmpty else { return }

        var parameters = items.map { ($0.id, $0.location.coordinate) }
        if let coordinate = store.state.currentLocation?.coordinate, let index = items.index(where: { $0.type == .GPSBased }) {
            let parameter = parameters[index]
            parameters[index] = (parameter.0, coordinate)
        }

        let operations = parameters.map { createOperation(with: $0) }
        queue.addOperations(operations)
    }

    func createOperation(with parameters:(UUID, CLLocationCoordinate2D)) -> NetworkOperation {
        let resource = resourceFactory.resource(for: parameters.1)
        let operation = NetworkOperation(id: parameters.0, resource: resource)

        operation.onStart = { [weak self] in
            self?.store.dispathOnMain(WeatherItemLoading(id: parameters.0))
        }

        operation.onCompleted = { [weak self] (forecast, error) in
            guard let `self` = self else { return }

            let status: UpdateForecast.Status = (forecast != nil) ? .updated(forecast!) : .failed
            self.store.dispathOnMain(UpdateForecast(id: parameters.0, status: status))
        }

        return operation
    }
}
