//
//  ConfirmNewPincodeView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

private typealias € = L10n.Scene.ConfirmNewPincode

final class ConfirmNewPincodeView: ScrollingStackView {

    private lazy var inputPincodeView = InputPincodeView(.setNew)

    private lazy var haveBackedUpPincodeSwitch = UISwitch()
    private lazy var haveBackedUpPincodeShortLabel = UILabel.Style(€.SwitchLabel.pincodeIsBackedUp).make()
    private lazy var haveBackedUpPincodeStackView = UIStackView.Style([haveBackedUpPincodeSwitch, haveBackedUpPincodeShortLabel], axis: .horizontal, margin: 0).make()

    private lazy var confirmPincodeButton = UIButton(type: .custom)
        .withStyle(.primary)
        .titled(normal: €.Button.confirmPincode)
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
            viewModel.isConfirmPincodeEnabled --> confirmPincodeButton.rx.isEnabled
        ]
    }
}
