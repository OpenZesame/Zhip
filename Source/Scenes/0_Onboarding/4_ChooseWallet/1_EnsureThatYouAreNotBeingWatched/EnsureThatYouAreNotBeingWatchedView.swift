//
//  EnsureThatYouAreNotBeingWatchedView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-22.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class EnsureThatYouAreNotBeingWatchedView: ScrollingStackView {

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
