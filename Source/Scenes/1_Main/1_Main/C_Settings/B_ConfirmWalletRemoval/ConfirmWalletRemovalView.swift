//
//  ConfirmWalletRemovalView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-12.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ConfirmWalletRemovalView: BaseSceneView {

    private lazy var areYouSureLabel = UILabel()

    private lazy var haveBackedUpWalletCheckbox = CheckboxWithLabel()

    private lazy var confirmButton = UIButton()

    lazy var stackViewStyle: UIStackView.Style = [
        areYouSureLabel,
        .spacer,
        haveBackedUpWalletCheckbox,
        confirmButton
    ]

    override func setup() {
        setupSubviews()
    }
}

extension ConfirmWalletRemovalView: ViewModelled {
    typealias ViewModel = ConfirmWalletRemovalViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.isConfirmButtonEnabled --> confirmButton.rx.isEnabled
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            confirmTrigger: confirmButton.rx.tap.asDriverOnErrorReturnEmpty(),
            isWalletBackedUpCheckboxChecked: haveBackedUpWalletCheckbox.rx.isChecked.asDriver()
        )
    }
}

private typealias € = L10n.Scene.ConfirmWalletRemoval
private extension ConfirmWalletRemovalView {
    func setupSubviews() {
        areYouSureLabel.withStyle(.header) {
            $0.text(€.Label.areYouSure)
        }

        haveBackedUpWalletCheckbox.withStyle(.default) {
            $0.text(€.Checkbox.backUpWallet)
        }

        confirmButton.withStyle(.primary) {
            $0.title(€.Button.confirm)
                .disabled()
        }
    }
}
