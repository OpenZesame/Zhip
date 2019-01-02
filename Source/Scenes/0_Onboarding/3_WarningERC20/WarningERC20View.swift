//
//  WarningERC20View.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class WarningERC20View: ScrollingStackView {

    private lazy var imageView                  = UIImageView()
    private lazy var headerLabel                = UILabel()
    private lazy var warningTextView            = UITextView()
    private lazy var understandCheckbox         = CheckboxWithLabel()
    private lazy var acceptButton               = UIButton()
    private lazy var doNotShowThisAgainButton   = UIButton()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        imageView,
        headerLabel,
        warningTextView,
        .spacer,
        understandCheckbox,
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
            viewModel.isAcceptButtonEnabled         --> acceptButton.rx.isEnabled,
            viewModel.isDoNotShowAgainButtonVisible --> doNotShowThisAgainButton.rx.isVisible
        ]
    }

    var inputFromView: InputFromView {

        return InputFromView(
            isUnderstandsERC20IncompatibilityCheckboxChecked: understandCheckbox.rx.isChecked.asDriver(),
            accept: acceptButton.rx.tap.asDriverOnErrorReturnEmpty(),
            doNotShowAgain: doNotShowThisAgainButton.rx.tap.asDriverOnErrorReturnEmpty()
        )

    }
}

private typealias € = L10n.Scene.WarningERC20
private typealias Image = Asset.Icons.Large
private extension WarningERC20View {
    func setupSubviews() {

        imageView.withStyle(.default) {
            $0.image(Image.warning.image)
        }

        headerLabel.withStyle(.header) {
            $0.text(€.Label.erc20Tokens)
        }

        warningTextView.withStyle(.nonEditable) {
            $0.text(€.Text.warningERC20)
        }

        understandCheckbox.withStyle(.default) {
            $0.text(€.Checkbox.understandsERC20Incompatibility)
        }

        acceptButton.withStyle(.primary) {
            $0.title(€.Button.accept).disabled()
        }

        doNotShowThisAgainButton.withStyle(.secondary) {
            $0.title(€.Button.doNotShowAgain)
        }
    }
}
