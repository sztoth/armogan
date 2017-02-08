//
//  UpdateForecast.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
import ReSwift

struct UpdateForecast: Action {
    let id: UUID
    let status: Status
}

extension UpdateForecast {
    enum Status {
        case failed
        case updated(Forecast)
    }
}
