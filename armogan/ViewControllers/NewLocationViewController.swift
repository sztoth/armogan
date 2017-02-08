//
//  NewLocationViewController.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import MapKit
import RxCocoa
import RxSwift

class NewLocationViewController: UIViewController {
    fileprivate(set) var mapView: MKMapView!
    fileprivate(set) var closeButton: UIButton!
    fileprivate(set) var locationLabel: InsetLabel!
    fileprivate(set) var locationIndicator: UIView!
    fileprivate(set) var locateMeButton: UIButton!
    fileprivate(set) var saveButton: UIBarButtonItem!

    fileprivate let disposeBag = DisposeBag()
    fileprivate let viewModel: NewLocationViewModelType

    init(viewModel: NewLocationViewModelType) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view.backgroundColor = UIColor.green

        mapView = MKMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        view.addSubview(mapView)

        locationIndicator = UIView(frame: .zero)
        locationIndicator.translatesAutoresizingMaskIntoConstraints = false
        locationIndicator.backgroundColor = UIColor.green
        locationIndicator.isUserInteractionEnabled = false
        view.addSubview(locationIndicator)

        let indicatorRatio = locationIndicator.widthAnchor.constraint(equalTo: locationIndicator.heightAnchor)
        let indicatorWidth = locationIndicator.widthAnchor.constraint(equalToConstant: 20.0)
        locationIndicator.addConstraints([indicatorRatio, indicatorWidth])

        let indicatorCenterX = locationIndicator.centerXAnchor.constraint(equalTo: mapView.centerXAnchor)
        let indicatorCenterY = locationIndicator.centerYAnchor.constraint(equalTo: mapView.centerYAnchor)

        locateMeButton = UIButton(type: .roundedRect)
        locateMeButton.translatesAutoresizingMaskIntoConstraints = false
        locateMeButton.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 30.0)
        locateMeButton.setTitle("Locate me", for: .normal)
        view.addSubview(locateMeButton)

        let locateTop = locateMeButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20.0)
        let locateLeading = locateMeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0)

        locationLabel = InsetLabel(frame: .zero)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.backgroundColor = UIColor.white
        view.addSubview(locationLabel)

        let locationLeading = locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0)
        let locationTrailing = locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0)
        let locationBottom = locationLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30.0)
        view.addConstraints([locateTop, locateLeading, indicatorCenterX, indicatorCenterY, locationLeading, locationTrailing, locationBottom])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
        setupMapBindings()
        setupViewModelBindings()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let navController = navigationController, navController.isBeingDismissed {
            applyMapViewMemoryHotfix()
        }
    }
}

fileprivate extension NewLocationViewController {
    func setupButtons() {
        let closeButton = UIBarButtonItem(title: "Close", style: .plain)
        closeButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.handleCloseTap()
            })
            .addDisposableTo(disposeBag)

        navigationItem.leftBarButtonItem = closeButton

        saveButton = UIBarButtonItem(title: "Save", style: .done)
        saveButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.handleSaveTap()
            })
            .addDisposableTo(disposeBag)

        navigationItem.rightBarButtonItem = saveButton

        locateMeButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.handleLocateMeTap()
            })
            .addDisposableTo(disposeBag)
    }
}

fileprivate extension NewLocationViewController {
    func setupMapBindings() {
        mapView.rx.regionWillChangeAnimated
            .mapToVoid()
            .subscribe(onNext: { [unowned self] in
                self.prepareForMapInteraction()
            })
            .addDisposableTo(disposeBag)

        mapView.rx.regionDidChangeAnimated
            .mapToVoid()
            .subscribe(onNext: { [unowned self] in
                self.handleMapInteraction()
            })
            .addDisposableTo(disposeBag)

        mapView.rx.didUpdateUserLocation
            .single()
            .mapToVoid()
            .subscribe(onNext: { [weak self] in
                self?.jumpToUserLocation()
            })
            .addDisposableTo(disposeBag)
    }

    func setupViewModelBindings() {
        viewModel.outputs.canSave
            .drive(saveButton.rx.isEnabled)
            .addDisposableTo(disposeBag)

        viewModel.outputs.result
            .drive(locationLabel.rx.text)
            .addDisposableTo(disposeBag)
    }
}

fileprivate extension NewLocationViewController {
    func applyMapViewMemoryHotfix() {
        mapView.mapType = .hybrid
        mapView.mapType = .standard
    }
}

fileprivate extension NewLocationViewController {
    func handleCloseTap() {
        viewModel.inputs.close()
    }

    func handleSaveTap() {
        viewModel.inputs.saveSelectedLocation()
    }

    func handleLocateMeTap() {
        jumpToUserLocation()
    }

    func prepareForMapInteraction() {
        locationIndicator.backgroundColor = UIColor.brown
        viewModel.inputs.mapInteractionStarted()
    }

    func handleMapInteraction() {
        locationIndicator.backgroundColor = UIColor.green

        let coordinate = mapView.convert(locationIndicator.center, toCoordinateFrom: locationIndicator.superview)
        viewModel.inputs.mapInteractionStoppedAtCoordinate(coordinate)
    }

    func jumpToUserLocation() {
        mapView.arm_zoomToUserLocationAnimated(true)
    }
}
