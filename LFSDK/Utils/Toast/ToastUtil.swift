//
//  ToastUtil.swift
//  ymsports
//
//  Created by wood on 21/1/21.
//

import Kingfisher
import UIKit

/// 错误类型
public class ServiceError {
    /// 加载失败错误类型
    ///
    /// - normal: 普通错误，没有图标，提示语”网络错误“ + 按钮”重新加载“
    /// - partial : 局部错误，用于视图页面中某一部分视图显示错误，”加载失败，点击重试“
    /// - noNetwork: 网络错误，网络错误图标 + 提示语”网络错误“ + 按钮”重新加载“
    /// - noNetwork: 网络错误，网络错误图标 + 提示语”没有数据“ + 按钮”重新加载“
    /// - custom: 自定义错误
    public enum ErrorType: Int {
        /// default: 普通错误，通用错误图标 + 提示语”接口返回的错误提示“ + 按钮”重新加载“
        case `default`
        /// partial : 局部错误，用于视图页面中某一部分视图显示错误，”加载失败，点击重试“
        case partial
        /// noNetwork: 网络错误，网络错误图标 + 提示语”网络错误“ + 按钮”重新加载“
        case noNetwork
        /// noData: 网络错误，网络错误图标 + 提示语”没有数据“ + 按钮”重新加载“
        case noData
        /// custom: 自定义错误
        case custom
    }
    /// 错误类型
    var type: ErrorType = .default
    var icon: String?
    var errorMsg: String?
    var btnText: String?
    var handler: VoidBlock?

    public init(type: ErrorType, handler: VoidBlock?) {
        self.type = type
        self.handler = handler
    }
    public init(errorMsg: String?, handler: VoidBlock?) {
        self.errorMsg = errorMsg
        self.handler = handler
    }
}

/// Loading显示
public class ToastUtil {
    enum LoadingStyle {
        /// 整个控制器的 loading
        case pageLoading
        /// 局部 rect loading
        case smallRectLoading
    }

    enum ResultType {
        case success(msg: String?)
        case failure(msg: String?)
    }

    /// 显示Toast提示，记得在主线程调用不会帮你做容错处理
    /// - Parameter view: 指定view，默认当前controller.view，生命周期超出当前页面时才keyWindow（慎用）
    /// - Returns: IndicatorView 显示toast的view，非主线程或者应用还未初始化时调用返回nil
    @discardableResult
    public class func showLoading(in view: UIView? = UIApplication.topViewController?.view) -> UIView? {
        if !Thread.current.isMainThread {
            XLog("非主线程调用UIKit")
            return nil
        }
        guard let view = view ?? UIApplication.shared.keyWindow else { return nil }
        var style: ToastUtil.LoadingStyle = .smallRectLoading
        if view == UIApplication.topViewController?.view || view == UIApplication.shared.keyWindow {
            style = .pageLoading
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.hide(in: view)
        let indicatorView = IndicatorView()
        if style == .pageLoading {
            indicatorView.backgroundColor = .init(white: 1, alpha: 0.5)
        }
        view.addSubview(indicatorView)
        // 如果此视图的高是屏幕的高度就会遮住顶部导航栏，影响用户操作
        var topOffset: CGFloat = 0
        if UIApplication.shared.keyWindow != view && view.frame.size.height == UIDevice.height {
            topOffset = UIDevice.navBarHeight
        }
        if view is UIScrollView {
            indicatorView.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(topOffset)
                make.center.equalToSuperview()
            }
        } else {
            indicatorView.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(topOffset)
            }
        }
        return indicatorView
    }

    /// 从指定页面中隐藏Loading
    ///
    /// - Parameter view: 指定view
    public class func hide(in view: UIView? = UIApplication.topViewController?.view) {
        guard let view = view ?? UIApplication.shared.keyWindow else { return }
        if Thread.current.isMainThread {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            view.subviews.forEach {
                if $0 is IndicatorView {
                    $0.removeFromSuperview()
                }
            }
        } else {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                view.subviews.forEach {
                    if $0 is IndicatorView {
                        $0.removeFromSuperview()
                    }
                }
            }
        }
    }

    /// 在指定视图中显示数据加载失败
    ///
    /// - Parameters:
    ///   - error: 错误对象
    ///   - view: 置顶视图
    /// - Returns: IndicatorView
    @discardableResult
    public class func showError(_ error: ServiceError, view: UIView) -> UIView {
        ToastUtil.hide(in: view)
        // 1、局部视图用点击重新加载的样式
        // 2、主视图用图标样式
        let indicatorView = IndicatorView(error: error)
        view.addSubview(indicatorView)
        var topOffset: CGFloat = 0
        if UIApplication.shared.keyWindow != view && view.frame.size.height == UIDevice.height {
            topOffset = UIDevice.navBarHeight
        }
        indicatorView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(topOffset)
            if view is UIScrollView {
                make.center.equalToSuperview()
            }
        }
        return indicatorView
    }

    /// 在指定视图中显示半透明mask
    ///
    /// - Parameters:
    ///   - view: 指定视图
    ///   - tapHandler: 点击mask回调事件
    /// - Returns: MaskView
    public class func showMask(in view: UIView, _ tapHandler: VoidBlock?) -> UIView {
        let mask = MaskView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), handler: tapHandler)
        view.addSubview(mask)
        return mask
    }

    /// 在指定视图中显示toast文本提示
    ///
    /// - Parameters:
    ///   - message: 要显示的内容
    ///   - inView: 在哪个视图上显示，默认(不传)是当前控制器view
    ///   - timeout: 显示时长默认2s
    /// - Returns: UILabel
    @discardableResult
    public class func showMessage(_ message: String?, inView: UIView? = UIApplication.topViewController?.view, timeout: TimeInterval = 2) -> UIView? {
        guard let message = message, !message.isEmpty else { return nil }
        if !Thread.current.isMainThread {
            XLog("非主线程调用UIKit")
            return nil
        }
        guard let inView = inView ?? UIApplication.shared.keyWindow else { return nil }
        if let originLabel = inView.viewWithTag(012_345_677) {
            originLabel.removeFromSuperview()
        }

        let label = UILabel()
        label.tag = 012_345_677

        label.backgroundColor = .init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
        label.layer.cornerRadius = 5.0
        label.layer.masksToBounds = true
        label.text = message
        label.textAlignment = .center
        label.numberOfLines = 10
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)

        let frameW = inView.frame.width
        let frameH = inView.frame.height
        label.preferredMaxLayoutWidth = frameW - 60
        let size = label.text!.boundingRect(
            with: CGSize(width: frameW - 60, height: CGFloat(MAXFLOAT)),
            options: .usesLineFragmentOrigin, attributes: [.font: label.font!],
            context: nil).size
        label.frame = CGRect(
            x: (frameW - size.width - 20) * 0.5,
            y: (frameH - size.height - 25) * 0.5 - 80,
            width: size.width + 20,
            height: size.height + 25)

        inView.addSubview(label)

        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { [weak label] in
            label?.removeFromSuperview()
        }

        return label
    }
}

private class IndicatorView: UIView {
    var error: ServiceError?

    init(error: ServiceError) {
        super.init(frame: CGRect.zero)
        self.error = error
        self.backgroundColor = UIColor.white
        switch error.type {
        case .partial:
            let button = UIButton(text: "hintMsg_click_to_reload".sdkLocalized(), color: UIColor.hex(0x999999), size: 12)
            button.backgroundColor = UIColor.white
            button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
            self.addSubview(button)
            button.snp.makeConstraints({ make in
                make.edges.equalToSuperview()
            })
        default:
            var imageName = error.icon ?? ""
            var errorMsg = error.errorMsg
            if error.type == .default {
                imageName = "imgDefaultNoBankcard"
            } else if error.type == .noNetwork {
                imageName = "imgDefaultNoNetwork"
                errorMsg = "error_network_error".sdkLocalized()
            } else if error.type == .noData {
                imageName = "imgDefaultNoData"
                errorMsg = "error_page_no_data".sdkLocalized()
            }
            let imageView = UIImageView(image: UIImage(named: imageName, in: Localized.bundle, compatibleWith: nil))
            let label = UILabel(text: errorMsg, color: UIColor.hex(0x999999), size: 12)
            label.numberOfLines = 0
            label.textAlignment = .center
            let button = UIButton(text: error.btnText ?? "hintMsg_reload".sdkLocalized(), color: UIColor.hex(0x999999), size: 14)
            button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
            button.layer.borderColor = UIColor.hex(0xCCCCCC).cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 4
            button.clipsToBounds = true
            // 如果类型时noData且没有回调函数则隐藏重新加载按钮
            if error.type == .noData, error.handler == nil {
                button.isHidden = true
            }
            self.addSubview(imageView)
            self.addSubview(label)
            self.addSubview(button)
            imageView.snp.makeConstraints({ make in
                make.centerX.equalToSuperview()
            })
            label.snp.makeConstraints({ make in
                make.centerX.equalToSuperview()
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.centerY.equalToSuperview().offset(imageName.isEmpty ? -130 : -100)
                make.top.equalTo(imageView.snp.bottom)
            })
            button.snp.makeConstraints({ make in
                make.centerX.equalToSuperview()
                make.top.equalTo(label.snp.bottom).offset(8)
                make.height.equalTo(30)
            })
        }
    }

    @objc func buttonClick() {
        if let handler = error?.handler {
            handler()
        }
    }

    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.6)

        let indicatorView = UIActivityIndicatorView(style: .whiteLarge)
        indicatorView.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.75)
        indicatorView.startAnimating()
        indicatorView.hidesWhenStopped = true
        indicatorView.layer.cornerRadius = 10
        indicatorView.clipsToBounds = true
        self.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 70, height: 70))
        }
        // 可以用image loading
//        let imageView = UIImageView()
//        let provider = LocalFileImageDataProvider(fileURL: URL(fileURLWithPath: Localized.bundle.path(forResource: "loading_v2", ofType: "gif")!))
//        imageView.kf.setImage(with: provider)
//        self.addSubview(imageView)
//        imageView.snp.makeConstraints({ (make) in
//            make.center.equalToSuperview()
//            make.size.equalTo(CGSize(width: 30, height: 30))
//        })
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let view = self.superview else { return }
        var topOffset: CGFloat = UIDevice.navBarHeight
        if UIApplication.shared.keyWindow != view && view.frame.size.height < UIDevice.height {
            topOffset = 0
        }
        if view is UIScrollView {
            self.snp.remakeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(topOffset)
                make.center.equalToSuperview()
            }
        } else {
            self.snp.remakeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(topOffset)
            }
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CircleLoadingView: UIView {
    let duration = 1.0

    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: frame.origin, size: CGSize(width: 40, height: 40)))

        // 大小变化
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0, 1.0, 2.0]
        scaleAnimation.values = [1, 0.5, 1]
        scaleAnimation.duration = duration

        // 透明度
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.keyTimes = [0, 1.0, 2.0]
        opacityAnimation.values = [0, 0.45, 1]
        opacityAnimation.duration = duration

        // 组动画
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [scaleAnimation, opacityAnimation]
        groupAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        groupAnimation.duration = duration
        groupAnimation.repeatCount = MAXFLOAT
        groupAnimation.isRemovedOnCompletion = false

        // 定期创建8个小圆
        let beginTimes = [0, 0.15, 0.3, 0.45, 0.6, 0.75, 0.9, 1.0]
        for i in 0..<beginTimes.count {
            let layer = circle(angle: CGFloat(Double(i) * 2 * Double.pi / Double(beginTimes.count)),
                               size: 10,
                               origin: CGPoint.zero,
                               containerSize: CGSize(width: 40, height: 40),
                               color: UIColor.orange)
            groupAnimation.beginTime = beginTimes[i]
            layer.add(groupAnimation, forKey: "shape")
            self.layer.addSublayer(layer)
        }
    }

    func circle(angle: CGFloat, size: CGFloat, origin: CGPoint, containerSize: CGSize, color: UIColor) -> CALayer {
        let radius = containerSize.width * 0.5
        let circle = layer(size: CGSize(width: size, height: size), color: color)
        let frame = CGRect(
            x: origin.x + radius * (cos(angle) + 1) - size * 0.5,
            y: origin.y + radius * (sin(angle) + 1) - size * 0.5,
            width: size,
            height: size)
        circle.frame = frame
        return circle
    }

    func layer(size: CGSize, color: UIColor) -> CALayer {
        // CAShapeLayer是一个通过矢量图形而不是位图来绘制，用CGPath来定义要绘制的图形
        // Core Graphics可以直接在原始的layer中绘制图形
        // CAShapeLayer使用了GPU加速
        let layer = CAShapeLayer()
        // 根据中心点画圆
        let path = UIBezierPath(
            arcCenter: CGPoint(x: size.width * 0.5, y: size.height * 0.5),
            radius: size.width * 0.5,
            startAngle: 0,
            endAngle: CGFloat(2 * Double.pi),
            clockwise: false)
        // 填充颜色
        layer.fillColor = color.cgColor
        // 把贝塞尔曲线路径设为layer的渲染路径
        layer.path = path.cgPath
        return layer
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
