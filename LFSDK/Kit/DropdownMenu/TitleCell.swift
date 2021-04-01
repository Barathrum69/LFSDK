//
//  TitleCell.swift
//  YMSDK
//
//  Created by admin on 2021/3/16.
//

import UIKit

class TitleCell: UICollectionViewCell {
    weak var label: UILabel!
    weak var arrowImgview: UIImageView!

    var status: ExpandStatus = .closed {
        didSet {
        //    label.textColor = status == .closed ? .black : .red
            rotateArrow(down: !(status == .closed))
        }
    }

    var curSelected: String = "" {
        didSet {
            self.label.text = curSelected
            let animation = CATransition()
            animation.duration = dropdownMenuAnimationTime
            animation.type = CATransitionType.fade
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            label.layer.add(animation, forKey: "changeTextTransition")
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 5
        clipsToBounds = true

        let stacVw = UIStackView().then {
            contentView.addSubview($0)
            $0.axis = .horizontal
            $0.alignment = .center
            $0.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(2)
                make.right.equalTo(-2)
            }
        }

        label = UILabel().then {
            stacVw.addArrangedSubview($0)
            $0.minimumScaleFactor = 0.3
            $0.adjustsFontSizeToFitWidth = true
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }

        let img = UIImage(named: "arrow_up", in: Localized.bundle, compatibleWith: nil)
        arrowImgview = UIImageView().then {
            stacVw.addArrangedSubview($0)
            $0.image = UIImage(named: "arrow_up", in: Localized.bundle, compatibleWith: nil)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(12)
            }
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func rotateArrow( down: Bool ) {
        let anim = CABasicAnimation()
        // 旋转动画一定要设置为transform.rotation,不能写错
        anim.keyPath = "transform.rotation"
        // 目标值
        if down {
            anim.toValue = Double.pi
        } else {
            anim.toValue = 0
        }
        // 动画时长
        anim.duration = 0.3
        // 以下两句可以设置动画结束时 layer停在toValue这里
        anim.isRemovedOnCompletion = false
        anim.fillMode = CAMediaTimingFillMode.forwards
        // 添加动画到layer层上
        arrowImgview?.layer.add(anim, forKey: nil)
    }
}
