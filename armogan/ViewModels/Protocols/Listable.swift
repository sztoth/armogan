//
//  Listable.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import UIKit

protocol Listable {
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> Any
    func title(for section: Int) -> String?
    func footer(for section: Int) -> String?
}

extension Listable {
    func numberOfSections() -> Int {
        return 1
    }

    func numberOfItems(in section: Int) -> Int {
        return 0
    }

    func title(for section: Int) -> String? {
        return nil
    }

    func footer(for section: Int) -> String? {
        return nil
    }
}
