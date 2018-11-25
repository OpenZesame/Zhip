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

    private lazy var haveBackedUpPincodeSwitch = UISwitch()
    private lazy var haveBackedUpPincodeShortLabel = UILabel(text: €.SwitchLabel.pincodeIsBackedUp).withStyle(.checkbox)

    private lazy var haveBackedUpPincodeStackView = UIStackView(arrangedSubviews: [haveBackedUpPincodeSwitch, haveBackedUpPincodeShortLabel]).withStyle(.horizontal)

    private lazy var confirmPincodeButton = UIButton(title: €.Button.confirmPincode)
        .withStyle(.primary)
        .disabled()

    lazy var stackViewStyle: UIStackView.Style = [
        inputPincodeView,
        haveBackedUpPincodeStackView,
        confirmPincodeButton,
        .spacer
    ]
}

extension ConfirmNewPincodeView: ViewModelled {
    typealias ViewModel = ConfirmNewPincodeViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            pincode: inputPincodeView.pincode,
            haveBackedUpPincode: haveBackedUpPincodeSwitch.rx.value.asDriverOnErrorReturnEmpty(),
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
