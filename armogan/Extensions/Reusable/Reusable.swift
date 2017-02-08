//
//  Reusable.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 05..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
