//
//  UIImage+extion.swift
//  YMSDK
//
//  Created by wood on 20/3/21.
//

import UIKit

// MARK: - UIImage
public extension UIImage {
    /// 压缩图片到指定大小 bytes
    ///
    /// - Parameter maxLength: bytes
    /// - Returns: Data
    func compressQuality(maxLength: Int) -> Data {
        var compression: CGFloat = 1
        var data = self.jpegData(compressionQuality: compression)!
        if data.count < maxLength {
            return data
        }
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = self.jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            }
        }
        return data
    }

    /// 压缩图片到指定宽度
    ///
    /// - Parameter width: width
    /// - Returns: UIImage
    func scaleImage(width: CGFloat) -> UIImage {
        if self.size.width < width {
            return self
        }
        let hight = width / self.size.width * self.size.height
        let rect = CGRect(x: 0, y: 0, width: width, height: hight)
        // 开启上下文
        UIGraphicsBeginImageContext(rect.size)
        // 将图片渲染到图片上下文
        self.draw(in: rect)
        // 获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        // 关闭图片上下文
        UIGraphicsEndImageContext()
        return image
    }
}
