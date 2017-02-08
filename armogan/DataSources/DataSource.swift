//
//  DataSource.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 17..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import RxSwift

protocol DataSource {
    associatedtype Data
    var data: Data { get }
    var changed: Observable<(Data, Data)> { get }
}
