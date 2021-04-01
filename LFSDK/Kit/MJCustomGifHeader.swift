//
//  MJCustomGifHeader.swift
//  ymsdkdemo
//
//  Created by 11号 on 2021/3/10.
//

import MJRefresh
import UIKit

public extension UIScrollView {
    /// 添加头部刷新YM logo帧动画
    /// - Parameters:
    ///   - block: 刷新要做的事情，例如请求
    func addHeaderRefresh(block: @escaping VoidBlock) {
        self.mj_header = MJCustomGifHeader(refreshingBlock: block)
    }

    /// 添加头部刷新的旋转动画
    /// - Parameter block: 刷新事件
    func addRoaHeaderRefresh(block: @escaping VoidBlock) {
        self.mj_header = MyCustomGifHeader(refreshingBlock: block)
    }

    /// 添加脚部刷新
    /// - Parameters:
    ///   - block: 刷新要做的事情，例如请求
    func addFotterRefresh(block: @escaping VoidBlock) {
        self.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: block)
    }

    func endHeaderRefresh() {
        self.mj_header?.endRefreshing()
    }

    func endFooterRefresh() {
        self.mj_footer?.endRefreshing()
    }
}

/// 下拉刷新logo的帧动画
class MJCustomGifHeader: MJRefreshGifHeader {
    override func prepare() {
        super.prepare()

        let defaulArr = getRefreshingImageArrayWithStartIndex(1, 2)
        let refreshArr = getRefreshingImageArrayWithStartIndex(3, 6)

        // 普通状态
        self.setImages(defaulArr, for: MJRefreshState.idle)
        // 即将刷新状态
        self.setImages(refreshArr, for: MJRefreshState.pulling)
        // 正在刷新状态
        self.setImages(refreshArr, for: MJRefreshState.refreshing)
    }

    func getRefreshingImageArrayWithStartIndex(_ startIndex: Int, _ endIndex: Int) -> [UIImage] {
        var imgArr = [UIImage]()
        for index in startIndex...endIndex {
            let imageName = "load_\(index).png"
            let image = UIImage(named: imageName, in: Localized.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
//            let image = UIImage(named: imageName)
            guard image != nil else { continue }
            imgArr.append(image!)
        }
        return imgArr
    }

    override func placeSubviews() {
        super.placeSubviews()

        // 隐藏状态显示文字
        stateLabel?.isHidden = true
        // 隐藏更新时间文字
        lastUpdatedTimeLabel?.isHidden = true
    }
}

/// 下拉刷新转圈动画
class MyCustomGifHeader: MJRefreshHeader {
    weak var imageView: UIImageView!

    override func prepare() {
        super.prepare()
        let imageView = UIImageView(image: UIImage(named: "load_1", in: Localized.bundle, compatibleWith: nil))
        self.addSubview(imageView)
        self.imageView = imageView
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }

    override var state: MJRefreshState {
        didSet {
            switch state {
            case .refreshing:
                // 把图像已z轴旋转
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.fromValue = 0
                animation.toValue = 2 * Double.pi
                animation.duration = 1
                animation.repeatCount = 100
                animation.fillMode = .forwards
                imageView.layer.add(animation, forKey: "transform.rotation.z")
            default:
                imageView.layer.removeAnimation(forKey: "transform.rotation.z")
            }
        }
    }

    override var pullingPercent: CGFloat {
        didSet {
        }
    }
 }
