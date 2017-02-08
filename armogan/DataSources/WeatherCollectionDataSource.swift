//
//  WeatherCollectionDataSource.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 17..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import ReSwift
import RxSwift

class WeatherCollectionDataSource: DataSource {
    typealias Data = [WeatherItem]

    var changed: Observable<([WeatherItem], [WeatherItem])> {
        return _changed.asObserver()
    }

    fileprivate(set) var data = [WeatherItem]() {
        didSet {
            _changed.onNext((oldValue, data))
        }
    }

    private let _changed = PublishSubject<([WeatherItem], [WeatherItem])>()
    private let store: MainStore

    init(store: MainStore) {
        self.store = store
        self.store.subscribe(self) { $0.weatherItems }
    }

    deinit {
        store.unsubscribe(self)
    }

    func delete(itemAt index: Int) {
        let item = data[index]
        let action = DeleteWeather(id: item.id)
        store.dispathOnMain(action)
    }

    func move(itemFrom source: Int, to destination: Int) {
        let item = data[source]
        let action = MoveWeather(id: item.id, index: destination)
        store.dispathOnMain(action)
    }
}

extension WeatherCollectionDataSource: StoreSubscriber {
    func newState(state: [WeatherItem]) {
        data = state
    }
}
