//
//  UITextField+extion.swift
//  YMSDK
//
//  Created by wood on 20/3/21.
//

import UIKit

private var placeholderColorHandle: UInt8 = 0 << 2

public extension UITextField {
    // swiftlint:disable override_in_extension
    override func awakeFromNib() {
        super.awakeFromNib()
        if let color = placeholderColor {
            attributedPlaceholder = NSAttributedString(string: placeholder?.localized() ?? "", attributes: [.foregroundColor: color])
        } else {
            placeholder = placeholder?.localized()
        }
    }

    @IBInspectable var placeholderColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &placeholderColorHandle) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &placeholderColorHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if let color = newValue, let placeholder = placeholder {
                attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: color])
            }
        }
    }
}
