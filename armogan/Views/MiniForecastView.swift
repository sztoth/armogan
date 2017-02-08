//
//  MiniForecastView.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 26..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import UIKit

class MiniForecastView: UIView {
    var temperature: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    fileprivate let circle: UIView
    fileprivate let label: UILabel

    override init(frame: CGRect) {
        circle = UIView(frame: .zero)
        label = UILabel(frame: .zero)

        super.init(frame: frame)

        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.backgroundColor = UIColor.black
        addSubview(circle)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .center
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let cornerRadius = floor(min(bounds.width, bounds.height) / 2.0)
        let width = 2 * cornerRadius
        let frame = CGRect(x: 0.0, y: 0.0, width: width, height: width)

        circle.frame = frame
        circle.arm_set(cornerRadius: cornerRadius)

        label.frame = frame
    }
}
