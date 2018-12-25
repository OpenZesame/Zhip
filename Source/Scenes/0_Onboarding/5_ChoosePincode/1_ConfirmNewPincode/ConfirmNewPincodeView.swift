//
//  ConfirmNewPincodeView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias € = L10n.Scene.ConfirmNewPincode

final class ConfirmNewPincodeView: ScrollingStackView {

    private lazy var inputPincodeView               = InputPincodeView()
    private lazy var haveBackedUpPincodeCheckbox    = CheckboxWithLabel()
    private lazy var confirmPincodeButton           = UIButton()

    lazy var stackViewStyle: UIStackView.Style = [
        inputPincodeView,
        .spacer,
        haveBackedUpPincodeCheckbox,
        confirmPincodeButton
    ]

    override func setup() {
        setupSubviews()
    }
}

extension ConfirmNewPincodeView: ViewModelled {
    typealias ViewModel = ConfirmNewPincodeViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            pincode: inputPincodeView.rx.pincode.asDriver(),
            isHaveBackedUpPincodeCheckboxChecked: haveBackedUpPincodeCheckbox.rx.isChecked.asDriverOnErrorReturnEmpty(),
            confirmedTrigger: confirmPincodeButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: ConfirmNewPincodeViewModel.Output) -> [Disposable] {
        return [
            viewModel.inputBecomeFirstResponder --> inputPincodeView.rx.becomeFirstResponder,
            viewModel.pincodeValidation         --> inputPincodeView.rx.validation,
            viewModel.isConfirmPincodeEnabled   --> confirmPincodeButton.rx.isEnabled
        ]
    }
}

private extension ConfirmNewPincodeView {
    func setupSubviews() {

        haveBackedUpPincodeCheckbox.withStyle(.default) {
            $0.text(€.Checkbox.pincodeIsBackedUp)
        }

        confirmPincodeButton.withStyle(.primary) {
            $0.title(€.Button.done)
                .disabled()
        }
    }
}
