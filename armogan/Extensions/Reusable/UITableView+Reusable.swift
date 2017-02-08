//
//  UITableView+Reusable.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 05..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type) where T: Reusable {
        register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, type: T.Type = T.self) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Cell with \(type.reuseIdentifier) identifier is not registered")
        }
        return cell
    }

    func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type) where T: Reusable {
        register(headerFooterViewType.self, forHeaderFooterViewReuseIdentifier: headerFooterViewType.reuseIdentifier)
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(type: T.Type = T.self) -> T? where T: Reusable {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: type.reuseIdentifier) as? T? else {
            fatalError("HeaderFooterView with \(type.reuseIdentifier) identifier is not registered")
        }
        return view
    }
}
