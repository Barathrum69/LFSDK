//
//  UIButton+extion.swift
//  YMSDK
//
//  Created by wood on 20/3/21.
//

import UIKit

// Declare a global var to produce a unique address as the assoc object handle
private var disabledColorHandle: UInt8 = 0 << 1

public extension UIButton {
    convenience init(text: String?, color: UIColor?, size: CGFloat, _ state: UIControl.State = []) {
        self.init()
        self.setTitle(text, for: state)
        self.setTitleColor(color, for: state)
        self.titleLabel?.font = UIFont.systemFont(ofSize: size)
    }

    /// 设置按钮badge number
    /// - Parameters:
    ///   - number: 数字 100 => 99+
    func setBadge(number: NSInteger) {
        let rect = imageView?.frame ?? CGRect.zero
        let badge = UILabel(frame: CGRect(x: rect.origin.x + rect.size.width - 10, y: rect.origin.y - 10, width: 20, height: 20))
        badge.layer.cornerRadius = 10
        badge.clipsToBounds = true
        badge.backgroundColor = UIColor.hex(0xE6505F)
        badge.textColor = UIColor.white
        badge.font = UIFont.systemFont(ofSize: 10)
        badge.textAlignment = .center
        badge.text = number > 99 ? "99+" : "\(number)"
        addSubview(badge)
    }

    /// 直接填Localized.strings里面的key
    @IBInspectable var localizedString: String? {
        get {
            return currentTitle
        }
        set {
            if let newValue = newValue {
                setTitle(newValue.localized(), for: [])
            }
        }
    }

    // https://stackoverflow.com/questions/14523348/how-to-change-the-background-color-of-a-uibutton-while-its-highlighted
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(image(withColor: color), for: state)
    }

    @IBInspectable
    var disabledColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &disabledColorHandle) as? UIColor
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .disabled)
                objc_setAssociatedObject(self, &disabledColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .disabled)
                objc_setAssociatedObject(self, &disabledColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
