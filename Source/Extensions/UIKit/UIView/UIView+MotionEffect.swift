//
//  UIView+MotionEffect.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-21.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension UIMotionEffect {
    class func twoAxesShift(strength: CGFloat) -> UIMotionEffect {
        // internal method that creates motion effect
        func motion(type: UIInterpolatingMotionEffect.EffectType) -> UIInterpolatingMotionEffect {
            let keyPath = type == .tiltAlongHorizontalAxis ? "center.x" : "center.y"
            let motion = UIInterpolatingMotionEffect(keyPath: keyPath, type: type)
            motion.minimumRelativeValue = -strength
            motion.maximumRelativeValue = strength
            return motion
        }

        // group of motion effects
        let group = UIMotionEffectGroup()
        group.motionEffects = [
            motion(type: .tiltAlongHorizontalAxis),
            motion(type: .tiltAlongVerticalAxis)
        ]
        return group
    }
}

extension UIView {
    func addMotionEffect(strength: CGFloat) {
        addMotionEffect(.twoAxesShift(strength: strength))
    }

    func addMotionEffectFromImageAssets(front: ImageAsset, middle: ImageAsset, back: ImageAsset) {
        addMotionEffectFromImages(front: front.image, middle: middle.image, back: back.image)
    }
    
    func addMotionEffectFromImages(
        front: UIImage, motionEffectStrength frontStrength: CGFloat = 6,
        middle: UIImage, motionEffectStrength middleStrength: CGFloat = 20,
        back: UIImage, motionEffectStrength backStrength: CGFloat = 48,
        verticalInsetForImageViews: CGFloat = -40,
        horizontalInsetForImageViews: CGFloat = -80
        ) {

		let imageViews = [back, middle, front].map { image -> UIImageView in
			let imageView = UIImageView()
			imageView.withStyle(.background(image: image))
			addSubview(imageView)
			imageView.edgesToSuperview(insets:
				UIEdgeInsets(
					top: verticalInsetForImageViews,
					left: horizontalInsetForImageViews,
					bottom: verticalInsetForImageViews,
					right: horizontalInsetForImageViews
				)
			)
			return imageView
		}

        addMotionEffectTo(views: (imageViews[0], imageViews[1], imageViews[2]), strengths: (frontStrength, middleStrength, backStrength))
    }

    // swiftlint:disable large_tuple
    // [4, 15, 40]
    // (8, 30, 50)
    func addMotionEffectTo(
        views: (back: UIView, middle: UIView, front: UIView),
        strengths: (back: CGFloat, middle: CGFloat, front: CGFloat)
        ) {
        let views = [views.back, views.middle, views.front]
        let strengths = [strengths.back, strengths.middle, strengths.front]
        let viewsAndEffectStrength = zip(views, strengths).map { ($0.0, $0.1) }

        addMotionEffectTo(viewsAndEffectStrength: viewsAndEffectStrength)
    }

    func addMotionEffectTo(viewsAndEffectStrength: [(UIView, CGFloat)]) {
        viewsAndEffectStrength.forEach {
            let (view, strength) = $0
            view.addMotionEffect(strength: CGFloat(strength))
        }
    }
}
