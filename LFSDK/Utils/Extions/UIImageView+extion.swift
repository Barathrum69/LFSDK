//
//  UIImageView+extion.swift
//  YMSDK
//
//  Created by wood on 20/3/21.
//

import UIKit

public extension UIImageView {
    /// image动画 瞬间放大缩小
    func playBounce() {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.5)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic

        self.layer.add(bounceAnimation, forKey: nil)

        if let iconImage = self.image {
            let renderImage = iconImage.withRenderingMode(.automatic)
            self.image = renderImage
        }
    }
}
