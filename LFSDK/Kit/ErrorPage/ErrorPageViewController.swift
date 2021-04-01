//
//  ErrorPageViewController.swift
//  ymsports
//
//  Created by wood on 3/3/21.
//

import SnapKit
import UIKit

public class ErrorPageViewController: BaseViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = "error_page_title".sdkLocalized()

        setupUI()
    }

    private func setupUI() {
        self.view.backgroundColor = UIColor.hex(0xeeeeee)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "iconClose", in: Localized.bundle, compatibleWith: nil),
            style: .plain,
            target: self,
            action: #selector(back))

        let imageView = UIImageView(image: UIImage(named: "imgDefaultNoData", in: Localized.bundle, compatibleWith: nil))
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.centerX.equalToSuperview()
        }
    }

    override func back() {
        self.dismiss(animated: true, completion: nil)
    }
}
