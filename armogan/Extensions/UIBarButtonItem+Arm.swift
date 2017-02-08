
//
//  UIBarButtonItem+Arm.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 30..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(title: String?, style: UIBarButtonItemStyle) {
        self.init(title: title, style: style, target: nil, action: nil)
    }

    convenience init(barButtonSystemItem systemItem: UIBarButtonSystemItem) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
    }
}
