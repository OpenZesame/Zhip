//
//  ChoosePincodeView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

private typealias € = L10n.Scene.ChoosePincode

final class ChoosePincodeView: ScrollingStackView {

    private lazy var inputPincodeView = InputPincodeView(.setNew)

    private lazy var pinOnlyLocksAppTextView = UITextView.Style(€.Text.pincodeOnlyLocksApp, isEditable: false, isSelectable: false).make()

    private lazy var proceedWithConfirmationButton = UIButton.Style(€.Button.proceedWithConfirmation, isEnabled: false).make()

    lazy var stackViewStyle: UIStackView.Style = [
        inputPincodeView,
        pinOnlyLocksAppTextView,
        proceedWithConfirmationButton
    ]
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
