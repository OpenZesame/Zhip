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

    private lazy var inputPincodeView = InputPincodeView(.setNew)

    private lazy var haveBackedUpPincodeCheckbox = CheckboxWithLabel(titled: €.SwitchLabel.pincodeIsBackedUp)

    private lazy var confirmPincodeButton = UIButton(title: €.Button.confirmPincode)
        .withStyle(.primary)
        .disabled()

    lazy var stackViewStyle: UIStackView.Style = [
        inputPincodeView,
        haveBackedUpPincodeCheckbox,
        confirmPincodeButton,
        .spacer
    ]
}

extension ConfirmNewPincodeView: ViewModelled {
    typealias ViewModel = ConfirmNewPincodeViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            pincode: inputPincodeView.pincode,
            isHaveBackedUpPincodeCheckboxChecked: haveBackedUpPincodeCheckbox.rx.isChecked.asDriverOnErrorReturnEmpty(),
            confirmedTrigger: confirmPincodeButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: ConfirmNewPincodeViewModel.Output) -> [Disposable] {
        return [
            viewModel.inputBecomeFirstResponder --> inputPincodeView.rx.becomeFirstResponder,
            viewModel.isConfirmPincodeEnabled   --> confirmPincodeButton.rx.isEnabled
        ]
    }
}
