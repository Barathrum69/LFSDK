//
//  MaskView.swift
//  ymsports
//
//  Created by wood on 2017/12/1.
//

import UIKit

/// 半透明HUD
public class MaskView: UIView, UIGestureRecognizerDelegate {
    static let maskTag = 10_000

    public init(frame: CGRect, handler: VoidBlock?) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.backgroundColor = .init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.7)
        self.tag = MaskView.maskTag
        if let handler = handler {
            self.addTap(handler: { _ in
                handler()
            }).delegate = self
        }
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 如果不是自己，说明是子视图不让响应
        if let view = touch.view, !view.isKind(of: MaskView.self) {
            return false
        }
        return true
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
