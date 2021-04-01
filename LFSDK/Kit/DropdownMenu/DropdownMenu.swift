//
//  DropdownMenu.swift
//  YMSDK
//
//  Created by admin on 2021/3/16.
//

import UIKit

enum ExpandStatus {
    case closed // 完全关闭
    case expandedNoraml // 普通展开
    case expandedCustomizeDate // 展开自定义日期
    case expandedStartDatePicker // 展开开始日期选择器
    case expandedEndDatePicker // 展开结束日期选择器
}

protocol DropMenuProtocol where Self: UIView {
    var menuHeight: CGFloat { get }
    var status: ExpandStatus { get set }
    var curSelect: String { get set }
    var items: [String] { get set }
}

public let dropdownMenuAnimationTime = 0.25

public enum MenuType {
    case normal // 普通类型菜单
    case dateCustomize  // 带自定义的日期菜单
}

public class DropdownMenu: UIView {
    /// 标题单元格ID
    let titleCellID = "TitleCell"

    /// 边距
    let padding: CGFloat = 8.0

    /// 头部按钮Collection
    weak var titlesCollectionView: UICollectionView!

    /// 菜单集合
    // var menuArray = [UIView]()
    var menuArray = [DropMenuProtocol]()

    /// 背景遮罩
    weak var backView: UIView!

    /// 背景色
    override public var backgroundColor: UIColor? {
        didSet {
            titlesCollectionView?.backgroundColor = backgroundColor
        }
    }

    override private init(frame: CGRect) {
        super.init(frame: frame)
    }

    public init(frame: CGRect, menuDatas: [(/*title: String, */type: MenuType, items: [String])]) {
        super.init(frame: frame)

        backView = UIView().then {
            self.addSubview($0)
            $0.backgroundColor = .clear
            $0.addGestureRecognizer( UITapGestureRecognizer(target: self, action: #selector(closeMenu)) )
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(self.snp.bottom)
                make.height.equalTo(UIDevice.height)
            }
        }

        for i in 0 ..< menuDatas.count {
            var menu: DropMenuProtocol?
            if menuDatas[i].type == .normal {
                menu = NormalMenu(frame: .zero, items: menuDatas[i].items).then {
                    self.addSubview($0)
                    $0.onSelect = { [weak self] index, item in
                        self?.onSelectedItem(index: index, item: item)
                    }
                    $0.snp.makeConstraints { make in
                        make.left.right.equalToSuperview()
                        make.top.equalTo(self.snp.bottom)
                        make.height.equalTo(0)
                    }
                }
                menu!.tag = i
                self.menuArray.append(menu!)
            } else {
                menu = DateMenu(frame: .zero, items: menuDatas[i].items).then {
                    self.addSubview($0)
                    $0.onSelect = { [weak self] index, item in
                        self?.onSelectedItem(index: index, item: item)
                    }
                    $0.onExpandStatusChanged = { [weak self] index, status in
                        self?.expandMenu(index: index, expand: status)
                    }
                    $0.onCancelBtnTapped = { [weak self] in
                        self?.closeMenu()
                    }
                    $0.snp.makeConstraints { make in
                        make.left.right.equalToSuperview()
                        make.top.equalTo(self.snp.bottom)
                        make.height.equalTo(0)
                    }
                }
                menu!.tag = i
                self.menuArray.append(menu!)
            }
        }
        setupUI(frame: frame)
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if super.point(inside: point, with: event) {
            return true
        }
        for subView in subviews {
            let ptInView = convert(point, to: subView)
            if subView.point(inside: ptInView, with: event) {
                return true
            }
        }
        return false
    }

    private func setupUI(frame: CGRect) {
        titlesCollectionView = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout()).then {
            self.addSubview($0)
            $0.dataSource = self
            $0.delegate = self
            $0.register(TitleCell.self, forCellWithReuseIdentifier: titleCellID)
            $0.snp.makeConstraints { make in
                make.left.top.equalTo(padding)
                make.right.bottom.equalTo(-padding)
            }
        }
    }

    // 关闭
    @objc private func closeMenu() {
        for i in 0 ..< menuArray.count {
            expandMenu(index: i, expand: .closed)
        }
    }

    /// 打开或关闭菜单
    /// 参数：index 菜单序号
    /// 参数：expand 打开或者关闭，true:打开
    private func expandMenu(index: Int, expand: ExpandStatus) {
        if menuArray[index].status == expand {
            return
        }
        menuArray[index].status = expand
        menuArray[index].snp.updateConstraints { update in
            update.height.equalTo(menuArray[index].menuHeight)
        }

        // 所有菜单都为关闭状态时，显示背景
        let backgoundShow = menuArray.contains { item -> Bool in
            item.status != .closed
        }

        UIView.animate(withDuration: dropdownMenuAnimationTime) {
            self.backView.backgroundColor = backgoundShow ? UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2) : .clear
            self.layoutIfNeeded()
        } completion: { _ in
        }
        self.layoutIfNeeded()
        let indexpath = IndexPath(row: index, section: 0)
        let cell = titlesCollectionView.cellForItem(at: indexpath) as! TitleCell
        cell.status = expand
    }

    /// 选中操作
    private func onSelectedItem(index: Int, item: String) {
        expandMenu(index: index, expand: .closed)
        menuArray[index].curSelect = item
        let cell = titlesCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as! TitleCell
        cell.curSelected = item
    }
}

extension DropdownMenu: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuArray.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: titleCellID, for: indexPath) as! TitleCell
        cell.curSelected = menuArray[indexPath.row].curSelect
        cell.status = menuArray[indexPath.row].status
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: collectionView.frame.height)
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0 ..< menuArray.count {
            if i == indexPath.row {
                if menuArray[i].status == .closed {
                    expandMenu(index: i, expand: .expandedNoraml)
                } else {
                    expandMenu(index: i, expand: .closed)
                }
            } else {
                expandMenu(index: i, expand: .closed)
            }
        }
    }
}
