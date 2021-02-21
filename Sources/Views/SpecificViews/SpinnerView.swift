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
import RxCocoa
import RxSwift

class SpinnerView: UIView {

    let circleLayer = CAShapeLayer()
    private(set) var isAnimating = false
    var animationDuration: TimeInterval = 2

    init() {
        super.init(frame: .zero)
        setup(strokeColor: .white)
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }

    override func layoutSubviews() {
        super.layoutSubviews()
        if circleLayer.frame != bounds {
            updateCircleLayer()
        }
    }
}

extension SpinnerView {
    func startSpinning() {
        isHidden = false
        guard !isAnimating else { return }
        isAnimating = true
        addAnimation()
    }

    func stopSpinning () {
        isHidden = true
        isAnimating = false
        circleLayer.removeAnimation(forKey: .spinner)
    }

    func changeTo(isLoading: Bool) {
        if isLoading {
            startSpinning()
        } else {
            stopSpinning()
        }
    }
}

extension Reactive where Base == SpinnerView {
    var isLoading: Binder<Bool> {
        return Binder(base) {
            $0.changeTo(isLoading: $1)
        }
    }
}

private extension SpinnerView {
    func setup(strokeColor: UIColor) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.addSublayer(circleLayer)

        circleLayer.fillColor = nil
        circleLayer.lineWidth = 3

        circleLayer.strokeColor = strokeColor.cgColor
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 0

        circleLayer.lineCap = .round

        stopSpinning()
    }

    func updateCircleLayer() {
        let height = bounds.height
        let center = CGPoint(x: bounds.size.width / 2, y: height / 2)
        let radius = (height - circleLayer.lineWidth) / 2

        let startAngle: CGFloat = 0
        let endAngle: CGFloat = 2 * .pi

        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)

        circleLayer.path = path.cgPath
        circleLayer.frame = bounds
    }

    // swiftlint:disable:next function_body_length
    func addAnimation() {
        let rotateAnimation = CAKeyframeAnimation(keyPath: .transformRotation)

        rotateAnimation.values = [0, Float.pi, 2 * Float.pi]

        let halfDuration = animationDuration / 2

        let headAnimation = CABasicAnimation(keyPath: .strokeStart)
        headAnimation.duration = halfDuration
        headAnimation.fromValue = 0
        headAnimation.toValue = 0.25

        let tailAnimation = CABasicAnimation(keyPath: .strokeEnd)
        tailAnimation.duration = halfDuration
        tailAnimation.fromValue = 0
        tailAnimation.toValue = 1

        let endHeadAnimation = CABasicAnimation(keyPath: .strokeStart)
        endHeadAnimation.beginTime = halfDuration
        endHeadAnimation.duration = halfDuration
        endHeadAnimation.fromValue = 0.25
        endHeadAnimation.toValue = 1

        let endTailAnimation = CABasicAnimation(keyPath: .strokeEnd)
        endTailAnimation.beginTime = halfDuration
        endTailAnimation.duration = halfDuration
        endTailAnimation.fromValue = 1
        endTailAnimation.toValue = 1

        let animations = CAAnimationGroup()
        animations.duration = animationDuration
        animations.animations = [
            rotateAnimation,
            headAnimation,
            tailAnimation,
            endHeadAnimation,
            endTailAnimation
        ]
        animations.repeatCount = .infinity
        animations.isRemovedOnCompletion = false

        circleLayer.add(animations, forKey: .spinner)
    }
}

private extension String {
    static let spinner = SpinnerView.description()
    static let strokeStart = "strokeStart"
    static let strokeEnd = "strokeEnd"
    static let transformRotation = "transform.rotation"
}
