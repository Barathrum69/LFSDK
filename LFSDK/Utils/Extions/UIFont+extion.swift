//
//  UIFont+extion.swift
//  YMSDK
//
//  Created by SDS on 2021/3/27.
//

import UIKit

public enum FontName: String {
    /// 苹方-简 常规体
    case pingFangSCRegular = "PingFangSC-Regular"
    /// 苹方-简 极细体
    case pingFangSCUltralight = "PingFangSC-Ultralight"
    /// 苹方-简 细体
    case pingFangSCLight = "PingFangSC-Light"
    /// 苹方-简 纤细体
    case pingFangSCThin = "PingFangSC-Thin"
    /// 苹方-简 中黑体
    case pingFangSCMedium = "PingFangSC-Medium"
    /// 苹方-简 中粗体
    case pingFangSCSemibold = "PingFangSC-Semibold"
    /// HelveticaNeue 常规体
    case helveticaNeue = "HelveticaNeue"
    /// HelveticaNeue 中黑体
    case helveticaNeueMedium = "HelveticaNeue-Medium"
}

public extension UIFont {
    /// 快捷设置苹方字体或Helvetica字体
    /// - Parameters:
    ///   - name: 字体名称
    ///   - size: 大小
    /// - Returns: UIFont
    static func font(custom name: FontName, _ size: CGFloat = 14) -> UIFont {
        return UIFont(name: name.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
