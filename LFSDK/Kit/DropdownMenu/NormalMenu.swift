//
//  NormalMenu.swift
//  YMSDK
//
//  Created by admin on 2021/3/16.
//

import UIKit

/// 普通菜单

class NormalMenu: UIView {
    weak var collectoinView: UICollectionView!

    /// 数据源
    var dataSource = [String]()
    /// 展开状态
    var expandstatus: ExpandStatus = .closed
    /// 当前选中项
    var selectedItem: String = ""
    /// 菜单选项
    var menuitems: [String] = []

    /// 内容高度
    var contentHeight: CGFloat = 0

    /// 选中回调
    var onSelect: ((_ index: Int, _ item: String) -> Void)?

    init(frame: CGRect, items: [String]) {
        super.init(frame: frame)
        setupUI()
        dataSource = items
        selectedItem = items.first ?? ""
        status = .closed
    }

    override private init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white
        clipsToBounds = true
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        collectoinView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            self.addSubview($0)
            $0.backgroundColor = .white
            $0.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            $0.register(MenuCell.self, forCellWithReuseIdentifier: "MenuCell")
            $0.dataSource = self
            $0.delegate = self
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(0)
            }
        }
        DispatchQueue.main.async {
            self.contentHeight = self.collectoinView.collectionViewLayout.collectionViewContentSize.height + 16
            self.collectoinView.snp.updateConstraints { update in
                update.height.equalTo(self.contentHeight)
            }
        }
    }
}

extension NormalMenu: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.model = dataSource[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelect?(self.tag, dataSource[indexPath.row])
    }
}

extension NormalMenu: DropMenuProtocol {
    var menuHeight: CGFloat {
        return status == .closed ? 0 : contentHeight
    }
    var status: ExpandStatus {
        get {
            return expandstatus
        }
        set {
            expandstatus = newValue
        }
    }
    var curSelect: String {
        get {
            return selectedItem
        }
        set {
            selectedItem = newValue
        }
    }
    var items: [String] {
        get {
            return menuitems
        }
        set {
            menuitems = items
        }
    }
}
