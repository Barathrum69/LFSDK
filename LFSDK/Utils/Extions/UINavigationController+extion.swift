//
//  UINavigationController+extion.swift
//  YMSDK
//
//  Created by wood on 20/3/21.
//

import UIKit

public extension UINavigationController {
    /// Pop到前N个控制器
    ///
    /// - Parameter index: 控制器栈中倒数第几个
    func popViewController(atLast index: Int) {
        let count = self.viewControllers.count
        if !self.viewControllers.isEmpty && index < count {
            self.popToViewController(self.viewControllers[count - 1 - index], animated: true)
        }
    }
}
