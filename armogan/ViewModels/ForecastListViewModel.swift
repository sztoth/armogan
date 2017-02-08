//
//  ForecastListViewModel.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import ReSwift
import RxCocoa
import RxSwift
import UIKit

enum ForecastListViewModelTypeStatus {
    case idle
    case updating
    case updated
    case someFailed
}

protocol ForecastListViewModelInputs {
    func addNewLocation()
    func showDetailedForecast()
    func toggleEditMode()
    func updateWeathers()
}

protocol ForecastListViewModelOutputs {
    var reloadList: Driver<Void> { get }
    var editing: Driver<Bool> { get }
    var status: Driver<ForecastListViewModelTypeStatus> { get }
}

protocol ForecastListViewModelType {
    var inputs: ForecastListViewModelInputs { get }
    var outputs: ForecastListViewModelOutputs { get }
    var listHandler: ListEditable & ListMovable { get }
}

class ForecastListViewModel: BaseViewModel, ForecastListViewModelInputs, ForecastListViewModelOutputs {
    var reloadList: Driver<Void> {
        return _reloadList.asDriver(onErrorJustReturn: ())
    }
    var editing: Driver<Bool> {
        return _editing.asDriver()
    }
    var status: Driver<ForecastListViewModelTypeStatus> {
        return _status.asDriver()
    }

    fileprivate let _reloadList = PublishSubject<Void>()
    fileprivate let _editing = Variable<Bool>(false)
    fileprivate let _status = Variable<ForecastListViewModelTypeStatus>(.idle)
    fileprivate let _action = PublishSubject<ActionType>()

    fileprivate let dataSource: WeatherCollectionDataSource
    fileprivate let forecaster: Forecaster

    init(dataSource: WeatherCollectionDataSource, forecaster: Forecaster) {
        self.dataSource = dataSource
        self.forecaster = forecaster

        super.init()

        setupBindings()
    }

    func addNewLocation() {
        _action.onNext(.addNewLocation)
    }

    func showDetailedForecast() {
        _action.onNext(.showDetails)
    }

    func toggleEditMode() {
        _editing.value = !_editing.value
    }

    func updateWeathers() {
        _status.value = .updating

        forecaster.updateAllItems()
    }
}

extension ForecastListViewModel: ForecastListViewModelType {
    var inputs: ForecastListViewModelInputs { return self }
    var outputs: ForecastListViewModelOutputs { return self }
    var listHandler: ListEditable & ListMovable { return self }
}

extension ForecastListViewModel: Actionable {
    typealias ActionType = Action

    var action: Observable<ActionType> {
        return _action.asObserver()
    }

    enum Action {
        case addNewLocation
        case showDetails
    }
}

extension ForecastListViewModel: Listable {
    func numberOfItems(in section: Int) -> Int {
        return dataSource.data.count
    }

    func item(at indexPath: IndexPath) -> Any {
        let item = dataSource.data[indexPath.row]
        return ForecastListCellViewModel(weatherItem: item)
    }
}

extension ForecastListViewModel: ListEditable {
    func canEditItem(at indexPath: IndexPath) -> Bool {
        let item = dataSource.data[indexPath.row]
        return item.type == .fix
    }

    func editingStyleForItem(at indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    func commit(_ editingStyle: UITableViewCellEditingStyle, forItemAt indexPath: IndexPath) {
        if editingStyleForItem(at: indexPath) == .delete {
            dataSource.delete(itemAt: indexPath.row)
        }
    }
}

extension ForecastListViewModel: ListMovable {
    func canMoveItem(at indexPath: IndexPath) -> Bool {
        let item = dataSource.data[indexPath.row]
        return item.type == .fix
    }

    func targetIndexPathForItem(movingFrom source: IndexPath, to destination: IndexPath) -> IndexPath {
        if let index = dataSource.data.index(where: { $0.type == .GPSBased }), destination.row <= index {
            return IndexPath(row: index + 1, section: destination.section)
        }
        return destination
    }

    func moveItem(from source: IndexPath, to destination: IndexPath) {
        dataSource.move(itemFrom: source.row, to: destination.row)
    }
}

fileprivate extension ForecastListViewModel {
    func setupBindings() {
        let changed = dataSource.changed

        changed
            .mapToVoid()
            .bindTo(_reloadList)
            .addDisposableTo(disposeBag)

        changed
            .map { $0.1 }
            .map { [unowned self] in
                self.statusFromItems($0)
            }
            .bindTo(_status)
            .addDisposableTo(disposeBag)
    }
}

fileprivate extension ForecastListViewModel {
    func statusFromItems(_ items: [WeatherItem]) -> ForecastListViewModelTypeStatus {
        if let _ = items.index(where: { $0.state == .loading }) {
            return .updating
        }

        if let _ = items.index(where: { $0.state == .failedToUpdate }) {
            return .someFailed
        }

        return .updated
    }
}
