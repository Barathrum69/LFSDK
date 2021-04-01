//
//  GradientView.swift
//  ymsports
//
//  Created by wood on 2017/10/16.
//

import UIKit

/// UIView渐变 [上 -> 下]  或 [左 -> 右]
public class GradientView: UIView {
    @IBInspectable public var topColor: UIColor?
    @IBInspectable public var bottomColor: UIColor?
    @IBInspectable public var leftColor: UIColor?
    @IBInspectable public var rightColor: UIColor?
    weak var gradientLayer: CAGradientLayer!

    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        gradientLayer?.removeFromSuperlayer()
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint.zero
        gradient.zPosition = -1
        if let topColor = topColor, let bottomColor = bottomColor {
            gradient.colors = [topColor.cgColor, bottomColor.cgColor]
            gradient.endPoint = CGPoint(x: 0, y: 1)
        }
        if let leftColor = leftColor, let rightColor = rightColor {
            gradient.colors = [leftColor.cgColor, rightColor.cgColor]
            gradient.endPoint = CGPoint(x: 1, y: 0)
        }
        layer.addSublayer(gradient)
        gradientLayer = gradient
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        if let layer = gradientLayer {
            layer.frame = self.bounds
            if let topColor = topColor, let bottomColor = bottomColor {
                layer.colors = [topColor.cgColor, bottomColor.cgColor]
                layer.endPoint = CGPoint(x: 0, y: 1)
            }
            if let leftColor = leftColor, let rightColor = rightColor {
                layer.colors = [leftColor.cgColor, rightColor.cgColor]
                layer.endPoint = CGPoint(x: 1, y: 0)
            }
        } else {
            let gradient = CAGradientLayer()
            gradient.frame = self.bounds
            gradient.startPoint = CGPoint.zero
            gradient.zPosition = -1
            if let topColor = topColor, let bottomColor = bottomColor {
                gradient.colors = [topColor.cgColor, bottomColor.cgColor]
                gradient.endPoint = CGPoint(x: 0, y: 1)
            }
            if let leftColor = leftColor, let rightColor = rightColor {
                gradient.colors = [leftColor.cgColor, rightColor.cgColor]
                gradient.endPoint = CGPoint(x: 1, y: 0)
            }
            layer.addSublayer(gradient)
            gradientLayer = gradient
        }
    }
}
