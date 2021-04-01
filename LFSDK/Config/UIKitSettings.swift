//
//  UIKitSettings.swift
//  ymsports
//
//  Created by wood on 3/3/21.
//

import UIKit

/// 关于UI的配置用来控制主题
public struct UIKitSettings {
    /// YMSDK.framework bundle
    public static var bundle = Bundle(for: Localized.self)

    /// 主题颜色
    public static var primaryColor = UIColor.hex(0x333333)
    public static var foregroundColor: UIColor = #colorLiteral(red: 0.2117647059, green: 0.568627451, blue: 0.9019607843, alpha: 1)
    public static var backgroundColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

    /// color 333333
    public static var textColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { $0.userInterfaceStyle == .dark ? .lightGray : .hex(0x333333) }
        } else {
            return .hex(0x333333)
        }
    }
}
