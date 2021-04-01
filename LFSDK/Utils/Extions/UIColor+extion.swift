//
//  UIColor+extion.swift
//  YMSDK
//
//  Created by wood on 20/3/21.
//

import UIKit

public extension UIColor {
    /// 获取颜色 .hex(0xffffff)
    ///
    /// - Parameters:
    ///   - value: 二进制value
    ///   - alpha: 透明度
    /// - Returns: UIColor
    static func hex(_ value: UInt, _ alpha: CGFloat = 1.0) -> UIColor {
        let red = (CGFloat)((value & 0xFF0000) >> 16) / 255.0
        let green = (CGFloat)((value & 0xFF00) >> 8) / 255.0
        let blue = (CGFloat)(value & 0xFF) / 255.0
        return .init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// 获取颜色 .hex("#ffffff")/.hex("#ffffff00")/.hex("ffffff")/.hex("ffffff00")
    /// - Parameters:
    ///   - hexStr: 16进制字符串
    ///   - alpha: 透明度
    /// - Returns: UIcolor
    static func hex(_ hexStr: String, _ alpha: CGFloat = 1.0) -> UIColor {
        var hex: String = hexStr.trim()
        if hex.hasPrefix("#") {
            hex = String(hex.suffix(from: hex.index(hex.startIndex, offsetBy: 1)))
        }
        if hex.count > 8 {
            hex = String(hex.prefix(8))
        }
        switch hex.count {
        case 6:
            if let hexNumber = UInt(hex, radix: 16) {
                return UIColor.hex(hexNumber, alpha)
            }
        case 8:
            if let hexNumber = UInt(String(hex.prefix(6)), radix: 16),
               let validAlpha = UInt(String(hex.suffix(2)), radix: 16) {
                return UIColor.hex(hexNumber, CGFloat(validAlpha) / 255.0)
            }
        default:
            return .clear
        }
        return .clear
    }
}
