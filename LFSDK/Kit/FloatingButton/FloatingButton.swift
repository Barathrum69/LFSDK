//
//  FloatingButton.swift
//  YMSDK
//
//  Created by admin on 2021/3/11.
//

import Kingfisher
import SnapKit
import Then
import UIKit

/// GIF浮动按钮
public class FloatingButton: UIView {
    /// 删除按钮大小
    private let closeBtnSize: CGFloat = 15.0

    /// 图片边距
    private let paddingOfImg = 4.0

    /// 按钮距离边缘的内边距
    private let paddingOfButton: CGFloat = 2.0

    /// 点击事件
    public var onClicked : (() -> Void)?

    /// 内部使用，起到传递数据的作用
    private var allPoint: CGPoint?

    /// 内部使用
    private var isHasMove = false
    /// 内部使用
    private var isFirstClick = true

    override public init(frame: CGRect) {
        super.init(frame: frame)
        let path = Localized.bundle.path(forResource: "floatingButton", ofType: "gif")!
        let url = URL(fileURLWithPath: path)
        let provider = LocalFileImageDataProvider(fileURL: url)
        let imageView = UIImageView().then {
            $0.kf.setImage(with: provider)
            $0.clipsToBounds = true
            $0.backgroundColor = .clear
            $0.contentMode = .scaleAspectFill
            self.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.top.equalTo(paddingOfImg)
                make.right.bottom.equalTo(-paddingOfImg)
            }
        }

        // 添加点击事件
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onFloatingBtnTapped))
        tapGesture.cancelsTouchesInView = false
        imageView.addGestureRecognizer(tapGesture)

        // 删除按钮
        _ = UIButton().then {
            $0.setImage(UIImage(named: ""), for: .normal)
            $0.addTarget(self, action: #selector(onCloseBtnTapped), for: .touchUpInside)
            self.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(closeBtnSize)
                make.top.right.equalToSuperview()
            }
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func onCloseBtnTapped() {
        self.removeFromSuperview()
    }

    @objc private func onFloatingBtnTapped() {
        if !isHasMove {
            onClicked?()
        }
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.allPoint = (touches.first?.location(in: self))!
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        self.isHasMove = true
        if self.isFirstClick {
            self.isFirstClick = false
        }
        let temp = (touches.first?.location(in: self))!
        // 计算偏移量
        let offsetx = temp.x - self.allPoint!.x
        let offsety = temp.y - self.allPoint!.y
        self.center = CGPoint(x: self.center.x + offsetx, y: self.center.y + offsety)
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.isFirstClick = true
        XLog("move end")
        // 这段代码只有在按钮移动后才需要执行
        if self.isHasMove && self.superview != nil {
            // 移到父VIEW的边缘
            let superFrame = self.superview!.frame
            UIView.animate(withDuration: 0.2) {
                // 上超限
                var y = self.frame.origin.y
                if y < (self.paddingOfButton + self.superview!.safeAreaInsets.top) {
                    y = (self.paddingOfButton + self.superview!.safeAreaInsets.top)
                }
                // 下超限
                if y > superFrame.height - self.frame.height - self.paddingOfButton - self.superview!.safeAreaInsets.bottom {
                    y = superFrame.height - self.frame.height - self.paddingOfButton - self.superview!.safeAreaInsets.bottom
                }
                if self.center.x > superFrame.width / 2 {
                    // 靠右
                    let x = superFrame.width - self.frame.width - self.paddingOfButton
                    self.frame = CGRect(x: x, y: y, width: self.frame.width, height: self.frame.height)
                } else {
                    // 靠左
                    self.frame = CGRect(x: self.paddingOfButton, y: y, width: self.frame.width, height: self.frame.height)
                }
            }
        }
        self.isHasMove = false
    }
}
