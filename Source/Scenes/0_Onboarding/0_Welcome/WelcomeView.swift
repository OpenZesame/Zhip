//
//  WelcomeView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-19.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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

    func addMotionEffectFromImages(front: UIImage, middle: UIImage, back: UIImage) {
        let frontImageView = UIImageView(image: front)
        let middleImageView = UIImageView(image: middle)
        let backImageView = UIImageView(image: back)

        let imageViews = [backImageView, middleImageView, frontImageView]

        imageViews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = UIView.ContentMode.center
            addSubview($0)
            $0.backgroundColor = .clear
            $0.edgesToSuperview()
        }

        addMotionEffectTo(views: (backImageView, middleImageView, frontImageView))
    }

    // swiftlint:disable large_tuple
    func addMotionEffectTo(
        views: (back: UIView, middle: UIView, front: UIView),
        strengths: (back: CGFloat, middle: CGFloat, front: CGFloat) = (6, 20, 50)
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

final class WelcomeView: UIView {

    private lazy var motionEffectSpaceshipImage = UIView()
    private lazy var welcomeLabel               = UILabel()
    private lazy var subtitleLabel              = UILabel()
    private lazy var startButton                = UIButton()

    private lazy var stackView = UIStackView(arrangedSubviews: [.spacer, welcomeLabel, subtitleLabel, startButton])

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }
}

extension WelcomeView: ViewModelled {
    typealias ViewModel = WelcomeViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            startTrigger: startButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }
}

// MARK: - Private
private typealias € = L10n.Scene.Welcome
private typealias Image = Asset.Images.Spaceship
private extension WelcomeView {

    // swiftlint:disable:next function_body_length
    func setup() {
        stackView.withStyle(.default) {
            $0.spacing(0)
        }
        stackView.setCustomSpacing(16, after: welcomeLabel)
        stackView.setCustomSpacing(40, after: subtitleLabel)
        addSubview(stackView)
        stackView.edgesToSuperview()

        insertSubview(motionEffectSpaceshipImage, belowSubview: stackView)
        motionEffectSpaceshipImage.edgesToSuperview()
        setupSpaceshipImageWithMotionEffect()

        startButton.withStyle(.primary) {
            $0.title(€.Button.start)
        }

        welcomeLabel.withStyle(.impression) {
            $0.text(€.Label.header)
            .textColor(.white)
        }

        subtitleLabel.withStyle(.body) {
            $0.text(€.Label.body)
             .textColor(.white)
        }
    }

    func setupSpaceshipImageWithMotionEffect() {
        motionEffectSpaceshipImage.backgroundColor = .clear
        motionEffectSpaceshipImage.translatesAutoresizingMaskIntoConstraints = false

        motionEffectSpaceshipImage.addMotionEffectFromImageAssets(
            front: Image.spaceship,
            middle: Image.stars,
            back: Image.clouds
        )
    }
}
