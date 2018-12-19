//
//  ChoosePincodeView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

final class ChoosePincodeView: ScrollingStackView {

    private lazy var inputPincodeView               = InputPincodeView(.setNew)
    private lazy var pinOnlyLocksAppTextView        = UITextView()
    private lazy var proceedWithConfirmationButton  = UIButton()

    lazy var stackViewStyle: UIStackView.Style = [
        inputPincodeView,
        pinOnlyLocksAppTextView,
        proceedWithConfirmationButton
    ]

    override func setup() {
        setupSubviews()
    }
}

extension ChoosePincodeView: ViewModelled {
    typealias ViewModel = ChoosePincodeViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            pincode: inputPincodeView.pincode,
            confirmedTrigger: proceedWithConfirmationButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: ChoosePincodeViewModel.Output) -> [Disposable] {
        return [
            viewModel.inputBecomeFirstResponder --> inputPincodeView.rx.becomeFirstResponder,
            viewModel.isConfirmPincodeEnabled --> proceedWithConfirmationButton.rx.isEnabled
        ]
    }
}

private typealias € = L10n.Scene.ChoosePincode
private extension ChoosePincodeView {
    func setupSubviews() {
        pinOnlyLocksAppTextView.withStyle(.nonSelectable) {
            $0.text(€.Text.pincodeOnlyLocksApp)
        }

        proceedWithConfirmationButton.withStyle(.primary) {
            $0.title(€.Button.proceedWithConfirmation)
                .disabled()
        }
    }
}
