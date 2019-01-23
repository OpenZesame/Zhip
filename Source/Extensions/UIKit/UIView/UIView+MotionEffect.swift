//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
