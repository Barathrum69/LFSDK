//
//  YMTextView.swift
//  YMSDK
//
//  Created by admin on 2021/3/22.
//

/// 带placeholder和字数限制的TextView

import UIKit

@IBDesignable
public class YMTextView: UITextView {
    /// 占位文字
    @IBInspectable public var placeholder: String?
    /// 占位文字颜色
    @IBInspectable public var placeholderColor: UIColor? = .lightGray
    /// 字数限制
    @IBInspectable public var maxCharacatorCount = 9
    /// 占位文字颜色
    @IBInspectable public var cntColor: UIColor? = .lightGray

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        // 使用通知监听文字改变
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override public func draw(_ rect: CGRect) {
        if !self.hasText {
            let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: self.placeholderColor as Any,
                                                        NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 15)]
            var rect1 = rect
            rect1.origin.x = 8
            rect1.origin.y = 8
            rect1.size.width -= 2 * rect1.origin.x
            (placeholder as NSString?)?.draw(in: rect1, withAttributes: attrs)
        }

        let style2 = NSMutableParagraphStyle()
        style2.alignment = .right
        let attrs2: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: self.cntColor as Any,
                                                    NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 15),
                                                    NSAttributedString.Key.paragraphStyle: style2
                                                    ]
        let strCnt = "\(text.count)/\(maxCharacatorCount)"
        var rect2 = rect
        rect2.origin.x = 8
        rect2.origin.y = rect.height - 20
        rect2.size.width -= 2 * rect2.origin.x
        (strCnt as NSString?)?.draw(in: rect2, withAttributes: attrs2)
    }

    @objc func textDidChange(_ note: Notification) {
        // 会重新调用drawRect:方法
        if text.count > maxCharacatorCount {
            text = String(text.prefix(maxCharacatorCount))
        }
        self.setNeedsDisplay()
    }
}
