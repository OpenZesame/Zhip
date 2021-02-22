// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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

    @discardableResult
    func addMotionEffectFromImages(
        front: UIImage, motionEffectStrength frontStrength: CGFloat = 6,
        middle: UIImage, motionEffectStrength middleStrength: CGFloat = 20,
        back: UIImage, motionEffectStrength backStrength: CGFloat = 48,
        verticalInsetForImageViews: CGFloat = -40,
        horizontalInsetForImageViews: CGFloat = -80
        // swiftlint:disable:next large_tuple
        ) -> (frontImageView: UIImageView, middleImageView: UIImageView, backImageView: UIImageView) {

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
        return (imageViews[2], imageViews[1], imageViews[0])
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
