//
//  UIView+extion.swift
//  ymsports
//
//  Created by Apple on 2021/3/17.
//

import UIKit

public extension UIView {
    /// 在指定View上动画显示或关闭弹窗
    /// - Parameters:
    ///   - inView: 在指定View上显示弹窗，当isShow=false时可为nil
    ///   - widthFactor: view宽度系数[0.1, 1]表示widthFactor*deviceWidth，如果值为[100, deviceWidth]表示所有机型都一样的宽度，如果不设置widthFactor则用自身的宽
    ///   - tapMaskClose: true:点击mask蒙版执行isShow=false操作 false:必须点关闭按钮才能关闭弹窗，当isShow=false时可为nil
    func showPop(inView: UIView? = UIApplication.shared.keyWindow, widthFactor: CGFloat = CGFloat.zero, tapMaskClose: Bool = true) {
        if !Thread.current.isMainThread {
            XLog("非主线程调用UIKit")
            return
        }
        guard let inView = inView else { return }
        ToastUtil.showMask(in: inView) { tapMaskClose ? self.closePop() : nil }.addSubview(self)
        let width: CGFloat
        switch widthFactor {
        case CGFloat.zero:
            width = self.width
        case 0.1...1:
            width = widthFactor * inView.width
        case 100...inView.width:
            width = widthFactor
        default:
            width = 0.8 * inView.width
        }
        self.frame = CGRect(x: (inView.width - width) * 0.5, y: (inView.height - self.height) * 0.5, width: width, height: self.height)
        /**
         用代码创建的所有view ， translatesAutoresizingMaskIntoConstraints 默认是 YES
         用 IB 创建的所有 view ，translatesAutoresizingMaskIntoConstraints 默认是 NO (autoresize 布局:YES , autolayout布局 :NO)
         如果是xib创建的需要修改Layout设置为Auto
         */
        if !self.translatesAutoresizingMaskIntoConstraints || (widthFactor >= 0.1 && widthFactor <= 1) {
            self.snp.makeConstraints({ make in
                make.center.equalToSuperview()
                make.width.equalTo(width)
            })
        }
        self.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
        }, completion: { _ in
        })
    }

    /// 关闭弹窗
    func closePop(completionBlock: VoidBlock? = nil) {
        UIView.animate(withDuration: 0.35, animations: {
            self.alpha = 0
        }, completion: { _ in
            let mask = self.superview
            self.removeFromSuperview()
            mask?.removeFromSuperview()
            completionBlock?()
        })
    }

    private static var blockKey = "UITapgestureBlockKey"

    /// 为View添加UITapGestureRecognizer事件
    /// - Parameters:
    ///   - handler: 点击回调
    /// - Returns: UITapGestureRecognizer
    @discardableResult
    func addTap(handler: @escaping ((_ sender: UITapGestureRecognizer) -> Void)) -> UITapGestureRecognizer {
        self.isUserInteractionEnabled = true
        let target = _UITapgestureBlockTarget(handler: handler)
        objc_setAssociatedObject(self, &UIView.blockKey, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        let tap = UITapGestureRecognizer(target: target, action: #selector(_UITapgestureBlockTarget.invoke(_:)))
        self.addGestureRecognizer(tap)
        return tap
    }

    private class _UITapgestureBlockTarget {
        private var handler: (_ sender: UITapGestureRecognizer) -> Void
        init(handler: @escaping (_ sender: UITapGestureRecognizer) -> Void) {
            self.handler = handler
        }
        @objc func invoke(_ sender: UITapGestureRecognizer) {
            handler(sender)
        }
    }

    /// frame.x
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame = CGRect(x: newValue, y: frame.origin.y, width: frame.width, height: frame.height)
        }
    }
    /// frame.y
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame = CGRect(x: frame.origin.x, y: newValue, width: frame.width, height: frame.height)
        }
    }
    /// frame.width
    var width: CGFloat {
        get {
            return frame.width
        }
        set {
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: newValue, height: frame.height)
        }
    }
    /// frame.height
    var height: CGFloat {
        get {
            return frame.height
        }
        set {
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: newValue)
        }
    }

    /// stack view 布局
    ///
    /// - Parameters:
    ///   - items: 要布局的子视图集合，须先添加进父视图中才能布局
    ///   - spacing: 间距
    ///   - margin: 边缘
    func stackHerizontal(_ items: [UIView], _ spacing: CGFloat = 0, _ margin: CGFloat = 0) {
        guard items.count > 1 else {
            return
        }
        items.first?.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(margin)
        })
        items.last?.snp.makeConstraints({ make in
            make.right.equalToSuperview().offset(-margin)
        })
        var prev: UIView?
        for view in items {
            if let prev = prev {
                view.snp.makeConstraints({ make in
                    make.left.equalTo(prev.snp.right).offset(spacing)
                    make.width.equalTo(prev)
                })
            }
            view.snp.makeConstraints({ make in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
            })
            prev = view
        }
    }
    func stackVertical(_ items: [UIView], _ spacing: CGFloat = 0, _ margin: CGFloat = 0) {
        guard items.count > 1 else {
            return
        }
        items.first?.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(margin)
        })
        items.last?.snp.makeConstraints({ make in
            make.bottom.equalToSuperview().offset(-margin)
        })
        var prev: UIView?
        for view in items {
            if let prev = prev {
                view.snp.makeConstraints({ make in
                    make.top.equalTo(prev.snp.bottom).offset(spacing)
                    make.height.equalTo(prev)
                })
            }
            view.snp.makeConstraints({ make in
                make.left.equalToSuperview()
                make.right.equalToSuperview()
            })
            prev = view
        }
    }

    /// 单实线样式
    ///
    /// - top: 顶部
    /// - right: 右边
    /// - bottom: 底部
    /// - left: 左边
    /// - all: 边框
    enum BorderEdge {
        case top, right, bottom, left, all
    }

    /// 圆角边框类型
    ///
    /// - none: 不显示边框
    /// - solid: 实线[width:线宽, color:线条颜色,]
    /// - dash: 虚线[width:线宽, color:线条颜色, pattern:样式]
    enum BorderType {
        /// 不显示边框
        case none
        /// 实线[width:线宽, color:线条颜色,]
        case solid(width: CGFloat, color: UIColor)
        /// 虚线[width:线宽, color:线条颜色, pattern:样式]
        case dash(width: CGFloat, color: UIColor, pattern: [NSNumber]?)
    }

    /// 给view添加边框
    ///
    /// - Parameter edge: 给哪一条边加边框
    /// - Parameter border: 边框样式
    func addBorder(edge: BorderEdge = .all, border: BorderType) {
        if case .none = border {
            return
        }
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.fillColor = UIColor.clear.cgColor
        switch border {
        case let .solid(width, color):
            layer.lineWidth = width
            layer.strokeColor = color.cgColor
        case let .dash(width, color, pattern):
            layer.lineWidth = width
            layer.strokeColor = color.cgColor
            layer.lineCap = CAShapeLayerLineCap(rawValue: "round")
            layer.lineDashPattern = pattern
        default:
            break
        }
        var bezierPath = UIBezierPath()
        switch edge {
        case .top:
            bezierPath.move(to: .zero)
            bezierPath.addLine(to: CGPoint(x: width, y: 0))
        case .right:
            bezierPath.move(to: CGPoint(x: width, y: 0))
            bezierPath.addLine(to: CGPoint(x: width, y: height))
        case .bottom:
            bezierPath.move(to: CGPoint(x: 0, y: height))
            bezierPath.addLine(to: CGPoint(x: width, y: height))
        case .left:
            bezierPath.move(to: .zero)
            bezierPath.addLine(to: CGPoint(x: 0, y: height))
        case .all:
            bezierPath = UIBezierPath(rect: bounds)
        }
        layer.path = bezierPath.cgPath
        self.layer.addSublayer(layer)
    }

    /// 指定位置切圆角
    ///
    /// - Parameters:
    ///   - corners: 需要切的角
    ///   - cornerRadii: 圆角半径
    ///   - border: 圆角边框类型 BorderType，默认不显示边框
    func bezierCorner(corners: UIRectCorner, cornerRadii: CGSize, border: BorderType = .none) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
        if case .none = border {
            return
        }
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.fillColor = UIColor.clear.cgColor
        layer.path = maskPath.cgPath
        switch border {
        case let .solid(width, color):
            layer.lineWidth = width
            layer.strokeColor = color.cgColor
        case let .dash(width, color, pattern):
            layer.lineWidth = width
            layer.strokeColor = color.cgColor
            layer.lineCap = CAShapeLayerLineCap(rawValue: "round")
            layer.lineDashPattern = pattern
        default:
            break
        }
        self.layer.addSublayer(layer)
    }

    /// UIView生成指定区域image
    ///
    /// - Parameters:
    ///   - rect: 指定生成区域，默认就是UIView的截图
    func asImage(rect: CGRect? = nil) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect == nil ? bounds : rect!)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }

    /// 获取View所在的当前viewcontroller
    ///
    /// - Returns: UIViewController 没有就返回nil
    func getViewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self) {
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
}
