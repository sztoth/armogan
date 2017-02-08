//
//  Actionable.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 11..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import RxSwift

protocol Actionable {
    associatedtype ActionType
    var action: Observable<ActionType> { get }
}
