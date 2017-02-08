//
//  Store.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 04..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
import ReSwift

typealias MainStore = Store<AppState>

extension Store {
    func dispathOnMain(_ action: Action) {
        DispatchQueue.main.async {
            self.dispatch(action)
        }
    }
}
