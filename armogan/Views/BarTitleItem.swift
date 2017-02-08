//
//  BarTitleItem.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 30..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class BarTitleItem: UIBarButtonItem {
    var text: String? {
        get { return label.text }
        set {
            label.text = newValue
            label.sizeToFit()
        }
    }

    fileprivate let label: UILabel

    init(title: String?) {
        label =  UILabel(frame: .zero)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center

        super.init()

        if let title = title {
            text = title
        }

        customView = label
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Reactive where Base: BarTitleItem {
    var text: UIBindingObserver<Base, String?> {
        return UIBindingObserver(UIElement: self.base) { item, text in
            item.text = text
        }
    }
}
