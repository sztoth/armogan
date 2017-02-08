//
//  CurrentLocationReducer.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 04..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
import ReSwift

struct CurrentLocationReducer {
    static func reduce(location: Location?, action: Action) -> Location? {
        var location = location

        switch action {
        case let action as UpdateCurrentLocation:
            location = action.location
        default:
            break
        }
        
        return location
    }
}
