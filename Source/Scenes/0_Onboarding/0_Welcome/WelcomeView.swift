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
import RxCocoa

final class WelcomeView: UIView {

    private lazy var motionEffectSpaceshipImageView = UIView()
    private lazy var impressionLabel                = UILabel()
    private lazy var subtitleLabel                  = UILabel()
    private lazy var startButton                    = UIButton()

    private lazy var stackView = UIStackView(arrangedSubviews: [
        .spacer,
        impressionLabel,
        subtitleLabel,
        startButton
    ])

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

    func setup() {
        stackView.withStyle(.default) {
            $0.spacing(0)
        }

        stackView.setCustomSpacing(16, after: impressionLabel)
        stackView.setCustomSpacing(40, after: subtitleLabel)
        addSubview(stackView)
        stackView.edgesToSuperview()

        insertSubview(motionEffectSpaceshipImageView, belowSubview: stackView)
        motionEffectSpaceshipImageView.edgesToSuperview()
        setupSpaceshipImageWithMotionEffect()

        impressionLabel.withStyle(.impression) {
            $0.text(€.Label.header)
        }

        subtitleLabel.withStyle(.body) {
            $0.text(€.Label.body)
        }

        startButton.withStyle(.primary) {
            $0.title(€.Button.start)
        }
    }

    func setupSpaceshipImageWithMotionEffect() {
        motionEffectSpaceshipImageView.backgroundColor = .clear
        motionEffectSpaceshipImageView.translatesAutoresizingMaskIntoConstraints = false

        motionEffectSpaceshipImageView.addMotionEffectFromImageAssets(
            front: Image.spaceship,
            middle: Image.stars,
            back: Image.clouds
        )
    }
}
