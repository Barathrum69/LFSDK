//
//  DateMenu.swift
//  YMSDK
//
//  Created by admin on 2021/3/18.
//

import UIKit

/// 日期选择菜单

class DateMenu: UIView {
    /// 菜单选项
    weak var collectoinView: UICollectionView!
    /// 开始
    weak var startLabel: UILabel!
    /// 开始日期
    weak var startDateLabel: UILabel!
    /// 开始日期PICKER
    weak var startDatePicker: UIDatePicker!
    /// 结束
    weak var endLabel: UILabel!
    /// 结束日期
    weak var endDateLabel: UILabel!
    /// 结束日期PICKER
    weak var endDatePicker: UIDatePicker!
    /// 取消
    weak var cancelBtn: UIButton!
    /// 确定
    weak var okBtn: UIButton!
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
    /// 展开状态变更
    var onExpandStatusChanged: ((_ index: Int, _ status: ExpandStatus) -> Void)?
    /// 取消
    var onCancelBtnTapped: (() -> Void)?
    /// 边距
    let padding: CGFloat = 8.0

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

        // 取消确定
        cancelBtn = UIButton().then {
            self.addSubview($0)
            $0.setTitle("取消", for: .normal)
            $0.backgroundColor = .red
            $0.addTarget(self, action: #selector(onCancelBtnTapped(_:)), for: .touchUpInside)
            $0.snp.makeConstraints { make in
                make.left.bottom.equalToSuperview()
                make.height.equalTo(0)
            }
        }
        okBtn = UIButton().then {
            self.addSubview($0)
            $0.setTitle("确定", for: .normal)
            $0.backgroundColor = .blue
            $0.addTarget(self, action: #selector(onOkBtnTapped(_:)), for: .touchUpInside)
            $0.snp.makeConstraints { make in
                make.right.bottom.equalToSuperview()
                make.height.equalTo(0)
                make.left.equalTo(cancelBtn.snp.right)
                make.width.equalTo(cancelBtn.snp.width)
            }
        }
        // 结束日期picker
        endDatePicker = UIDatePicker().then {
            self.addSubview($0)
            $0.locale = Locale(identifier: "zh_CN")
            $0.datePickerMode = .date
            $0.tag = 10_002
            $0.addTarget(self, action: #selector(onDateSelected), for: .valueChanged)
            if #available(iOS 13.4, *) {
                $0.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
            $0.snp.makeConstraints { make in
                make.left.equalTo(padding)
                make.right.equalTo(-padding)
                make.height.equalTo(0)
                make.bottom.equalTo(okBtn.snp.top)
            }
        }
        setDateLimit(picker: endDatePicker)
        // 结束日期
        endLabel = UILabel().then {
            self.addSubview($0)
            $0.text = "结束日期"
            $0.tag = 201
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer( UITapGestureRecognizer(target: self, action: #selector(onDateTapped(_:))) )
            $0.snp.makeConstraints { make in
                make.left.equalTo(padding)
                make.height.equalTo(0)
                make.bottom.equalTo(endDatePicker.snp.top)
            }
        }
        endDateLabel = UILabel().then {
            self.addSubview($0)
            $0.text = Date().strValue()
            $0.textAlignment = .right
            $0.tag = 202
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer( UITapGestureRecognizer(target: self, action: #selector(onDateTapped(_:))) )
            $0.snp.makeConstraints { make in
                make.left.equalTo(endLabel.snp.right)
                make.right.equalTo(-padding)
                make.height.equalTo(0)
                make.bottom.equalTo(endDatePicker.snp.top)
            }
        }
        // 开始日期picker
        startDatePicker = UIDatePicker().then {
            self.addSubview($0)
            $0.locale = Locale(identifier: "zh_CN")
            $0.tag = 10_001
            $0.addTarget(self, action: #selector(onDateSelected), for: .valueChanged)
            $0.datePickerMode = .date
            if #available(iOS 13.4, *) {
                $0.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
            $0.snp.makeConstraints { make in
                make.left.equalTo(padding)
                make.right.equalTo(-padding)
                make.height.equalTo(0)
                make.bottom.equalTo(endLabel.snp.top)
            }
        }
        setDateLimit(picker: startDatePicker)
        // 开始日期
        startLabel = UILabel().then {
            self.addSubview($0)
            $0.text = "开始日期"
            $0.tag = 101
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer( UITapGestureRecognizer(target: self, action: #selector(onDateTapped(_:))) )
            $0.snp.makeConstraints { make in
                make.left.equalTo(padding)
                make.height.equalTo(0)
                make.bottom.equalTo(startDatePicker.snp.top)
            }
        }
        startDateLabel = UILabel().then {
            self.addSubview($0)
            $0.text = Date().strValue()
            $0.textAlignment = .right
            $0.tag = 102
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer( UITapGestureRecognizer(target: self, action: #selector(onDateTapped(_:))) )
            $0.snp.makeConstraints { make in
                make.left.equalTo(startLabel.snp.right)
                make.right.equalTo(-padding)
                make.height.equalTo(0)
                make.centerY.equalTo(startLabel.snp.centerY)
            }
        }
        // 菜单选项
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        collectoinView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            self.addSubview($0)
            $0.backgroundColor = .white
            $0.contentInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            $0.register(MenuCell.self, forCellWithReuseIdentifier: "MenuCell")
            $0.dataSource = self
            $0.delegate = self
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(0)
                make.bottom.equalTo(startLabel.snp.top)
            }
        }
        DispatchQueue.main.async {
            let collectionHeight = self.collectoinView.collectionViewLayout.collectionViewContentSize.height + 16
            self.collectoinView.snp.updateConstraints { update in
                update.height.equalTo(collectionHeight)
            }
            self.contentHeight = collectionHeight + 30// 30为上方label高度
        }

        let label = UILabel().then {
            self.addSubview($0)
            $0.text = "当前系统支持查询最近30日的交易记录"
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.snp.makeConstraints { make in
                make.left.equalTo(padding)
                make.right.equalTo(-padding)
                make.height.equalTo(30)
                make.bottom.equalTo(collectoinView.snp.top)
            }
        }
    }

    private func setDateLimit(picker: UIDatePicker) {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 8 * 60 * 60)! // TimeZone(identifier: "UTC")!
        var comps = DateComponents()
        let maxDate = Date()
        comps.day = -30
        let minDate = calendar.date(byAdding: comps, to: maxDate)
        picker.maximumDate = maxDate
        picker.minimumDate = minDate
    }

    private func statusExchanged(status: ExpandStatus) {
        let collectionHeight = self.collectoinView.collectionViewLayout.collectionViewContentSize.height + 16
        switch status {
        case .closed,
             .expandedNoraml:
            self.contentHeight = 0
            startDatePicker.snp.updateConstraints { update in
                update.height.equalTo(0)
            }
            startDateLabel.snp.updateConstraints { update in
                update.height.equalTo(0)
            }
            startLabel.snp.updateConstraints { update in
                update.height.equalTo(0)
            }
            endDatePicker.snp.updateConstraints { update in
                update.height.equalTo(0)
            }
            endDateLabel.snp.updateConstraints { update in
                update.height.equalTo(0)
            }
            endLabel.snp.updateConstraints { update in
                update.height.equalTo(0)
            }
            cancelBtn.snp.updateConstraints { update in
                update.height.equalTo(0)
            }
            okBtn.snp.updateConstraints { update in
                update.height.equalTo(0)
            }
            UIView.animate(withDuration: dropdownMenuAnimationTime) {
                self.layoutIfNeeded()
            }
            self.contentHeight = collectionHeight + 30
        case .expandedCustomizeDate:
            startDatePicker.snp.updateConstraints { update in
                update.height.equalTo(0)
            }
            startDateLabel.snp.updateConstraints {update in
                update.height.equalTo(40)
            }
            startLabel.snp.updateConstraints { update in
                update.height.equalTo(40)
            }
            endDatePicker.snp.updateConstraints { update in
                update.height.equalTo(0)
            }
            endDateLabel.snp.updateConstraints { update in
                update.height.equalTo(40)
            }
            endLabel.snp.updateConstraints { update in
                update.height.equalTo(40)
            }
            cancelBtn.snp.updateConstraints { update in
                update.height.equalTo(40)
            }
            okBtn.snp.updateConstraints { update in
                update.height.equalTo(40)
            }
            UIView.animate(withDuration: dropdownMenuAnimationTime) {
                self.layoutIfNeeded()
            }
            self.contentHeight = collectionHeight + 30 + 120
        case .expandedStartDatePicker,
             .expandedEndDatePicker:
            startDatePicker.snp.updateConstraints { update in
                let hPicker = status == .expandedStartDatePicker ? 100 : 0
                update.height.equalTo(hPicker)
            }
            startDateLabel.snp.updateConstraints {update in
                update.height.equalTo(40)
            }
            startLabel.snp.updateConstraints { update in
                update.height.equalTo(40)
            }
            endDatePicker.snp.updateConstraints { update in
                let hPicker = status == .expandedStartDatePicker ? 0 : 100
                update.height.equalTo(hPicker)
            }
            endDateLabel.snp.updateConstraints { update in
                update.height.equalTo(40)
            }
            endLabel.snp.updateConstraints { update in
                update.height.equalTo(40)
            }
            cancelBtn.snp.updateConstraints { update in
                update.height.equalTo(40)
            }
            okBtn.snp.updateConstraints { update in
                update.height.equalTo(40)
            }
            UIView.animate(withDuration: dropdownMenuAnimationTime) {
                self.layoutIfNeeded()
            }
            self.contentHeight = collectionHeight + 30 + 100 + 120
        }
        onExpandStatusChanged?(self.tag, status)
    }

    /// 点击开始日期和结束日期
    @objc private func onDateTapped(_ sender: UITapGestureRecognizer) {
        let tag = sender.view?.tag
        // 开始时间
        if tag == 101 || tag == 102 {
            statusExchanged(status: .expandedStartDatePicker)
        } else if tag == 201 || tag == 202 {
            statusExchanged(status: .expandedEndDatePicker)
        }
    }
    /// 选择日期
    @objc private func onDateSelected(_ datePicker: UIDatePicker) {
        let dateStr = datePicker.date.strValue()
        if datePicker.tag == 10_001 {
            startDateLabel.text = dateStr
        } else {
            endDateLabel.text = dateStr
        }
    }
    /// 取消
    @objc private func onCancelBtnTapped(_ sender: UIButton) {
        onCancelBtnTapped?()
    }
    // 确定
    @objc private func onOkBtnTapped(_ sender: UIButton) {
        onSelect?(self.tag, startDateLabel.text! + "\n" + endDateLabel.text!)
    }
}

extension DateMenu: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        if indexPath.row != dataSource.count - 1 {
            onSelect?(self.tag, dataSource[indexPath.row])
        } else {
            statusExchanged(status: .expandedCustomizeDate)
        }
    }
}

extension DateMenu: DropMenuProtocol {
    var menuHeight: CGFloat {
        return expandstatus == .closed ? 0 : contentHeight
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
