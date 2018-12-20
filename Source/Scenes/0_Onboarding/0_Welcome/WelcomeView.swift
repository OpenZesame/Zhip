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
            $0.withStyle(.default)
            $0.backgroundColor = .clear
        }

//        backgroundImageView.snp.makeConstraints { $0.edges.equalToSuperview() }

        zip(imageViews, [6, 20, 50]).forEach { (view, offset) in
            addSubview(view)
//            func addConstraints(_ view: UIView) {
//                view.snp.makeConstraints { $0.leading.trailing.equalToSuperview().inset(-40) }
//                view.snp.makeConstraints { $0.top.bottom.equalToSuperview().inset(-64) }
//            }
            view.edgesToSuperview()
            view.addMotionEffect(strength: CGFloat(offset))
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
private extension WelcomeView {

    // swiftlint:disable:next function_body_length
    func setup() {
        backgroundColor = .deepBlue

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
            front: Asset.spaceship,
            middle: Asset.stars,
            back: Asset.clouds
        )
    }
}
