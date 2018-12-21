//
//  WarningERC20View.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class WarningERC20View: ScrollingStackView {

    private lazy var warningTextView            = UITextView()
    private lazy var acceptButton               = UIButton()
    private lazy var doNotShowThisAgainButton   = UIButton()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        warningTextView,
        acceptButton,
        doNotShowThisAgainButton
    ]

    override func setup() {
        setupSubviews()
    }
}

extension WarningERC20View: ViewModelled {
    typealias ViewModel = WarningERC20ViewModel

    func populate(with viewModel: WarningERC20ViewModel.Output) -> [Disposable] {
        return [
            viewModel.isDoNotShowAgainButtonVisible --> doNotShowThisAgainButton.rx.isVisible
        ]
    }

    var inputFromView: InputFromView {

        return InputFromView(
            accept: acceptButton.rx.tap.asDriverOnErrorReturnEmpty(),
            doNotShowAgain: doNotShowThisAgainButton.rx.tap.asDriverOnErrorReturnEmpty()
        )

    }
}

private typealias € = L10n.Scene.WarningERC20
private extension WarningERC20View {
    func setupSubviews() {

        warningTextView.withStyle(.nonEditable) {
            $0.text(€.Text.warningERC20)
        }

        acceptButton.withStyle(.primary) {
            $0.title(€.Button.accept)
        }

        doNotShowThisAgainButton.withStyle(.secondary) {
            $0.title(€.Button.doNotShowAgain)
        }
    }
}
