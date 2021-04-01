//
//  NotificationKey.swift
//  ymsports
//
//  Created by wood on 30/1/21.
//

import Foundation

public extension Notification.Name {
    /// 系统相关通知
    struct System {
        /// 系统上报日志
        public static let reportRecord = Notification.Name(rawValue: "kok.system.reportRecord")
        /// 系统环境改变 test/super/release
        public static let envChanged = Notification.Name(rawValue: "kok.system.envChanged")
        /// 系统语言改变通知 cn/en
        public static let langChanged = Notification.Name(rawValue: "kok.system.langChanged")
        /// 清理cookie成功
        public static let clearCookie = Notification.Name(rawValue: "kok.system.clearCookie")
        /// WebContainer Back
        public static let webViewBack = Notification.Name(rawValue: "kok.system.webViewBack")
    }
    /// 用户先关通知
    struct User {
        /// 用户登录
        public static let login = Notification.Name(rawValue: "kok.user.login")
        /// 退出登录
        public static let logout = Notification.Name(rawValue: "kok.system.logout")
    }
}
