//
//  PopAlertView.swift
//  ymsports
//
//  Created by wood on 22/1/21.
//

import UIKit

/// APP 统一弹框（确认框、提示框）
public class PopAlertObj {
    /// 弹框标题 eg:温馨提示
    let title: String
    /// 富文本-弹框标题 eg:温馨提示
    let attrTitle: NSAttributedString?
    /// 弹框内容
    let subtitle: String?
    /// 富文本-弹框内容
    let attrSubtitle: NSAttributedString?
    /// 取消按钮-取消
    let cancelText: String?
    /// 富文本-取消按钮-取消
    let attrCancelText: NSAttributedString?
    /// 确认按钮-确认
    let confirmText: String?
    /// 富文本-确认按钮-确认
    let attrConfirmText: NSAttributedString?
    /// 确定按钮回调
    let block: VoidBlock
    /// 取消按钮回调
    var cancelBlock: VoidBlock?
    /// 当弹框内容有下划线链接时可以点击
    public var textBlock: VoidBlock?
    public var textAlignment: NSTextAlignment = .center
    fileprivate let isAttribute: Bool

    public init(title: String = "",
                subtitle: String? = nil,
                cancelText: String? = nil,
                confirmText: String? = nil,
                block: @escaping VoidBlock = {}) {
        self.title = title
        self.subtitle = subtitle
        self.cancelText = cancelText
        self.confirmText = confirmText
        self.block = block
        self.attrTitle = nil
        self.attrSubtitle = nil
        self.attrCancelText = nil
        self.attrConfirmText = nil
        isAttribute = false
    }

    public init(attribute title: NSAttributedString? = nil,
                subtitle: NSAttributedString? = nil,
                cancelText: NSAttributedString? = nil,
                confirmText: NSAttributedString? = nil,
                block: @escaping VoidBlock = {}) {
        self.attrTitle = title
        self.attrSubtitle = subtitle
        self.attrCancelText = cancelText
        self.attrConfirmText = confirmText
        self.block = block
        self.title = ""
        self.subtitle = nil
        self.cancelText = nil
        self.confirmText = nil
        isAttribute = true
    }
}

public class PopAlertView: UIView {
    private static let confirmAlert = Localized.bundle.loadNibNamed("PopAlertView", owner: nil, options: nil)!.first as! PopAlertView
    private static let tipAlert = Localized.bundle.loadNibNamed("PopAlertView", owner: nil, options: nil)![1] as! PopAlertView

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var sureBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    /// 默认是14，如果没有title高度为0
    @IBOutlet weak var alertTitleBottom: NSLayoutConstraint?
    @IBOutlet weak var tipTitleBottom: NSLayoutConstraint?

    override public func awakeFromNib() {
        super.awakeFromNib()
        if let subtitle = subtitle {
            subtitle.isUserInteractionEnabled = true
            subtitle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:))))
        }
    }

    public class func showConfirmAlert(obj: PopAlertObj) {
        if obj.isAttribute {
            confirmAlert.title.attributedText = obj.attrTitle
            if let text = obj.attrSubtitle {
                confirmAlert.subtitle.attributedText = text
                confirmAlert.subtitle.textAlignment = obj.textAlignment
            } else {
                confirmAlert.subtitle.attributedText = nil
            }
            if let text = obj.attrCancelText {
                confirmAlert.cancelBtn.setAttributedTitle(text, for: [])
            } else {
                confirmAlert.cancelBtn.setTitle("alert_cancel".sdkLocalized(), for: [])
            }
            if let text = obj.attrConfirmText {
                confirmAlert.sureBtn.setAttributedTitle(text, for: [])
            } else {
                confirmAlert.sureBtn.setTitle("alert_sure".sdkLocalized(), for: [])
            }
        } else {
            confirmAlert.title.text = obj.title
            if let text = obj.subtitle {
                confirmAlert.subtitle.text = text
                confirmAlert.subtitle.textAlignment = obj.textAlignment
            } else {
                confirmAlert.subtitle.text = nil
            }
            if let text = obj.cancelText {
                confirmAlert.cancelBtn.setTitle(text, for: [])
            } else {
                confirmAlert.cancelBtn.setTitle("alert_cancel".sdkLocalized(), for: [])
            }
            if let text = obj.confirmText {
                confirmAlert.sureBtn.setTitle(text, for: [])
            } else {
                confirmAlert.sureBtn.setTitle("alert_sure".sdkLocalized(), for: [])
            }
        }
        confirmAlert.alertTitleBottom?.constant = 14
        if confirmAlert.title.text?.isEmpty ?? true || confirmAlert.title.attributedText?.string.isEmpty ?? true {
            confirmAlert.alertTitleBottom?.constant = 0
        }
        confirmAlert.sureBlock = obj.block
        confirmAlert.cancelBlock = obj.cancelBlock
        confirmAlert.textBlock = obj.textBlock
        if obj.textBlock != nil, let view = UIApplication.topViewController?.view {
            confirmAlert.showPop(inView: view, widthFactor: 0.8, tapMaskClose: false)
        } else {
            confirmAlert.showPop(widthFactor: 0.8, tapMaskClose: false)
        }
    }

    public class func showTipAlert(obj: PopAlertObj) {
        if obj.isAttribute {
            tipAlert.title.attributedText = obj.attrTitle
            if let text = obj.attrSubtitle {
                tipAlert.subtitle.attributedText = text
                tipAlert.subtitle.textAlignment = obj.textAlignment
            } else {
                tipAlert.subtitle.attributedText = nil
            }
            if let text = obj.attrConfirmText {
                tipAlert.sureBtn.setAttributedTitle(text, for: [])
            } else {
                tipAlert.sureBtn.setTitle("business_i_know".sdkLocalized(), for: [])
            }
        } else {
            tipAlert.title.text = obj.title
            if let text = obj.subtitle {
                tipAlert.subtitle.text = text
                tipAlert.subtitle.textAlignment = obj.textAlignment
            } else {
                tipAlert.subtitle.text = nil
            }
            if let text = obj.confirmText {
                tipAlert.sureBtn.setTitle(text, for: [])
            } else {
                tipAlert.sureBtn.setTitle("business_i_know".sdkLocalized(), for: [])
            }
        }
        tipAlert.tipTitleBottom?.constant = 14
        if tipAlert.title.text?.isEmpty ?? true || tipAlert.title.attributedText?.string.isEmpty ?? true {
            tipAlert.tipTitleBottom?.constant = 0
        }
        tipAlert.sureBlock = obj.block
        tipAlert.textBlock = obj.textBlock
        if obj.textBlock != nil, let view = UIApplication.topViewController?.view {
            tipAlert.showPop(inView: view, widthFactor: 0.8)
        } else {
            tipAlert.showPop(widthFactor: 0.8)
        }
    }

    private var sureBlock: VoidBlock?
    private var cancelBlock: VoidBlock?
    private var textBlock: VoidBlock?

    @IBAction func cancel(_ sender: Any) {
        self.closePop { [weak self] in
            self?.cancelBlock?()
        }
    }

    @IBAction func sure(_ sender: Any) {
        self.closePop { [weak self] in
            self?.sureBlock?()
        }
    }

    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        textBlock?()
    }
}
