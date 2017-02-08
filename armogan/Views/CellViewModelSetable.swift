//
//  CellViewModelSetable.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import UIKit

protocol CellViewModelSetable {
    associatedtype ViewModelType
    var viewModel: ViewModelType? { get set }
}
