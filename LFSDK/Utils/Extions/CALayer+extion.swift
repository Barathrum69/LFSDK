//
//  CALayer+extion.swift
//  YMSDK
//
//  Created by wood on 20/3/21.
//

import UIKit

private var shadowColorHandle: UInt8 = 0 << 3

public extension CALayer {
    /// xib中设置阴影颜色
    var shadowUIColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &shadowColorHandle) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &shadowColorHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
