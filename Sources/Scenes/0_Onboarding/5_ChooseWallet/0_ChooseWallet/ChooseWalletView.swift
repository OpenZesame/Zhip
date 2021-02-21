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
private typealias Image = Asset.Images.ChooseWallet
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

        motionEffectPlanetsImageView.addMotionEffectFromImages(
            front: Image.frontPlanets.image,
            middle: Image.middleStars.image,
            back: Image.backAbyss.image
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
