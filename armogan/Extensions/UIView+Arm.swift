//
//  UIView+Arm.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 26..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import UIKit

extension UIView {
    func arm_set(cornerRadius toRadius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: toRadius).cgPath

        layer.mask = maskLayer
    }

    func arm_resizableSnapshotViewWithZeroInsets(from rect: CGRect, afterScreenUpdates afterUpdates: Bool) -> UIView? {
        return resizableSnapshotView(from: rect, afterScreenUpdates: afterUpdates, withCapInsets: .zero)
    }
}
