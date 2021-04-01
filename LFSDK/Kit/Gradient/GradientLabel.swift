//
//  GradientLabel.swift
//  Superbuy
//
//  Created by wood on 2018/5/21.
//

import UIKit

/// 文字从左到右渐变
public class GradientLabel: UILabel {
    @IBInspectable public var leftColor: UIColor?
    @IBInspectable public var rightColor: UIColor?

    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        if let _ = text, let context = UIGraphicsGetCurrentContext() {
            if leftColor == nil { leftColor = UIColor.white }
            if rightColor == nil { rightColor = UIColor.black }
            drawText(in: bounds)
            let textMask = context.makeImage()
            context.clear(bounds)
            context.translateBy(x: 0, y: bounds.height)
            context.scaleBy(x: 1, y: -1)
            context.clip(to: rect, mask: textMask!)
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let locations: [CGFloat] = [0, 1]
            var colors: [CGFloat] = []
            if let first = leftColor, let second = rightColor {
                var leftRed: CGFloat = 0, leftGreen: CGFloat = 0, leftBlue: CGFloat = 0, leftAlpha: CGFloat = 0
                var rightRed: CGFloat = 0, rightGreen: CGFloat = 0, rightBlue: CGFloat = 0, rightAlpha: CGFloat = 0
                first.getRed(&leftRed, green: &leftGreen, blue: &leftBlue, alpha: &leftAlpha)
                second.getRed(&rightRed, green: &rightGreen, blue: &rightBlue, alpha: &rightAlpha)
                colors.append(contentsOf: [leftRed, leftGreen, leftBlue, leftAlpha, rightRed, rightGreen, rightBlue, rightAlpha])
            }
            let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colors, locations: locations, count: 2)
            context.drawLinearGradient(
                gradient!,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: bounds.width, y: 0),
                options: .drawsBeforeStartLocation)
        }
    }
}
