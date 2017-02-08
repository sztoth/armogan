//
//  ListEditable.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 30..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import UIKit

protocol ListEditable: Listable {
    func canEditItem(at indexPath: IndexPath) -> Bool
    func editingStyleForItem(at indexPath: IndexPath) -> UITableViewCellEditingStyle
    func commit(_ editingStyle: UITableViewCellEditingStyle, forItemAt indexPath: IndexPath)
}

extension ListEditable {
    func canEditItem(at indexPath: IndexPath) -> Bool {
        return false
    }

    func editingStyleForItem(at indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }

    func commit(_ editingStyle: UITableViewCellEditingStyle, forItemAt indexPath: IndexPath) {}
}
