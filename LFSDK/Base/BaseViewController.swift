//
//  BaseViewController.swift
//  ymsports
//
//  Created by wood on 21/1/21.
//

import UIKit

open class BaseViewController: UIViewController {
    open var localizedTitle: String?

    override open func viewDidLoad() {
        super.viewDidLoad()
        if navigationController?.viewControllers.first != self {
            addBackButton()
        }
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var className = self.className
        if let name = self.className.split(separator: ".").last {
            className = String(name)
        }
        // TODO: 统计
        XLog(className)
    }

    private func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "nav_balck_back", in: Localized.bundle, compatibleWith: nil), for: .normal)
        if #available(iOS 13.0, *) {
            let image = UIImage(named: "nav_balck_back", in: Localized.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            backButton.setImage(image, for: .normal)
        }
        backButton.tintColor = UIKitSettings.primaryColor
        backButton.setTitle(" \("nav_leftItem_back".sdkLocalized())", for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc func back() {
        if let navigationController = navigationController {
            if navigationController.viewControllers.count > 1 {
                navigationController.popViewController(animated: true)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    deinit {
        XLog("\(self.className) dealloc")
    }
}
