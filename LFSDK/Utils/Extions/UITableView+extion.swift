//
//  UITableView+extion.swift
//  YMSDK
//
//  Created by wood on 20/3/21.
//

import UIKit

// MARK: - UITableView
public extension UITableView {
    /// 标准间距 10
    static let sectionInset: CGFloat = 10.0
    /// section 间距 0
    static let zeroInset: CGFloat = 0.001
}

// MARK: - UITableViewCell
public extension UITableViewCell {
    /// 高度为0的cell （自动布局）
    static var emptyCell: UITableViewCell {
        let cell = UITableViewCell()
        let view = UIView()
        view.backgroundColor = UIColor.clear
        cell.contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.top.equalToSuperview()
            make.bottom.equalToSuperview().priority(.low)
            make.height.equalTo(0.2) // 可显示的最小高度
        }
        return cell
    }
}
