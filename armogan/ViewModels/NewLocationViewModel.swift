//
//  NewLocationViewModel.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import MapKit
import ReSwift
import RxCocoa
import RxSwift
import UIKit

protocol NewLocationViewModelInputs {
    func close()
    func saveSelectedLocation()
    func mapInteractionStarted()
    func mapInteractionStoppedAtCoordinate(_ coordinate: CLLocationCoordinate2D)
}

protocol NewLocationViewModelOutputs {
    var canSave: Driver<Bool> { get }
    var result: Driver<String> { get }
}

protocol NewLocationViewModelType {
    var inputs: NewLocationViewModelInputs { get }
    var outputs: NewLocationViewModelOutputs { get }
}

class NewLocationViewModel: BaseViewModel, NewLocationViewModelInputs, NewLocationViewModelOutputs {
    var canSave: Driver<Bool> {
        return _canSave.asDriver(onErrorJustReturn: false)
    }
    var result: Driver<String> {
        return _result.asDriver(onErrorJustReturn: "")
    }

    fileprivate let _action = PublishSubject<ActionType>()
    fileprivate let _result = PublishSubject<String>()
    fileprivate let _canSave = PublishSubject<Bool>()
    fileprivate let reverseGeocode = PublishSubject<CLLocationCoordinate2D>()
    fileprivate let status = Variable<Status>(.idle)

    fileprivate let store: MainStore
    fileprivate let locationTranslator: LocationToAddressTranslator

    fileprivate var location: CLLocationCoordinate2D?
    fileprivate var placemark: CLPlacemark?

    init(store: MainStore, locationTranslator: LocationToAddressTranslator) {
        self.store = store
        self.locationTranslator = locationTranslator

        super.init()

        setupBindings()
    }

    func close() {
        _action.onNext(.close)
    }

    func saveSelectedLocation() {
        guard let location = location, let placemark = placemark else { return }

        let loc = Location(coordinate: location, placemark: placemark)
        let weatherItem = WeatherItem(location: loc)
        let addAction = AddWeather(weather: weatherItem)
        store.dispatch(addAction)

        close()
    }

    func mapInteractionStarted() {
        status.value = .waiting
    }

    func mapInteractionStoppedAtCoordinate(_ coordinate: CLLocationCoordinate2D) {
        reverseGeocode.onNext(coordinate)
    }
}

extension NewLocationViewModel: NewLocationViewModelType {
    var inputs: NewLocationViewModelInputs { return self }
    var outputs: NewLocationViewModelOutputs { return self }
}

extension NewLocationViewModel: Actionable {
    typealias ActionType = Action

    var action: Observable<ActionType> {
        return _action.asObserver()
    }

    enum Action {
        case close
    }
}

fileprivate extension NewLocationViewModel {
    func setupBindings() {
        let statusObservable = status.asObservable()

        statusObservable
            .map { [unowned self] in
                self.stringFromStatus($0)
            }
            .bindTo(_result)
            .addDisposableTo(disposeBag)

        statusObservable
            .filter { [unowned self] in
                self.statusRequiresReset($0)
            }
            .mapToVoid()
            .subscribe(onNext: { [unowned self] in
                self.resetValues()
            })
            .addDisposableTo(disposeBag)

        statusObservable
            .map { $0 == .loaded }
            .bindTo(_canSave)
            .addDisposableTo(disposeBag)

        reverseGeocode
            .subscribe(onNext: { [unowned self] in
                self.saveCoordinate($0)
            })
            .addDisposableTo(disposeBag)

        reverseGeocode
            .throttle(2.0, latest: true, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest { [weak self] in
                self?.locationTranslator.placemark(with: $0) ?? Observable.empty()
            }
            .subscribe(
                onNext: { [weak self] in
                    self?.savePlacemark($0)
                },
                onError: { [weak self] in
                    self?.handleError($0)
                }
            )
            .addDisposableTo(disposeBag)
    }
}

fileprivate extension NewLocationViewModel {
    func stringFromStatus(_ status: Status) -> String {
        switch status {
        case .idle: return "Idle"
        case .waiting: return "Waiting"
        case .loading: return "Loading"
        case .loaded: return placemark?.arm_formattedAddress ?? "Failed"
        case .failed: return "Failed"
        }
    }

    func statusRequiresReset(_ status: Status) -> Bool {
        return status == .waiting || status == .failed
    }

    func resetValues() {
        location = nil
        placemark = nil
    }

    func saveCoordinate(_ coordinate: CLLocationCoordinate2D) {
        location = coordinate
        status.value = .loading
    }

    func savePlacemark(_ placemark: CLPlacemark) {
        self.placemark = placemark
        status.value = .loaded
    }

    func handleError(_ error: Error) {
        status.value = .failed
    }
}

fileprivate extension NewLocationViewModel {
    enum Status {
        case idle
        case waiting
        case loading
        case loaded
        case failed
    }
}
