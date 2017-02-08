//
//  ForecastDetailViewModel.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import RxSwift
import UIKit

class ForecastDetailViewModel: BaseViewModel {
    fileprivate let _action = PublishSubject<ActionType>()
}

extension ForecastDetailViewModel: Actionable {
    typealias ActionType = Action

    var action: Observable<ActionType> {
        return _action.asObserver()
    }

    enum Action {
        case close(UIViewController)
    }
}
