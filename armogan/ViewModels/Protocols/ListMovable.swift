//
//  ListMovable.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 30..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

protocol ListMovable: Listable {
    func canMoveItem(at indexPath: IndexPath) -> Bool
    func targetIndexPathForItem(movingFrom source: IndexPath, to destination: IndexPath) -> IndexPath
    func moveItem(from source: IndexPath, to destination: IndexPath)
}

extension ListMovable {
    func canMoveItem(at indexPath: IndexPath) -> Bool {
        return false
    }

    func moveItem(from source: IndexPath, to destination: IndexPath) {}
}
