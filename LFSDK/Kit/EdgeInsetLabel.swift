//
//  EdgeInsetLabel.swift
//  ymsports
//
//  Created by wood on 27/1/21.
//

import UIKit

@IBDesignable
public class EdgeInsetLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }

    override public func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}

public extension EdgeInsetLabel {
    @IBInspectable var leftInset: CGFloat {
        get { return textInsets.left }
        set { textInsets.left = newValue }
    }

    @IBInspectable var rightInset: CGFloat {
        get { return textInsets.right }
        set { textInsets.right = newValue }
    }

    @IBInspectable var topInset: CGFloat {
        get { return textInsets.top }
        set { textInsets.top = newValue }
    }

    @IBInspectable var bottomInset: CGFloat {
        get { return textInsets.bottom }
        set { textInsets.bottom = newValue }
    }
}
