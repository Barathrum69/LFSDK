//
//  UILabel+extion.swift
//  YMSDK
//
//  Created by wood on 20/3/21.
//

import UIKit

public extension UILabel {
    convenience init(text: String?, color: UIColor, size: CGFloat) {
        self.init()
        self.text = text
        self.textColor = color
        self.font = UIFont.systemFont(ofSize: size)
    }

    /// 直接填Localized.strings里面的key
    @IBInspectable var localizedString: String? {
        get {
            return text
        }
        set {
            if let newValue = newValue {
                text = newValue.localized()
            }
        }
    }
}
