//
//  ChoosePincodeView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

extension UIButton {
    func disabled<B>() -> B where B: UIButton {
        isEnabled = false
        guard let button = self as? B else { incorrectImplementation("Bad cast") }
        return button
    }
}

private typealias € = L10n.Scene.ChoosePincode

final class ChoosePincodeView: ScrollingStackView {

    private lazy var inputPincodeView = InputPincodeView(.setNew)

    private lazy var pinOnlyLocksAppTextView = UITextView.Style(€.Text.pincodeOnlyLocksApp, isEditable: false, isSelectable: false).make()

    private lazy var proceedWithConfirmationButton = UIButton(type: .custom)
        .withStyle(.primary)
        .titled(normal: €.Button.proceedWithConfirmation)
        .disabled()

    lazy var stackViewStyle: UIStackView.Style = [
        inputPincodeView,
        pinOnlyLocksAppTextView,
        proceedWithConfirmationButton
    ]

    override func setup() {
        inputPincodeView.becomeFirstResponder()
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
            viewModel.isConfirmPincodeEnabled --> proceedWithConfirmationButton.rx.isEnabled
        ]
    }
}
