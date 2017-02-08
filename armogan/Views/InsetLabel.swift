//
//  InsetLabel.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 12..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import UIKit

class InsetLabel: UILabel {
    var insets = UIEdgeInsets.zero {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        numberOfLines = 2
        insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += (insets.left + insets.right)
        size.height += (insets.bottom + insets.top)

        return size
    }

    override func drawText(in rect: CGRect) {
        return super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        guard numberOfLines != 0 else {
            return super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        }

        var textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: 1)
        textRect.size.height *= CGFloat(numberOfLines)

        return textRect
    }
}
