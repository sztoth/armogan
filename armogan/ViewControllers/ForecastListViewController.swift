//
//  ForecastListViewController.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import UIKit
import RxSwift

class ForecastListViewController: UIViewController {
    fileprivate(set) var tableView: UITableView!

    fileprivate let disposeBag = DisposeBag()

    fileprivate let viewModel: ForecastListViewModelType

    fileprivate var addNewButton: UIBarButtonItem!
    fileprivate var refreshButton: UIBarButtonItem!
    fileprivate var toggleEditButton: UIBarButtonItem!
    fileprivate var statusUpdate: BarTitleItem!

    fileprivate var selectedIndexPath: IndexPath?

    init(viewModel: ForecastListViewModelType) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
        setupBindings()
        setupTableView()
    }
}

extension ForecastListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return viewModel.listHandler.editingStyleForItem(at: indexPath)
    }

    func tableView(
        _ tableView: UITableView,
        targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
        toProposedIndexPath proposedDestinationIndexPath: IndexPath
    ) -> IndexPath {
        return viewModel.listHandler.targetIndexPathForItem(movingFrom: sourceIndexPath, to: proposedDestinationIndexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        viewModel.inputs.showDetailedForecast()
        //tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ForecastListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.listHandler.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listHandler.numberOfItems(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ForecastListCell = tableView.dequeueReusableCell(for: indexPath)
        let cellViewModel = viewModel.listHandler.item(at: indexPath)

        cell.viewModel = cellViewModel as? ForecastListCellViewModel

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return viewModel.listHandler.canEditItem(at: indexPath)
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return viewModel.listHandler.canMoveItem(at: indexPath)
    }

    func tableView(
        _ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        viewModel.listHandler.moveItem(from: sourceIndexPath, to: destinationIndexPath)
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        viewModel.listHandler.commit(editingStyle, forItemAt: indexPath)
    }
}

fileprivate extension ForecastListViewController {
    func setupButtons() {
        addNewButton = UIBarButtonItem(barButtonSystemItem: .add)
        addNewButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.handleAddNewLocationTap()
            })
            .addDisposableTo(disposeBag)

        navigationItem.rightBarButtonItem = addNewButton

        refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh)
        refreshButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.handleRefreshTap()
            })
            .addDisposableTo(disposeBag)

        toggleEditButton = UIBarButtonItem(title: nil, style: .plain)
        toggleEditButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.handleToggleEditTap()
            })
            .addDisposableTo(disposeBag)

        statusUpdate = BarTitleItem(title: nil)

        let fixSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace)
        fixSpace.width = 10.0

        toolbarItems = [
            statusUpdate,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace),
            toggleEditButton,
            BarTitleItem(title: "|"),
            refreshButton
        ]

        navigationController?.isToolbarHidden = false
    }

    func setupBindings() {
        viewModel.outputs.reloadList
            .drive(onNext: { [unowned self] in
                self.reloadList()
            })
            .addDisposableTo(disposeBag)

        let editing = viewModel.outputs.editing

        editing
            .map { [unowned self] in
                self.barButtonParameters($0)
            }
            .drive(onNext: { [unowned self] in
                self.updateBarButtonWithParameters($0)
            })
            .addDisposableTo(disposeBag)

        editing
            .drive(onNext: { [unowned self] in
                self.updateTableViewState($0)
            })
            .addDisposableTo(disposeBag)

        let invertedEditing = editing.map { !$0 }

        invertedEditing
            .drive(addNewButton.rx.isEnabled)
            .addDisposableTo(disposeBag)

        invertedEditing
            .drive(refreshButton.rx.isEnabled)
            .addDisposableTo(disposeBag)

        viewModel.outputs.status
            .map { [unowned self] in
                self.titleForStatus($0)
            }
            .drive(statusUpdate.rx.text)
            .addDisposableTo(disposeBag)
    }

    func setupTableView() {
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [unowned self] in
                self.updateAll()
            })
            .addDisposableTo(disposeBag)

        viewModel.outputs.status
            .map { $0 == .updating }
            .drive(refreshControl.rx.refreshing)
            .addDisposableTo(disposeBag)

        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }

        tableView.register(cellType: ForecastListCell.self)

        tableView.rowHeight = 80.0
        tableView.dataSource = self
        tableView.delegate = self
    }
}

fileprivate extension ForecastListViewController {
    func handleAddNewLocationTap() {
        viewModel.inputs.addNewLocation()
    }

    func handleRefreshTap() {
        viewModel.inputs.updateWeathers()
    }

    func handleToggleEditTap() {
        viewModel.inputs.toggleEditMode()
    }

    func reloadList() {
        tableView.reloadData()
    }

    func barButtonParameters(_ value: Bool) -> (String, UIBarButtonItemStyle) {
        if value {
            return ("Done", .done)
        }
        return ("Edit", .plain)
    }

    func updateBarButtonWithParameters(_ parameters: (String, UIBarButtonItemStyle)) {
        toggleEditButton.title = parameters.0
        toggleEditButton.style = parameters.1
    }

    func updateTableViewState(_ editing: Bool) {
        tableView.setEditing(editing, animated: true)
    }

    func titleForStatus(_ status: ForecastListViewModelTypeStatus) -> String? {
        switch status {
        case .updating: return "Updating"
        case .updated: return "Up-to-date"
        case .someFailed: return "Some failed to update"
        default: return nil
        }
    }

    func updateAll() {
        viewModel.inputs.updateWeathers()
    }
}
