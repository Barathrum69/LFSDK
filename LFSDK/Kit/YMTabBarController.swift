//
//  YMTabBarController.swift
//  YMSDK
//
//  Created by admin on 2021/3/25.
//

import UIKit

public class YMTabBar: UITabBar {
    private var shapeLayer: CALayer?

    var borderColor: UIColor = .lightGray
    var shadowColor: UIColor = .lightGray

    override public func draw(_ rect: CGRect) {
        super.draw(rect)

        addShape()

        if let cnt = items?.count {
            var midIndex = 0
            if cnt == 3 {
                midIndex = 1
            } else if cnt == 5 {
                midIndex = 2
            } else {
                return
            }

            items![midIndex].imageInsets = UIEdgeInsets(top: -13, left: 0, bottom: 13, right: 0)
        }
    }

    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = borderColor.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.shadowOffset = CGSize(width: 0, height: -2)
        shapeLayer.shadowRadius = 4
        shapeLayer.shadowColor = shadowColor.cgColor
        shapeLayer.shadowOpacity = 0.26

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }

    private func createPath() -> CGPath {
        let height: CGFloat = 86
        let path = UIBezierPath()
        let centerWidth = frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - 45 ), y: 0))

        path.addCurve(to: CGPoint(x: centerWidth, y: height - 55),
                      controlPoint1: CGPoint(x: (centerWidth - 15), y: 5),
                      controlPoint2: CGPoint(x: centerWidth - 32, y: height - 60))

        path.addCurve(to: CGPoint(x: (centerWidth + 45 ), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 32, y: height - 60),
                      controlPoint2: CGPoint(x: (centerWidth + 15), y: 5))

        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }

    /// 这个没起作用，后面再处理
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else {
            return nil
        }

        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else {
                continue
            }
            return result
        }
        return nil
    }
}

public class YMTabBarController: UITabBarController {
    public var tabBarBorderColor: UIColor = .lightGray {
        didSet {
            (tabBar as? YMTabBar)?.borderColor = tabBarBorderColor
        }
    }
    public var tabBarShadowColor: UIColor = .lightGray {
        didSet {
            (tabBar as? YMTabBar)?.shadowColor = tabBarShadowColor
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setValue(YMTabBar(frame: tabBar.frame), forKey: "tabBar")
    }
}
