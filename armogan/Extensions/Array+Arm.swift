//
//  Array+Arm.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 30..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

extension Array {
    mutating func moveElemetAt(_ index: Int, to destination: Int) {
        guard index != destination else { return }

        let elementToMove = remove(at: index)

        if indices ~= destination {
            insert(elementToMove, at: destination)
        }
        else {
            append(elementToMove)
        }
    }
}
