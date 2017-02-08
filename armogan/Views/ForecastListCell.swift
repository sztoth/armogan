//
//  ForecastListCell.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 05..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import UIKit

class ForecastListCell: UITableViewCell, CellViewModelSetable {
    typealias ViewModelType = ForecastListCellViewModel

    var viewModel: ViewModelType? {
        didSet {
            update(with: viewModel)
        }
    }

    fileprivate var miniView: MiniForecastView!
    fileprivate var label: UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        viewModel = nil
    }
}

fileprivate extension ForecastListCell {
    func setupViews() {
        miniView = MiniForecastView(frame: .zero)
        miniView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(miniView)
        miniView.heightAnchor.constraint(equalTo: miniView.widthAnchor).isActive = true

        let miniTop = miniView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0)
        let miniLeft = miniView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10.0)
        let miniBottom = miniView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0)
        contentView.addConstraints([miniTop, miniLeft, miniBottom])

        label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        contentView.addSubview(label)
        let labelTop = label.topAnchor.constraint(equalTo: miniView.topAnchor)
        let labelLeft = label.leftAnchor.constraint(equalTo: miniView.rightAnchor, constant: 10.0)
        let labelBottom = label.bottomAnchor.constraint(equalTo: miniView.bottomAnchor)
        let labelRight = label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10.0)
        contentView.addConstraints([labelTop, labelLeft, labelBottom, labelRight])
    }

    func update(with viewModel: ViewModelType?) {
        miniView.temperature = viewModel?.temperature
        label.text = viewModel?.location
    }
}

extension ForecastListCell: Reusable {}
