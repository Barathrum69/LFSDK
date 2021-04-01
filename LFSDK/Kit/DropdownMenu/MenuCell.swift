//
//  MenuCell.swift
//  YMSDK
//
//  Created by admin on 2021/3/16.
//

import UIKit

class MenuCell: UICollectionViewCell {
    weak var label: UILabel!

    var model: String? {
        didSet {
            label.text = model
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        label = UILabel().then {
            contentView.addSubview($0)
            $0.layer.borderWidth = 1
            $0.textAlignment = .center
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.cornerRadius = 5
            $0.clipsToBounds = true
            $0.snp.makeConstraints { make in
                make.left.top.right.bottom.equalToSuperview()
            }
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
