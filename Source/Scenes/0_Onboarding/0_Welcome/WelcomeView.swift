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
