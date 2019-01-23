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

final class EnsureThatYouAreNotBeingWatchedView: ScrollableStackViewOwner {

    private lazy var imageView              = UIImageView()
    private lazy var headerLabel            = UILabel()
    private lazy var makeSureAloneLabel     = UILabel()
    private lazy var understandButton       = UIButton()

    lazy var stackViewStyle: UIStackView.Style = [
        imageView,
        headerLabel,
        makeSureAloneLabel,
        .spacer,
        understandButton
    ]

    override func setup() {
        setupSubviews()
    }
}

extension EnsureThatYouAreNotBeingWatchedView: ViewModelled {
    typealias ViewModel = EnsureThatYouAreNotBeingWatchedViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            understandTrigger: understandButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }
}

private typealias € = L10n.Scene.EnsureThatYouAreNotBeingWatched
private extension EnsureThatYouAreNotBeingWatchedView {
    func setupSubviews() {
        imageView.withStyle(.default) {
            $0.image(Asset.Icons.Large.shield.image)
        }

        headerLabel.withStyle(.header) {
            $0.text(€.Label.security)
        }

        makeSureAloneLabel.withStyle(.body) {
            $0.text(€.Label.makeSureAlone)
        }

        understandButton.withStyle(.primary) {
            $0.title(€.Button.understand)
        }
    }
}
