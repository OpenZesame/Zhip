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

private typealias € = L10n.Scene.WarningERC20

final class WarningERC20View: ScrollingStackView {

    private lazy var warningTextView = UITextView(text: €.Text.warningERC20).withStyle(.nonEditable)

    private lazy var acceptButton = UIButton(title: €.Button.accept).withStyle(.primary)

    private lazy var doNotShowThisAgainButton = UIButton(title: €.Button.doNotShowAgain).withStyle(.hollow)

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        warningTextView,
        acceptButton,
        doNotShowThisAgainButton
    ]
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
