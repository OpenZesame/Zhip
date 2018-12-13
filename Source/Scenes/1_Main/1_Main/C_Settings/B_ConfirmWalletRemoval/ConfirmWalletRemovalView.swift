//
//  ConfirmWalletRemovalView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-12.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias € = L10n.Scene.ConfirmWalletRemoval

final class ConfirmWalletRemovalView: ScrollingStackView {

    private lazy var areYouSureLabel = UILabel(text: €.Label.areYouSure).withStyle(.title)

    private lazy var haveBackedUpWalletCheckbox = CheckboxWithLabel(titled: €.Checkbox.backUpWallet)

    private lazy var confirmButton = UIButton(title: €.Button.confirm)
        .withStyle(.primary) {
            $0.disabled()
    }

    lazy var stackViewStyle: UIStackView.Style = [
        areYouSureLabel,
        haveBackedUpWalletCheckbox,
        confirmButton,
        .spacer
    ]
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

