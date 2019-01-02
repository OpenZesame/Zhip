//
//  ChooseWalletView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

final class ChooseWalletView: UIView {

    private lazy var motionEffectPlanetsImageView   = UIView()
    private lazy var impressionLabel                = UILabel()
    private lazy var subtitleLabel                  = UILabel()
    private lazy var createNewWalletButton          = UIButton()
    private lazy var restoreWalletButton            = UIButton()

    private lazy var stackView = UIStackView(arrangedSubviews: [
        .spacer,
        impressionLabel,
        subtitleLabel,
        createNewWalletButton,
        restoreWalletButton
    ])

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }
}

extension ChooseWalletView: ViewModelled {
    typealias ViewModel = ChooseWalletViewModel
    var inputFromView: InputFromView {
        return InputFromView(
            createNewWalletTrigger: createNewWalletButton.rx.tap.asDriver(),
            restoreWalletTrigger: restoreWalletButton.rx.tap.asDriver()
        )
    }
}

private typealias € = L10n.Scene.ChooseWallet
private extension ChooseWalletView {

    // swiftlint:disable:next function_body_length
    func setup() {
        stackView.withStyle(.default) {
            $0.spacing(0)
        }

        stackView.setCustomSpacing(16, after: impressionLabel)
        stackView.setCustomSpacing(40, after: subtitleLabel)
        addSubview(stackView)
        stackView.edgesToSuperview()

        insertSubview(motionEffectPlanetsImageView, belowSubview: stackView)
        motionEffectPlanetsImageView.edgesToSuperview()
        setupPlanetsImageWithMotionEffect()

        impressionLabel.withStyle(.impression) {
            $0.text(€.Label.impression)
        }

        subtitleLabel.withStyle(.body) {
            $0.text(€.Label.setUpWallet)
        }

        createNewWalletButton.withStyle(.primary) {
            $0.title(€.Button.newWallet)
        }

        restoreWalletButton.withStyle(.secondary) {
            $0.title(€.Button.restoreWallet)
        }
    }

    func setupPlanetsImageWithMotionEffect() {
        motionEffectPlanetsImageView.backgroundColor = .clear
        motionEffectPlanetsImageView.translatesAutoresizingMaskIntoConstraints = false

        let stars = Asset.Images.Spaceship.stars.image
        let starsFlipped = stars.withVerticallyFlippedOrientation(yOffset: -stars.size.height/2).withHorizontallyFlippedOrientation()

        motionEffectPlanetsImageView.addMotionEffectFromImages(
            front: Asset.Images.planets.image,
            middle: stars,
            back: starsFlipped // yes double stars, but flipped

        )
    }
}

extension UIImage {
    func withVerticallyFlippedOrientation(yOffset: CGFloat = 0) -> UIImage {
        guard let cgImage = cgImage else {
            incorrectImplementation("should be able to read cgImage")
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let bitmap = UIGraphicsGetCurrentContext()!

        bitmap.translateBy(x: size.width / 2, y: size.height / 2)
        bitmap.scaleBy(x: 1.0, y: 1.0)

        bitmap.translateBy(x: -size.width / 2, y: -size.height / 2)
        bitmap.draw(cgImage, in: CGRect(x: 0, y: yOffset, width: size.width, height: size.height))

        let imageFromContext = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = imageFromContext else {
            incorrectImplementation("should be able to flip image")
        }
        return image
    }
}
