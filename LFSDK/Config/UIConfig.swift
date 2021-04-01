//
//  UIConfig.swift
//  ymsports
//
//  Created by wood on 25/1/21.
//

import UIKit

private func isiPhoneXSeries() -> Bool {
    guard #available(iOS 11.0, *) else { return false }
    return UIApplication.shared.windows[0].safeAreaInsets.bottom > 0
}

public extension UIDevice {
    /// 屏幕宽
    static let width = UIScreen.main.bounds.width
    /// 屏幕高
    static let height = UIScreen.main.bounds.height
    /// 是否为刘海屏
    static let iPhoneXSeries = isiPhoneXSeries()
    /// 导航栏+状态栏高度
    static let navBarHeight: CGFloat = (iPhoneXSeries ? 88 : 64)
    /// TabBar高度
    static let tabBarHeight: CGFloat = (iPhoneXSeries ? 83 : 49)
    /// 状态栏高度
    static let statusBarHeight: CGFloat = (iPhoneXSeries ? 44 : 20)
    /// 边缘间隙
    static let kMargin: CGFloat = 14
    /// Tabbar底部间隙
    static let kTabbarMargin: CGFloat = (iPhoneXSeries ? 34 : 0)
}

/// 占位图 方形
public let placeholderImage = UIImage(named: "image_default", in: Localized.bundle, compatibleWith: nil)
/// 占位图 矩形
public let placeholderImageRec = UIImage(named: "image_default_rec", in: Localized.bundle, compatibleWith: nil)
/// 占位图 用户头像
public let placeholderUserIcon = UIImage(named: "user_avatar_not_login", in: Localized.bundle, compatibleWith: nil)

public let appLogoUrl = "http://kok.com/images/app/icon.png"

/// 导航栏样式
///
/// - default: 默认由NavigationController控制
/// - dark: 暗色-深蓝色142341
/// - light: 亮色-白色
public enum NavigationBarStyle: Int {
    /// 默认由NavigationController控制
    case `default`
    /// 强制控制器使用暗色-深蓝色142341
    case dark
    /// 强制控制器使用亮色-白色
    case light
}
