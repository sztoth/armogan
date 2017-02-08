//
//  ObservableType+Arm.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 30..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        return map { _ in return }
    }
}
